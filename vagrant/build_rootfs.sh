#!/bin/sh
set -e

#debootstrap stage1
if [ ! -e armjessiechroot/var/log/bootstrap.log ]; then
    #get base
    debootstrap --arch=armhf --foreign jessie armjessiechroot http://httpredir.debian.org/debian
fi

#qemu for chroot and some env settings to make apt run by itself
cp /usr/bin/qemu-arm-static armjessiechroot/usr/bin
export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C
export LANGUAGE=C
export LANG=C

#debootstrap stage2
if [ ! -e armjessiechroot/var/log/bootstrap.log ]; then
    chroot armjessiechroot /debootstrap/debootstrap --second-stage
    chroot armjessiechroot dpkg --configure -a
fi

#fstab
echo "/dev/mmcblk0p2 / ext4 errors=remount-ro 0 1
/dev/mmcblk0p1 /uboot vfat defaults 0 0" > armjessiechroot/etc/fstab

#hostname
echo sarahbox > armjessiechroot/etc/hostname
sed -ie "s/127.0.0.1\\slocalhost/127.0.0.1\\tlocalhost sarahbox/" armjessiechroot/etc/hosts

#networking
cp /vagrant/eth0 armjessiechroot/etc/network/interfaces.d/
sed -i s/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/ armjessiechroot/etc/sysctl.conf

#limit installed packages by disabling recommends
echo "APT::Install-Recommends \"0\";" > armjessiechroot/etc/apt/apt.conf.d/99disable-recommends

#security updates
echo "deb http://security.debian.org/ jessie/updates main" > armjessiechroot/etc/apt/sources.list.d/security.list
#backports (for nftables) pinned to require explicit installation
echo "deb http://httpredir.debian.org/debian jessie-backports main" > armjessiechroot/etc/apt/sources.list.d/backports.list
echo "package: *
Pin: release a=jessie-backports
Pin-Priority: 200" > armjessiechroot/etc/apt/preferences.d/backportspin.pref
#the osd repo (kernel and coap things)
echo "deb http://sarahbox.osdomotics.com/debian jessie free" > armjessiechroot/etc/apt/sources.list.d/osd.list
cp /vagrant/osd.repository.key armjessiechroot
chroot armjessiechroot apt-key add osd.repository.key
rm armjessiechroot/osd.repository.key

#kernel handling (uboot needs fat, but dpkg doesn't like /boot as fat)
mkdir -p armjessiechroot/uboot
mkdir -p armjessiechroot/etc/kernel/postinst.d/
cp /vagrant/boot-copy armjessiechroot/etc/kernel/postinst.d/

#prevent services from starting
echo "#!/bin/sh
exit 101" > armjessiechroot/usr/sbin/policy-rc.d
chmod 755 armjessiechroot/usr/sbin/policy-rc.d
mv armjessiechroot/sbin/start-stop-daemon armjessiechroot/sbin/start-stop-daemon.REAL
echo "#!/bin/sh
echo \"Warning: Fake start-stop-daemon called, doing nothing\"" > armjessiechroot/sbin/start-stop-daemon
chmod 755 armjessiechroot/sbin/start-stop-daemon

#install the packages
chroot armjessiechroot apt-get update
chroot armjessiechroot apt-get install -yt jessie-backports nftables
chroot armjessiechroot apt-get install -y openssh-server vim usbutils ntp linux-image python3-aiocoap-utils
chroot armjessiechroot apt-get upgrade -y

#allow services again
rm -f armjessiechroot/usr/sbin/policy-rc.d
mv armjessiechroot/sbin/start-stop-daemon.REAL armjessiechroot/sbin/start-stop-daemon

#setup the users
chroot armjessiechroot passwd << EOF
root
root
EOF

if ! grep -Fq osd armjessiechroot/etc/passwd; then
chroot armjessiechroot adduser osd << EOF
osd
osd





y
EOF
fi

#tunslip for our 6lowpan mesh
wget -c https://github.com/contiki-os/contiki/raw/2.7/tools/tunslip6.c
arm-linux-gnueabihf-gcc-4.9 tunslip6.c -o tunslip6
mv tunslip6 armjessiechroot/usr/local/bin
cp /vagrant/tunslip6.service armjessiechroot/lib/systemd/system/
chroot armjessiechroot systemctl enable tunslip6.service

#clean up rootfs a bit
rm -f armjessiechroot/var/cache/apt/archives/*.deb
rm -f armjessiechroot/var/cache/apt/archives/partial/*
rm -f armjessiechroot/usr/bin/qemu-arm-static
