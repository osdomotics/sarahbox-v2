#!/bin/sh

. /vagrant/vagrant/settings.sh

wget -c ftp://ftp.denx.de/pub/u-boot/u-boot-$UBOOTVER.tar.bz2
tar -xf u-boot-$UBOOTVER.tar.bz2
cd u-boot-$UBOOTVER
make CROSS_COMPILE=arm-linux-gnueabihf- `cat /vagrant/$1/uboot.conf`
make CROSS_COMPILE=arm-linux-gnueabihf-
