#!/bin/sh

#add embedian cross toolchain repo
curl --silent http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
#add following line to sources
echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/emdebian.list
dpkg --add-architecture armhf
apt-get update
# base tools :)
apt-get install -y vim
# build tools
apt-get install -y binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools

sudo -u vagrant mkdir -p ~vagrant/bin
sudo -u vagrant ln -fs /vagrant/vagrant/build.sh ~vagrant/bin/build
sudo -u vagrant ln -fs /vagrant/vagrant/build_kernel.sh ~vagrant/bin/build_kernel
sudo -u vagrant ln -fs /vagrant/vagrant/build_rootfs.sh ~vagrant/bin/build_rootfs
sudo -u vagrant ln -fs /vagrant/vagrant/build_uboot.sh ~vagrant/bin/build_uboot
sudo -u vagrant ln -fs /vagrant/vagrant/build_image.sh ~vagrant/bin/build_image
sudo -u vagrant ln -fs /vagrant/vagrant/build_board_dependent.sh ~vagrant/bin/build_board_dependent
sudo -u vagrant ln -fs /vagrant/vagrant/build_board_independent.sh ~vagrant/bin/build_board_independent
