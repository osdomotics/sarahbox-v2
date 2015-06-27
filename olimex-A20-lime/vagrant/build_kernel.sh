#!/bin/sh

wget -c https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.1.tar.xz
tar -xf linux-4.1.tar.xz
cp /vagrant/kernel-config-4.1 linux-4.1/.config
cd linux-4.1
sed -i s/\$\(CROSS_COMPILE\)gcc/\$\(CROSS_COMPILE\)gcc-4.9/ Makefile

make ARCH=arm zImage dtbs
