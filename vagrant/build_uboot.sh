#!/bin/sh

wget -c ftp://ftp.denx.de/pub/u-boot/u-boot-2015.07.tar.bz2
tar -xf u-boot-2015.07.tar.bz2
cd u-boot-2015.07
make CROSS_COMPILE=arm-linux-gnueabihf- `cat /vagrant/$1/uboot.conf`
make CROSS_COMPILE=arm-linux-gnueabihf-
