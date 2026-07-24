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

rm $EXTRACT/squashfs-root/tmp/customize.sh
for d in sys proc dev/pts dev; do
  umount $EXTRACT/squashfs-root/$d
done

mksquashfs $EXTRACT/squashfs-root $EXTRACT/casper/filesystem.squashfs \
  -comp zstd -Xcompression-level 19 -noappend

printf $(du -sx --block-size=1 $EXTRACT/squashfs-root | cut -f1) \
  > $EXTRACT/casper/filesystem.size

mkdir -p $EXTRACT/preseed
cp config/preseed.cfg $EXTRACT/preseed/bacha.seed

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
  chroot $EXTRACT/squashfs-root bash -c "dbus-launch flatpak list --app --columns=application,name,version,size" \
  > output/flatpak-apps-$EDITION.txt 2>/dev/null || echo "Flatpak list lỗi, cần kiểm tra thủ công" > output/flatpak-apps-$EDITION.txt
  # === Liệt kê app cài qua Flatpak (nếu ISO gốc có sẵn Flatpak) ===
if chroot $EXTRACT/squashfs-root which flatpak &>/dev/null; then
  chroot $EXTRACT/squashfs-root flatpak list --app \
    --columns=application,name,version,size \
    > output/flatpak-apps-$EDITION.txt 2>/dev/null || true

  echo "=== Flatpak apps đã cài sẵn ($EDITION) ==="
  cat output/flatpak-apps-$EDITION.txt
else
  echo "Không có Flatpak trong ISO gốc ($EDITION)" > output/flatpak-apps-$EDITION.txt
fi
