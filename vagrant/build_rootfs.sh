#!/bin/sh
set -e

#get base
debootstrap --arch=armhf --foreign jessie armjessiechroot http://httpredir.debian.org/debian
#copy qemu for binfmt inside chroot
cp /usr/bin/qemu-arm-static armjessiechroot/usr/bin
#run second stage of debootstrap
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true  LC_ALL=C LANGUAGE=C LANG=C chroot armjessiechroot /debootstrap/debootstrap --second-stage
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true  LC_ALL=C LANGUAGE=C LANG=C chroot armjessiechroot dpkg --configure -a
echo sarahbox > armjessiechroot/etc/hostname
echo "APT::Install-Recommends \"0\";" > armjessiechroot/etc/apt/apt.conf.d/99disable-recommends
sed -ie "s/127.0.0.1\\slocalhost/127.0.0.1\\tlocalhost sarahbox/" armjessiechroot/etc/hosts
chroot armjessiechroot passwd << EOF
root
root
EOF

echo "/dev/mmcblk0p2 / ext4 errors=remount-ro 0 1
/dev/mmcblk0p1 /boot vfat defaults 0 0" > armjessiechroot/etc/fstab

echo "deb http://httpredir.debian.org/debian jessie-backports main" > armjessiechroot/etc/apt/sources.list.d/backports.list
echo "package: *
Pin: release a=jessie-backports
Pin-Priority: 200" > armjessiechroot/etc/apt/preferences.d/backportspin.conf
chroot armjessiechroot apt-get update
chroot armjessiechroot apt-get install -yt jessie-backports nftables
chroot armjessiechroot apt-get install -y openssh-server vim usbutils ntp
chroot armjessiechroot adduser osd << EOF
osd
osd





y
EOF
wget -c https://github.com/contiki-os/contiki/raw/2.7/tools/tunslip6.c
arm-linux-gnueabihf-gcc-4.9 tunslip6.c -o tunslip6
mv tunslip6 armjessiechroot/usr/local/bin
cp /vagrant/tunslip6.service armjessiechroot/lib/systemd/system/
chroot armjessiechroot systemctl enable tunslip6.service
cp /vagrant/eth0 armjessiechroot/etc/network/interfaces.d/

#clean up rootfs a bit
rm -f armjessiechroot/var/cache/apt/archives/*.deb
rm -f armjessiechroot/var/cache/apt/archives/partial/*
