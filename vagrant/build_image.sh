#!/bin/sh

#create flashable roots as root
dd if=/dev/zero of=rootfs.raw bs=1024 count=1048576
/sbin/sfdisk --in-order --Linux --unit M rootfs.raw << EOF
1,32,0xB,*
,,,-
EOF

kpartx -avs rootfs.raw
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
cp /vagrant/eth0 /mnt/rootfs/etc/network/interfaces.d/

umount /mnt/boot/
umount /mnt/rootfs/
kpartx -dv rootfs.raw

dd if=u-boot-2015.04/u-boot-sunxi-with-spl.bin of=rootfs.raw bs=1024 seek=8 conv=notrunc

mv rootfs.raw /vagrant/$1/
