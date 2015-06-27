#!/bin/sh

wget -c ftp://ftp.denx.de/pub/u-boot/u-boot-2015.04.tar.bz2
tar -xf u-boot-2015.04.tar.bz2
cd u-boot-2015.04
make CROSS_COMPILE=arm-linux-gnueabihf- A20-OLinuXino-Lime_defconfig
make CROSS_COMPILE=arm-linux-gnueabihf-
