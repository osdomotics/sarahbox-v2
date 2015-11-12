#!/bin/sh

#add embedian cross toolchain repo
curl --silent http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
#add following line to sources
echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/emdebian.list
dpkg --add-architecture armhf
apt-get update
# base tools :)
apt-get install -y vim
# build tools
apt-get install -y binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools device-tree-compiler ncurses-dev zerofree

#cleanup
rm -f /var/cache/apt/*pkgcache.bin /var/cache/apt/archives/* /var/lib/apt/lists/*
sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/" /etc/default/grub
update-grub2
#now boot the vm manually in recovery mode and run:
#systemctl stop networking
#mount -o remount,ro /
#zerofree /dev/sda1
#shutdown -h 0

#adjust box memory and other settings in virtualbox
#and export the box with
#vagrant package
