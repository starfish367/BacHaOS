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

# === Liệt kê app Flatpak (chạy TRƯỚC khi umount, còn trong chroot) ===
if chroot $EXTRACT/squashfs-root which flatpak &>/dev/null; then
  chroot $EXTRACT/squashfs-root bash -c "dbus-launch flatpak list --app --columns=application,name,version,size" \
    > output/flatpak-apps-$EDITION.txt 2>/dev/null || echo "Flatpak list lỗi" > output/flatpak-apps-$EDITION.txt
else
  echo "Không có Flatpak trong ISO gốc ($EDITION)" > output/flatpak-apps-$EDITION.txt
fi
echo "=== Flatpak apps ($EDITION) ==="
cat output/flatpak-apps-$EDITION.txt

for d in sys proc dev/pts dev; do
  umount $EXTRACT/squashfs-root/$d
done

# === Overlay: chèn TOÀN BỘ shortcut TRƯỚC khi đóng gói squashfs ===
mkdir -p $EXTRACT/squashfs-root/etc/skel/Desktop

# --- Zalo ---
mkdir -p $EXTRACT/squashfs-root/opt/zalo
cp assets/zalo/logo-zalo-vector-03.png $EXTRACT/squashfs-root/opt/zalo/
cp assets/zalo/zalo.desktop $EXTRACT/squashfs-root/usr/share/applications/
cp assets/zalo/zalo.desktop $EXTRACT/squashfs-root/etc/skel/Desktop/
