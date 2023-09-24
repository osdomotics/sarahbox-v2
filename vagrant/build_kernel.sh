#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

echo downloading kernel...
curl -LJOC - "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$LINUXVER.tar.xz"

echo unpacking kernel...
rm -rf "linux-$LINUXVER/" "linux-upstream_$LINUXVER.orig.tar.xz"
ln -s "linux-$LINUXVER.tar.xz" "linux-upstream_$LINUXVER.orig.tar.xz"
tar -xf linux-$LINUXVER.tar.xz

echo configuring kernel...
cd "linux-$LINUXVER"
# scripts/package/mkdebian requires some generated files
cp "/vagrant/kernel-config-$LINUXVER" .config
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- prepare
MAKE=make ARCH=arm KERNELRELEASE=$LINUXVER KDEB_SOURCENAME=linux-upstream KBUILD_DEBARCH=armhf KDEB_PKGVERSION=$LINUXVER-$LINUXPKGVER scripts/package/mkdebian
# cleanup generated files for dpkg-source
make clean
rm -r arch/arm/include/generated include/generated include/config
rm scripts/mod/devicetable-offsets.h scripts/mod/elfconfig.h scripts/basic/fixdep scripts/dtc/dtc scripts/dtc/fdtoverlay scripts/kallsyms scripts/kconfig/conf scripts/mod/mk_elfconfig scripts/mod/modpost scripts/sorttable scripts/asn1_compiler .config

# osd config and patches
cp -r /vagrant/kernel-patches debian/patches
mkdir -p debian/source
echo "3.0 (quilt)" > debian/source/format
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
quilt push -a
quilt new kernelconfig.diff
quilt add .config
cp "/vagrant/kernel-config-$LINUXVER" .config
quilt refresh
quilt pop -a

echo building kernel...
CROSS_COMPILE=arm-linux-gnueabihf- dpkg-buildpackage -aarmhf -rfakeroot -us -uc
