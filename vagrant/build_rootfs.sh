#!/bin/sh
set -e

#debootstrap stage1
if [ ! -e armbullseyechroot/var/log/bootstrap.log ]; then
    #get base
    debootstrap --include=ca-certificates,cloud-guest-utils  --arch=armhf --foreign bullseye armbullseyechroot
fi

#qemu for chroot and some env settings to make apt run by itself
cp /usr/bin/qemu-arm-static armbullseyechroot/usr/bin
export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C
export LANGUAGE=C
export LANG=C

#debootstrap stage2
if [ ! -e armbullseyechroot/var/log/bootstrap.log ]; then
    chroot armbullseyechroot /debootstrap/debootstrap --second-stage
    chroot armbullseyechroot dpkg --configure -a
fi

#fstab
echo "/dev/mmcblk0p1 / ext4 errors=remount-ro 0 1" > armbullseyechroot/etc/fstab

#hostname
echo sarahbox > armbullseyechroot/etc/hostname
sed -ie "s/127.0.0.1\\slocalhost/127.0.0.1\\tlocalhost sarahbox/" armbullseyechroot/etc/hosts

#networking
cp /vagrant/eth0 armbullseyechroot/etc/network/interfaces.d/
sed -i s/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/ armbullseyechroot/etc/sysctl.conf

#limit installed packages by disabling recommends
echo "APT::Install-Recommends \"0\";" > armbullseyechroot/etc/apt/apt.conf.d/99disable-recommends

#base repo (debootstrap sets it to http://debootstrap.invalid/)
echo "deb https://deb.debian.org/debian bullseye main" > armbullseyechroot/etc/apt/sources.list

#other repos
mkdir -p armbullseyechroot/etc/apt/sources.list.d/

#security updates
echo "deb https://deb.debian.org/debian-security bullseye-security main" > armbullseyechroot/etc/apt/sources.list.d/security.list

#the osd repo (kernel and coap things)
echo "Types: deb
URIs: https://sarahbox.osdomotics.com/debian
Suites: bullseye
Components: free
Signed-By: /usr/share/keyrings/osd.gpg" > armbullseyechroot/etc/apt/sources.list.d/osd.sources
cp /vagrant/osd.repository.key armbullseyechroot/usr/share/keyrings/osd.gpg

#kernel install should link zimage and dts according to the universal uboot script
mkdir -p armbullseyechroot/etc/kernel/postinst.d/
cp /vagrant/boot-link armbullseyechroot/etc/kernel/postinst.d/

#prevent services from starting
echo "#!/bin/sh
exit 101" > armbullseyechroot/usr/sbin/policy-rc.d
chmod 755 armbullseyechroot/usr/sbin/policy-rc.d
mv armbullseyechroot/sbin/start-stop-daemon armbullseyechroot/sbin/start-stop-daemon.REAL
echo "#!/bin/sh
echo \"Warning: Fake start-stop-daemon called, doing nothing\"" > armbullseyechroot/sbin/start-stop-daemon
chmod 755 armbullseyechroot/sbin/start-stop-daemon

#install the packages
chroot armbullseyechroot apt-get update
KERNELPACKAGE=$(grep "Package: linux-image" armbullseyechroot/var/lib/apt/lists/sarahbox.osdomotics.com_debian_dists_bullseye_free_binary-armhf_Packages | cut -d " " -f 2 | sort -r | head -n 1)
chroot armbullseyechroot apt-get install -y openssh-server vim usbutils ntp nftables wpan-tools $KERNELPACKAGE
chroot armbullseyechroot apt-get upgrade -y

#allow services again
rm -f armbullseyechroot/usr/sbin/policy-rc.d
mv armbullseyechroot/sbin/start-stop-daemon.REAL armbullseyechroot/sbin/start-stop-daemon

#setup the users
chroot armbullseyechroot passwd << EOF
root
root
EOF

if ! grep -Fq osd armbullseyechroot/etc/passwd; then
chroot armbullseyechroot adduser osd << EOF
osd
osd





y
EOF
fi

#we have no locales, make apt and friends a bit more friendly and UTF-8 for tmux and friends
echo "export LC_ALL=C.UTF-8" >> armbullseyechroot/etc/profile

#clean up rootfs a bit
rm -f armbullseyechroot/var/cache/apt/archives/*.deb
rm -f armbullseyechroot/var/cache/apt/archives/partial/*
