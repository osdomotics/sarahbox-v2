#!/bin/sh

dpkg --add-architecture armhf
apt-get update

# build tools
apt-get install -y vim curl binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools device-tree-compiler ncurses-dev zerofree bc swig bison flex libpython-dev apt-transport-https

#cleanup
rm -f /var/cache/apt/*pkgcache.bin /var/cache/apt/archives/* /var/lib/apt/lists/*

unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

find /var/log -type -f -delete

echo ------------------------------------------------------
echo BOX PREPARED
echo ------------------------------------------------------
echo "now finalize the box (size optimize) with ./finalize.sh"
echo and export the box with \'vagrant package\'
shutdown -h 0
