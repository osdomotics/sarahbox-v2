#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

echo downloading kernel...
curl -LOC - "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$1.tar.xz"

echo unpacking new kernel...
tar -xf linux-$1.tar.xz
cp /vagrant/kernel-config-$LINUXVER linux-$1/.config
cd linux-$1

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
