#!/bin/sh
set -e
. /vagrant/vagrant/settings.sh

CHROOT_DIR="arm${DEBIANVER}chroot"
IMG_NAME=sarahbox_$1.img

#create flashable roots as root
dd if=/dev/zero of=$IMG_NAME bs=1024 count=1048576
/sbin/sfdisk $IMG_NAME << EOF
label:dos
start=2048,bootable
EOF

LOOP=`kpartx -avs sarahbox_olimex-A20-lime.img | cut -d ' ' -f 3`
mkfs.ext4 /dev/mapper/$LOOP -L rootfs

mkdir -p /mnt/rootfs

mount /dev/mapper/$LOOP /mnt/rootfs/

cp -ra ${CHROOT_DIR}/* /mnt/rootfs

export LC_ALL=C
export LANGUAGE=C
export LANG=C

rm -f /mnt/rootfs/usr/bin/qemu-arm-static

mkimage -C none -A arm -T script -d /vagrant/$1/boot.cmd /mnt/rootfs/boot/boot.scr

umount /mnt/rootfs/
zerofree /dev/mapper/$LOOP
sync
kpartx -dvs $IMG_NAME

dd if=u-boot-$UBOOTVER/u-boot-sunxi-with-spl.bin of=$IMG_NAME bs=1024 seek=8 conv=notrunc

if [ "$2" = "--compress" ]; then
    echo "Compress image"
    xz --best $IMG_NAME
    IMG_NAME = $IMG_NAME.xz
fi

mv $IMG_NAME /vagrant/
