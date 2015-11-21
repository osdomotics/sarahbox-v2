#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

wget -c https://www.kernel.org/pub/linux/kernel/v4.x/linux-$LINUXVER.tar.xz
tar -xf linux-$LINUXVER.tar.xz
cp /vagrant/kernel-config-$LINUXVER linux-$LINUXVER/.config
cd linux-$LINUXVER

make ARCH=arm KBUILD_DEBARCH=armhf KDEB_PKGVERSION=$LINUXVER-$LINUXPKGVER deb-pkg
