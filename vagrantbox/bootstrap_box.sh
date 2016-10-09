#!/bin/sh

#enable contrib repo for virtualbox guest addons
sed -i "s/deb http:\/\/httpredir.debian.org\/debian jessie main/deb http:\/\/httpredir.debian.org\/debian jessie main contrib/" /etc/apt/sources.list

apt-get update
# base tools :)
apt-get install -y vim curl
# virtualbox guest addons
apt-get install -y virtualbox-guest-dkms

# add embedian cross toolchain repo
curl --silent http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/emdebian.list
dpkg --add-architecture armhf
apt-get update

# build tools
apt-get install -y binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools device-tree-compiler ncurses-dev zerofree

#cleanup
rm -f /var/cache/apt/*pkgcache.bin /var/cache/apt/archives/* /var/lib/apt/lists/*
sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/" /etc/default/grub
update-grub2


echo now boot the vm manually in recovery mode and run:
echo systemctl stop networking
echo mount -o remount,ro /
echo zerofree /dev/sda1
echo shutdown -h 0
echo
echo adjust box memory and other settings in virtualbox
echo and export the box with \'vagrant package\'
shutdown -h 0
