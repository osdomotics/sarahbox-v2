#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

wget -c https://www.kernel.org/pub/linux/kernel/v4.x/linux-$1.tar.xz
echo unpacking new kernel...
tar -xf linux-$1.tar.xz
cp /vagrant/kernel-config-$LINUXVER linux-$1/.config
cd linux-$1

make ARCH=arm oldconfig
