#!/bin/sh

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

mkdir -p /mnt/boot
mkdir -p /mnt/rootfs

mount /dev/mapper/loop0p1 /mnt/boot/
mount /dev/mapper/loop0p2 /mnt/rootfs/

cp linux-4.1/arch/arm/boot/zImage /mnt/boot
cp linux-4.1/arch/arm/boot/dts/`cat /vagrant/$1/dts.conf` /mnt/boot
mkimage -C none -A arm -T script -d /vagrant/$1/boot.cmd /mnt/boot/boot.scr
cp -ra armjessiechroot/* /mnt/rootfs

umount /mnt/boot/
umount /mnt/rootfs/
kpartx -dv $IMG_NAME

dd if=u-boot-2015.04/u-boot-sunxi-with-spl.bin of=$IMG_NAME bs=1024 seek=8 conv=notrunc

mv $IMG_NAME /vagrant/
