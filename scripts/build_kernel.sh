#!/bin/sh
set -e

. ./settings.sh

wget -c https://www.kernel.org/pub/linux/kernel/$LINUXVER_FOLDER/linux-$LINUXVER.tar.xz
echo unpacking kernel...
tar -xf linux-$LINUXVER.tar.xz
echo building kernel...
cp ./kernel-config-$LINUXVER linux-$LINUXVER/.config
cd linux-$LINUXVER

make ARCH=arm KBUILD_DEBARCH=armhf KDEB_PKGVERSION=$LINUXVER-$LINUXPKGVER deb-pkg
