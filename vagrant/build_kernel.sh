#!/bin/sh

LINUXVER=4.2

wget -c https://www.kernel.org/pub/linux/kernel/v4.x/linux-$LINUXVER.tar.xz
tar -xf linux-$LINUXVER.tar.xz
cp /vagrant/kernel-config-$LINUXVER linux-$LINUXVER/.config
cd linux-$LINUXVER

make ARCH=arm zImage dtbs
