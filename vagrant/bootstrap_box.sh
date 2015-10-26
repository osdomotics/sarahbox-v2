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
apt-get install -y binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools device-tree-compiler
