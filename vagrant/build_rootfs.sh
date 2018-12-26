#!/bin/sh
set -e

#debootstrap stage1
if [ ! -e armstretchchroot/var/log/bootstrap.log ]; then
    #get base
    debootstrap --include=apt-transport-https,ca-certificates,cloud-guest-utils  --arch=armhf --foreign stretch armstretchchroot 
fi

#qemu for chroot and some env settings to make apt run by itself
cp /usr/bin/qemu-arm-static armstretchchroot/usr/bin
export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C
export LANGUAGE=C
export LANG=C

#debootstrap stage2
if [ ! -e armstretchchroot/var/log/bootstrap.log ]; then
    chroot armstretchchroot /debootstrap/debootstrap --second-stage
    chroot armstretchchroot dpkg --configure -a
fi

#fstab
echo "/dev/mmcblk0p1 / ext4 errors=remount-ro 0 1" > armstretchchroot/etc/fstab

#hostname
echo sarahbox > armstretchchroot/etc/hostname
sed -ie "s/127.0.0.1\\slocalhost/127.0.0.1\\tlocalhost sarahbox/" armstretchchroot/etc/hosts

#networking
cp /vagrant/eth0 armstretchchroot/etc/network/interfaces.d/
sed -i s/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/ armstretchchroot/etc/sysctl.conf

#limit installed packages by disabling recommends
echo "APT::Install-Recommends \"0\";" > armstretchchroot/etc/apt/apt.conf.d/99disable-recommends

#base repo (debootstrap sets it to http://debootstrap.invalid/)
echo "deb http://deb.debian.org/debian/ stretch main" > armstretchchroot/etc/apt/sources.list

#other repos
mkdir -p armstretchchroot/etc/apt/sources.list.d/

#security updates
echo "deb http://security.debian.org/ stretch/updates main" > armstretchchroot/etc/apt/sources.list.d/security.list

#the osd repo (kernel and coap things)
echo "deb https://sarahbox.osdomotics.com/debian stretch free" > armstretchchroot/etc/apt/sources.list.d/osd.list
cp /vagrant/osd.repository.key armstretchchroot/etc/apt/trusted.gpg.d/osd.gpg

#kernel install should link zimage and dts according to the universal uboot script
mkdir -p armstretchchroot/etc/kernel/postinst.d/
cp /vagrant/boot-link armstretchchroot/etc/kernel/postinst.d/

#prevent services from starting
echo "#!/bin/sh
exit 101" > armstretchchroot/usr/sbin/policy-rc.d
chmod 755 armstretchchroot/usr/sbin/policy-rc.d
mv armstretchchroot/sbin/start-stop-daemon armstretchchroot/sbin/start-stop-daemon.REAL
echo "#!/bin/sh
echo \"Warning: Fake start-stop-daemon called, doing nothing\"" > armstretchchroot/sbin/start-stop-daemon
chmod 755 armstretchchroot/sbin/start-stop-daemon

#install the packages
chroot armstretchchroot apt-get update
KERNELPACKAGE=$(grep "Package: linux-image" armstretchchroot/var/lib/apt/lists/sarahbox.osdomotics.com_debian_dists_stretch_free_binary-armhf_Packages | cut -d " " -f 2 | sort -r | head -n 1)
chroot armstretchchroot apt-get install -y openssh-server vim usbutils ntp $KERNELPACKAGE python3-aiocoap-utils nftables tunslip6 net-tools
chroot armstretchchroot apt-get upgrade -y

#allow services again
rm -f armstretchchroot/usr/sbin/policy-rc.d
mv armstretchchroot/sbin/start-stop-daemon.REAL armstretchchroot/sbin/start-stop-daemon

#setup the users
chroot armstretchchroot passwd << EOF
root
root
EOF

if ! grep -Fq osd armstretchchroot/etc/passwd; then
chroot armstretchchroot adduser osd << EOF
osd
osd





y
EOF
fi

#we have no locales, make apt and friends a bit more friendly and UTF-8 for tmux and friends
echo "export LC_ALL=C.UTF-8" >> armstretchchroot/etc/profile

#clean up rootfs a bit
rm -f armstretchchroot/var/cache/apt/archives/*.deb
rm -f armstretchchroot/var/cache/apt/archives/partial/*
