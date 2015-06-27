#!/bin/sh

#get base
debootstrap --arch=armhf --foreign jessie armjessiechroot
#copy qemu for binfmt inside chroot
cp /usr/bin/qemu-arm-static armjessiechroot/usr/bin
#run second stage of debootstrap
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true  LC_ALL=C LANGUAGE=C LANG=C chroot armjessiechroot /debootstrap/debootstrap --second-stage
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true  LC_ALL=C LANGUAGE=C LANG=C chroot armjessiechroot dpkg --configure -a
echo sarahbox > armjessiechroot/etc/hostname
chroot armjessiechroot passwd << EOF
root
root
EOF

chroot armjessiechroot apt-get update
chroot armjessiechroot apt-get install -y openssh-server vim
