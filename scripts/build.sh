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
c
