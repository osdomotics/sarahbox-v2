#!/bin/sh
set -e

. ./settings.sh

wget -c https://www.kernel.org/pub/linux/kernel/$LINUXVER_FOLDER/linux-$1.tar.xz
echo unpacking new kernel...
tar -xf linux-$1.tar.xz
cp ./kernel-config-$LINUXVER linux-$1/.config
cd linux-$1

make ARCH=arm oldconfig
