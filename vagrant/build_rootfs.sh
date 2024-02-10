#!/bin/sh
set -e
. /vagrant/vagrant/settings.sh

CHROOT_DIR="arm${DEBIANVER}chroot"

#debootstrap stage1
if [ ! -e "${CHROOT_DIR}/var/log/bootstrap.log" ]; then
    #get base
    debootstrap --include=ca-certificates,cloud-guest-utils --arch=armhf --foreign "$DEBIANVER" "$CHROOT_DIR"
fi

#qemu for chroot and some env settings to make apt run by itself
cp /usr/bin/qemu-arm-static "${CHROOT_DIR}/usr/bin"
export APT_LISTCHANGES_FRONTEND=none
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C
export LANGUAGE=C
export LANG=C

#debootstrap stage2
if [ ! -e "${CHROOT_DIR}/var/log/bootstrap.log" ]; then
    chroot "$CHROOT_DIR" /debootstrap/debootstrap --second-stage
    chroot "$CHROOT_DIR" dpkg --configure -a
fi

#fstab
echo "/dev/mmcblk0p1 / ext4 errors=remount-ro 0 1" > "${CHROOT_DIR}/etc/fstab"

#hostname
echo sarahbox > "${CHROOT_DIR}/etc/hostname"
sed -ie "s/127.0.0.1\\slocalhost/127.0.0.1\\tlocalhost sarahbox/" "${CHROOT_DIR}/etc/hosts"

#networking
cp /vagrant/end0 "${CHROOT_DIR}/etc/network/interfaces.d/"
sed -i s/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/ "${CHROOT_DIR}/etc/sysctl.conf"

#limit installed packages by disabling recommends
echo "APT::Install-Recommends \"0\";" > "${CHROOT_DIR}/etc/apt/apt.conf.d/99disable-recommends"

#base repo (debootstrap sets it to http://debootstrap.invalid/)
echo "deb https://deb.debian.org/debian $DEBIANVER main" > "${CHROOT_DIR}/etc/apt/sources.list"

#other repos
mkdir -p "${CHROOT_DIR}/etc/apt/sources.list.d/"

#security updates
echo "deb https://deb.debian.org/debian-security ${DEBIANVER}-security main" > "${CHROOT_DIR}/etc/apt/sources.list.d/security.list"

#the osd repo (kernel and coap things)
cp /vagrant/osd.repository.key "${CHROOT_DIR}/usr/share/keyrings/osd.gpg"
echo "Types: deb
URIs: https://sarahbox.osdomotics.com/debian
Suites: $DEBIANVER
Components: free
Signed-By: /usr/share/keyrings/osd.gpg" > "${CHROOT_DIR}/etc/apt/sources.list.d/osd.sources"

#kernel install should link zimage and dts according to the universal uboot script
mkdir -p "${CHROOT_DIR}/etc/kernel/postinst.d/"
cp /vagrant/boot-link "${CHROOT_DIR}/etc/kernel/postinst.d/"

#prevent services from starting
echo "#!/bin/sh
exit 101" > "${CHROOT_DIR}/usr/sbin/policy-rc.d"
chmod 755 "${CHROOT_DIR}/usr/sbin/policy-rc.d"
mv "${CHROOT_DIR}/sbin/start-stop-daemon" "${CHROOT_DIR}/sbin/start-stop-daemon.REAL"
echo "#!/bin/sh
echo \"Warning: Fake start-stop-daemon called, doing nothing\"" > "${CHROOT_DIR}/sbin/start-stop-daemon"
chmod 755 "${CHROOT_DIR}/sbin/start-stop-daemon"

#install the packages
chroot "$CHROOT_DIR" apt-get update
KERNELPACKAGE=$(grep "Package: linux-image" "${CHROOT_DIR}/var/lib/apt/lists/sarahbox.osdomotics.com_debian_dists_${DEBIANVER}_free_binary-armhf_Packages" | cut -d " " -f 2 | sort -r | head -n 1)
chroot "$CHROOT_DIR" apt-get install -y openssh-server vim usbutils ntp nftables wpan-tools $KERNELPACKAGE
chroot "$CHROOT_DIR" apt-get upgrade -y

#allow services again
rm -f "${CHROOT_DIR}/usr/sbin/policy-rc.d"
mv "${CHROOT_DIR}/sbin/start-stop-daemon.REAL" "${CHROOT_DIR}/sbin/start-stop-daemon"

#setup the users
chroot "$CHROOT_DIR" passwd << EOF
root
root
EOF

if ! grep -Fq osd "${CHROOT_DIR}/etc/passwd"; then
chroot "$CHROOT_DIR" adduser osd << EOF
osd
osd





y
EOF
fi

#we have no locales, make apt and friends a bit more friendly and UTF-8 for tmux and friends
echo "export LC_ALL=C.UTF-8" > "${CHROOT_DIR}/etc/profile.d/utf8-LC.sh"

#clean up rootfs a bit
rm -f "${CHROOT_DIR}/var/cache/apt/archives/*.deb"
rm -f "${CHROOT_DIR}/var/cache/apt/archives/partial/*"
