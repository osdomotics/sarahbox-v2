#!/bin/sh

sudo /vagrant/vagrant/build_rootfs.sh $@
/vagrant/vagrant/build_kernel.sh $@
/vagrant/vagrant/build_uboot.sh $@
sudo /vagrant/vagrant/build_image.sh $@
