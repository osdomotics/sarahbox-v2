#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

IMG_NAME=sarahbox_$1.img

#create flashable roots as root
dd if=/dev/zero of=$IMG_NAME bs=1024 count=1048576
/sbin/sfdisk --in-order --Linux --unit M $IMG_NAME << EOF
1,32,0xB,*
,,,-
EOF

kpartx -avs $IMG_NAME
mkfs.vfat -F 16 /dev/mapper/loop0p1 -n boot
mkfs.ext4 /dev/mapper/loop0p2 -L rootfs

mkdir -p /mnt/uboot
mkdir -p /mnt/rootfs

mount /dev/mapper/loop0p1 /mnt/uboot/
mount /dev/mapper/loop0p2 /mnt/rootfs/

cp -ra armjessiechroot/* /mnt/rootfs
rm -rf /mnt/rootfs/uboot/*
cp -ra armjessiechroot/uboot/* /mnt/uboot
mkimage -C none -A arm -T script -d /vagrant/$1/boot.cmd /mnt/uboot/boot.scr

umount /mnt/rootfs/
zerofree /dev/mapper/loop0p2
umount /mnt/uboot/
kpartx -dvs $IMG_NAME

dd if=u-boot-$UBOOTVER/u-boot-sunxi-with-spl.bin of=$IMG_NAME bs=1024 seek=8 conv=notrunc

mv $IMG_NAME /vagrant/
