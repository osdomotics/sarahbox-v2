#!/bin/sh
set -e

sudo -E /vagrant/vagrant/build_rootfs.sh $@
/vagrant/vagrant/build_uboot.sh $@
sudo /vagrant/vagrant/build_image.sh $@
