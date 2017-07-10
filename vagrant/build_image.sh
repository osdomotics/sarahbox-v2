#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

IMG_NAME=sarahbox_$1.img

#create flashable roots as root
dd if=/dev/zero of=$IMG_NAME bs=1024 count=1048576
/sbin/sfdisk $IMG_NAME << EOF
start=2048,bootable
EOF

kpartx -avs $IMG_NAME
mkfs.ext4 /dev/mapper/loop0p1 -L rootfs

mkdir -p /mnt/rootfs

mount /dev/mapper/loop0p1 /mnt/rootfs/

cp -ra armjessiechroot/* /mnt/rootfs

export LC_ALL=C
export LANGUAGE=C
export LANG=C
# tunslip6
if [ -e /vagrant/$1/tunslip6/*.conf ]; then
  for tunslipconfig in /vagrant/$1/tunslip6/*.conf
  do
    cp $tunslipconfig /mnt/rootfs/etc/tunslip6/;
    chroot /mnt/rootfs systemctl enable tunslip6@`basename $tunslipconfig .conf`.service;
  done
fi
rm -f /mnt/rootfs/usr/bin/qemu-arm-static

mkimage -C none -A arm -T script -d /vagrant/$1/boot.cmd /mnt/rootfs/boot/boot.scr

umount /mnt/rootfs/
zerofree /dev/mapper/loop0p1
kpartx -dvs $IMG_NAME

dd if=u-boot-$UBOOTVER/u-boot-sunxi-with-spl.bin of=$IMG_NAME bs=1024 seek=8 conv=notrunc

if [ "$2" = "--compress" ]; then
    echo "Compress image"
    xz --best $IMG_NAME
    IMG_NAME = $IMG_NAME.xz
fi

mv $IMG_NAME /vagrant/
