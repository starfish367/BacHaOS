#!/usr/bin/env bash
# BacHaOS remaster pipeline: predictable paths, cleanup on every exit, release manifest and checksum.
set -Eeuo pipefail

if [[ $# -lt 1 ]]; then
  echo "Cách dùng: $0 <mint-base.iso> [version] [mate|cinnamon]" >&2
  exit 64
fi

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ISO=$(realpath -- "$1")
VERSION=${2:-0.1}
EDITION=${3:-mate}
WORKDIR="${ROOT_DIR}/remaster-${EDITION}"
MOUNT="${WORKDIR}/mnt"
EXTRACT="${WORKDIR}/extract"
CHROOT="${EXTRACT}/squashfs-root"
OUTPUT_DIR="${ROOT_DIR}/output"
BUILD_DATE=$(date -u +%Y%m%d)
ISO_FILENAME="bac-ha-os-${EDITION}-${VERSION}-${BUILD_DATE}.iso"
ISO_OUTPUT="${OUTPUT_DIR}/${ISO_FILENAME}"

case "$EDITION" in
  mate|cinnamon) ;;
  *) echo "Edition không hợp lệ: ${EDITION}" >&2; exit 64 ;;
esac

if [[ ! -f "$ISO" ]]; then
  echo "Không tìm thấy ISO gốc: $ISO" >&2
  exit 66
fi

require_commands=(mount umount rsync unsquashfs chroot mksquashfs xorriso md5sum sha256sum)
for command_name in "${require_commands[@]}"; do
  command -v "$command_name" >/dev/null 2>&1 || {
    echo "Thiếu lệnh cần thiết: ${command_name}" >&2
    exit 69
  }
done

unmount_chroot_mounts() {
  chroot "$CHROOT" pkill -9 dbus-daemon 2>/dev/null || true
  for mount_path in "${CHROOT}/sys" "${CHROOT}/proc" "${CHROOT}/dev/pts" "${CHROOT}/dev"; do
    if mountpoint -q "$mount_path"; then
      umount -l "$mount_path" || true
    fi
  done
}

cleanup() {
  local exit_status=$?
  unmount_chroot_mounts
  if mountpoint -q "$MOUNT"; then
    umount -l "$MOUNT" || true
  fi
  exit "$exit_status"
}
trap cleanup EXIT

mkdir -p "$MOUNT" "$EXTRACT" "$OUTPUT_DIR"

echo "==> Mount ISO gốc: $(basename "$ISO")"
mount -o loop "$ISO" "$MOUNT"
rsync -a "${MOUNT}/" "${EXTRACT}/" --exclude=/casper/filesystem.squashfs
unsquashfs -d "$CHROOT" "${MOUNT}/casper/filesystem.squashfs"
umount "$MOUNT"

for directory in dev dev/pts proc sys; do
  mount --bind "/${directory}" "${CHROOT}/${directory}"
done
cp /etc/resolv.conf "${CHROOT}/etc/resolv.conf"

install -m 0755 "${ROOT_DIR}/scripts/customize.sh" "${CHROOT}/tmp/customize.sh"
install -m 0644 "${ROOT_DIR}/config/packages.list" "${CHROOT}/tmp/packages.list"
install -m 0644 "${ROOT_DIR}/config/remove-${EDITION}.list" "${CHROOT}/tmp/remove.list"
chroot "$CHROOT" /bin/bash /tmp/customize.sh "$VERSION" "$EDITION"
rm -f "${CHROOT}/tmp/customize.sh" "${CHROOT}/tmp/packages.list" "${CHROOT}/tmp/remove.list"

echo "==> Thu thập báo cáo gói"
if chroot "$CHROOT" /usr/bin/env bash -c 'command -v flatpak' >/dev/null 2>&1; then
  chroot "$CHROOT" bash -c 'dbus-launch flatpak list --app --columns=application,name,version,size 2>/dev/null || true' \
    > "${OUTPUT_DIR}/flatpak-apps-${EDITION}.txt"
else
  printf '%s\n' "Flatpak không có trong ISO gốc (${EDITION})" > "${OUTPUT_DIR}/flatpak-apps-${EDITION}.txt"
fi
# shellcheck disable=SC2016 # dpkg-query parses its own placeholder format.
chroot "$CHROOT" dpkg-query -W -f='${Package}\t${Installed-Size}\t${Version}\n' \
  | sort -k2 -n -r > "${OUTPUT_DIR}/installed-packages-${EDITION}.txt"

echo "==> Dọn các bind mount chroot trước khi đóng gói"
unmount_chroot_mounts

echo "==> Thêm shortcut và asset Bạc Hà OS"
install -d "${CHROOT}/etc/skel/Desktop" "${CHROOT}/usr/share/applications"

install -d "${CHROOT}/opt/zalo"
install -m 0644 "${ROOT_DIR}/assets/zalo/logo-zalo-vector-03.png" "${CHROOT}/opt/zalo/"
install -m 0644 "${ROOT_DIR}/assets/zalo/zalo.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/zalo/zalo.desktop" "${CHROOT}/etc/skel/Desktop/"

install -d "${CHROOT}/opt/youtube"
install -m 0644 "${ROOT_DIR}/assets/youtube/youtube.png" "${CHROOT}/opt/youtube/"
install -m 0644 "${ROOT_DIR}/assets/youtube/youtube.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/youtube/youtube.desktop" "${CHROOT}/etc/skel/Desktop/"

install -d "${CHROOT}/opt/onlyoffice-templates"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/blank.docx" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/blank.xlsx" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/blank.pptx" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0755 "${ROOT_DIR}/assets/onlyoffice-templates/open-word.sh" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0755 "${ROOT_DIR}/assets/onlyoffice-templates/open-excel.sh" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0755 "${ROOT_DIR}/assets/onlyoffice-templates/open-powerpoint.sh" "${CHROOT}/opt/onlyoffice-templates/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/word.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/excel.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/powerpoint.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/word.desktop" "${CHROOT}/etc/skel/Desktop/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/excel.desktop" "${CHROOT}/etc/skel/Desktop/"
install -m 0644 "${ROOT_DIR}/assets/onlyoffice-templates/powerpoint.desktop" "${CHROOT}/etc/skel/Desktop/"

if [[ -f "${CHROOT}/usr/share/applications/google-chrome.desktop" ]]; then
  install -m 0644 "${CHROOT}/usr/share/applications/google-chrome.desktop" "${CHROOT}/etc/skel/Desktop/"
fi

install -d "${CHROOT}/opt/bacha-os-hello" "${CHROOT}/etc/xdg/autostart"
install -m 0755 "${ROOT_DIR}/assets/bacha-os-hello/bacha-os-hello" "${CHROOT}/opt/bacha-os-hello/"
install -m 0644 "${ROOT_DIR}/assets/bacha-os-hello/bacha-os-hello.svg" "${CHROOT}/opt/bacha-os-hello/"
install -m 0644 "${ROOT_DIR}/assets/bacha-os-hello/bacha-os-hello.desktop" "${CHROOT}/usr/share/applications/"
install -m 0644 "${ROOT_DIR}/assets/bacha-os-hello/bacha-os-hello.desktop" "${CHROOT}/etc/skel/Desktop/"
install -m 0644 "${ROOT_DIR}/assets/bacha-os-hello/bacha-os-hello-autostart.desktop" "${CHROOT}/etc/xdg/autostart/"
chmod +x "${CHROOT}/etc/skel/Desktop/"*.desktop

install -d "${CHROOT}/usr/share/plymouth/themes/bacha"
install -m 0644 "${ROOT_DIR}/assets/plymouth/bacha-logo-512.png" "${CHROOT}/usr/share/plymouth/themes/bacha/"
install -m 0644 "${ROOT_DIR}/assets/plymouth/bacha.plymouth" "${CHROOT}/usr/share/plymouth/themes/bacha/"
install -m 0644 "${ROOT_DIR}/assets/plymouth/bacha.script" "${CHROOT}/usr/share/plymouth/themes/bacha/"

install -d "${CHROOT}/usr/share/backgrounds/bacha"
install -m 0644 "${ROOT_DIR}/assets/wallpaper/"*.jpg "${CHROOT}/usr/share/backgrounds/bacha/"

echo "==> Đóng gói filesystem.squashfs"
mksquashfs "$CHROOT" "${EXTRACT}/casper/filesystem.squashfs" -comp zstd -Xcompression-level 19 -noappend
rm -rf "$CHROOT"
printf '%s' "$(du -sx --block-size=1 "${EXTRACT}/casper/filesystem.squashfs" | cut -f1)" > "${EXTRACT}/casper/filesystem.size"

install -d "${EXTRACT}/preseed"
install -m 0644 "${ROOT_DIR}/config/preseed.cfg" "${EXTRACT}/preseed/bacha.seed"

if [[ -f "${EXTRACT}/boot/grub/grub.cfg" ]]; then
  sed -i "s/Linux Mint [0-9.]* [A-Za-z]*/Bạc Hà OS ${VERSION}/g; s/Start Linux Mint/Khởi động Bạc Hà OS/g" "${EXTRACT}/boot/grub/grub.cfg"
fi
if [[ -f "${EXTRACT}/isolinux/txt.cfg" ]]; then
  sed -i "s/Linux Mint [0-9.]* [A-Za-z]*/Bạc Hà OS ${VERSION}/g" "${EXTRACT}/isolinux/txt.cfg"
fi
if [[ -f "${EXTRACT}/isolinux/isolinux.cfg" ]]; then
  sed -i "s/Linux Mint/Bạc Hà OS/g" "${EXTRACT}/isolinux/isolinux.cfg"
fi

(
  cd "$EXTRACT"
  find . -type f -not -path "./isolinux/*" -not -path "./casper/filesystem.squashfs" -print0 \
    | sort -z \
    | xargs -0 md5sum > md5sum.txt
)

ISOHYBRID_MBR=/usr/lib/ISOLINUX/isohdpfx.bin
if [[ ! -f "$ISOHYBRID_MBR" ]]; then
  echo "Không tìm thấy isohdpfx.bin tại ${ISOHYBRID_MBR}" >&2
  exit 69
fi
if [[ ! -f "${EXTRACT}/isolinux/isolinux.bin" || ! -f "${EXTRACT}/boot/grub/efi.img" ]]; then
  echo "ISO gốc không có thành phần boot BIOS/UEFI bắt buộc" >&2
  exit 65
fi

echo "==> Tạo ISO ${ISO_FILENAME}"
xorriso -as mkisofs \
  -iso-level 3 -r -V "BACHAOS_${EDITION^^}" -J -joliet-long \
  -isohybrid-mbr "$ISOHYBRID_MBR" \
  -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
  -o "$ISO_OUTPUT" "$EXTRACT"

ISO_SHA256=$(sha256sum "$ISO_OUTPUT" | awk '{print $1}')
printf '%s  %s\n' "$ISO_SHA256" "$ISO_FILENAME" > "${ISO_OUTPUT}.sha256"
cat > "${OUTPUT_DIR}/release-${EDITION}.env" <<EOF
EDITION=${EDITION}
ISO_FILENAME=${ISO_FILENAME}
ISO_SHA256=${ISO_SHA256}
SOURCEFORGE_ISO_URL=https://sourceforge.net/projects/bac-ha-os/files/${ISO_FILENAME}/download
SOURCEFORGE_SHA256_URL=https://sourceforge.net/projects/bac-ha-os/files/${ISO_FILENAME}.sha256/download
EOF

echo "==> Hoàn tất ${ISO_FILENAME}"
