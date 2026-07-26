#!/bin/bash
set -e

ISO=$1
VERSION=${2:-0.1}
EDITION=${3:-mate}
WORKDIR=$(pwd)/remaster-$EDITION
MOUNT=$WORKDIR/mnt
EXTRACT=$WORKDIR/extract
mkdir -p $MOUNT $EXTRACT output

mount -o loop "$ISO" $MOUNT
rsync -a $MOUNT/ $EXTRACT/ --exclude=/casper/filesystem.squashfs
unsquashfs -d $EXTRACT/squashfs-root $MOUNT/casper/filesystem.squashfs
umount $MOUNT

for d in dev dev/pts proc sys; do
  mount --bind /$d $EXTRACT/squashfs-root/$d
done
cp /etc/resolv.conf $EXTRACT/squashfs-root/etc/resolv.conf

cp scripts/customize.sh $EXTRACT/squashfs-root/tmp/
cp config/packages.list $EXTRACT/squashfs-root/tmp/
cp config/remove-$EDITION.list $EXTRACT/squashfs-root/tmp/remove.list
chroot $EXTRACT/squashfs-root /bin/bash /tmp/customize.sh "$VERSION" "$EDITION"
rm -f $EXTRACT/squashfs-root/tmp/customize.sh

# === Liệt kê Flatpak (còn trong chroot) ===
if chroot $EXTRACT/squashfs-root which flatpak &>/dev/null; then
  chroot $EXTRACT/squashfs-root bash -c "dbus-launch flatpak list --app --columns=application,name,version,size" \
    > output/flatpak-apps-$EDITION.txt 2>/dev/null || echo "Flatpak list lỗi" > output/flatpak-apps-$EDITION.txt
else
  echo "Không có Flatpak trong ISO gốc ($EDITION)" > output/flatpak-apps-$EDITION.txt
fi
echo "=== Flatpak apps ($EDITION) ==="
cat output/flatpak-apps-$EDITION.txt

# === Liệt kê toàn bộ gói apt đã cài (còn trong chroot) ===
chroot $EXTRACT/squashfs-root dpkg-query -W -f='${Package}\t${Installed-Size}\t${Version}\n' \
  | sort -k2 -n -r > output/installed-packages-$EDITION.txt
echo "=== Top 40 gói apt nặng nhất ($EDITION, KB) ==="
head -n 40 output/installed-packages-$EDITION.txt

# === Dọn tiến trình còn giữ /sys, /proc trước khi umount (tránh lỗi "target is busy") ===
chroot $EXTRACT/squashfs-root pkill -9 dbus-daemon 2>/dev/null || true
fuser -km $EXTRACT/squashfs-root/sys 2>/dev/null || true
fuser -km $EXTRACT/squashfs-root/proc 2>/dev/null || true
sleep 2

for d in sys proc dev/pts dev; do
  umount $EXTRACT/squashfs-root/$d 2>/dev/null || umount -l $EXTRACT/squashfs-root/$d
done

# === Overlay: chèn shortcut TRƯỚC khi đóng gói squashfs ===
mkdir -p $EXTRACT/squashfs-root/etc/skel/Desktop

# --- Zalo ---
mkdir -p $EXTRACT/squashfs-root/opt/zalo
cp assets/zalo/logo-zalo-vector-03.png $EXTRACT/squashfs-root/opt/zalo/
cp assets/zalo/zalo.desktop $EXTRACT/squashfs-root/usr/share/applications/
cp assets/zalo/zalo.desktop $EXTRACT/squashfs-root/etc/skel/Desktop/

# --- YouTube ---
mkdir -p $EXTRACT/squashfs-root/opt/youtube
cp assets/youtube/youtube.png $EXTRACT/squashfs-root/opt/youtube/
cp assets/youtube/youtube.desktop $EXTRACT/squashfs-root/usr/share/applications/
cp assets/youtube/youtube.desktop $EXTRACT/squashfs-root/etc/skel/Desktop/

# --- OnlyOffice ---
mkdir -p $EXTRACT/squashfs-root/opt/onlyoffice-templates
cp assets/onlyoffice-templates/blank.docx $EXTRACT/squashfs-root/opt/onlyoffice-templates/
cp assets/onlyoffice-templates/blank.xlsx $EXTRACT/squashfs-root/opt/onlyoffice-templates/
cp assets/onlyoffice-templates/blank.pptx $EXTRACT/squashfs-root/opt/onlyoffice-templates/
cp assets/onlyoffice-templates/open-word.sh $EXTRACT/squashfs-root/opt/onlyoffice-templates/
cp assets/onlyoffice-templates/open-excel.sh $EXTRACT/squashfs-root/opt/onlyoffice-templates/
cp assets/onlyoffice-templates/open-powerpoint.sh $EXTRACT/squashfs-root/opt/onlyoffice-templates/
chmod +x $EXTRACT/squashfs-root/opt/onlyoffice-templates/open-*.sh
cp assets/onlyoffice-templates/*.desktop $EXTRACT/squashfs-root/usr/share/applications/
cp assets/onlyoffice-templates/*.desktop $EXTRACT/squashfs-root/etc/skel/Desktop/

# --- Chrome ---
cp $EXTRACT/squashfs-root/usr/share/applications/google-chrome.desktop \
  $EXTRACT/squashfs-root/etc/skel/Desktop/ 2>/dev/null || true

chmod +x $EXTRACT/squashfs-root/etc/skel/Desktop/*.desktop

# === Đóng gói squashfs ===
mksquashfs $EXTRACT/squashfs-root $EXTRACT/casper/filesystem.squashfs \
  -comp zstd -Xcompression-level 19 -noappend

printf $(du -sx --block-size=1 $EXTRACT/squashfs-root | cut -f1) \
  > $EXTRACT/casper/filesystem.size

mkdir -p $EXTRACT/preseed
cp config/preseed.cfg $EXTRACT/preseed/bacha.seed

# === Đổi tên GRUB/isolinux ===
echo "=== Debug grub.cfg ==="
cat "$EXTRACT/boot/grub/grub.cfg" 2>/dev/null | grep -i "mint" || echo "Không thấy chữ Mint"
echo "=== Debug isolinux txt.cfg ==="
cat "$EXTRACT/isolinux/txt.cfg" 2>/dev/null | grep -i "mint" || echo "Không thấy chữ Mint"

if [ -f "$EXTRACT/boot/grub/grub.cfg" ]; then
  sed -i "s/Linux Mint [0-9]* [A-Za-z]*/Bạc Hà OS ${VERSION}/g" "$EXTRACT/boot/grub/grub.cfg"
  sed -i "s/Start Linux Mint/Khởi động Bạc Hà OS/g" "$EXTRACT/boot/grub/grub.cfg"
fi
if [ -f "$EXTRACT/isolinux/txt.cfg" ]; then
  sed -i "s/Linux Mint [0-9]* [A-Za-z]*/Bạc Hà OS ${VERSION}/g" "$EXTRACT/isolinux/txt.cfg"
fi
if [ -f "$EXTRACT/isolinux/isolinux.cfg" ]; then
  sed -i "s/Linux Mint/Bạc Hà OS/g" "$EXTRACT/isolinux/isolinux.cfg"
fi

cd $EXTRACT
find . -type f -not -path "./isolinux/*" -not -path "./casper/filesystem.squashfs" \
  -exec md5sum {} \; > md5sum.txt
cd $WORKDIR/..

xorriso -as mkisofs \
  -r -V "BACHAOS_${EDITION^^}" \
  -J -joliet-long \
  -isohybrid-mbr $EXTRACT/isolinux/isohdpfx.bin \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e boot/grub/efi.img \
  -no-emul-boot -isohybrid-gpt-basdat \
  -o output/bac-ha-os-${EDITION}-${VERSION}-$(date +%Y%m%d).iso \
  $EXTRACT
