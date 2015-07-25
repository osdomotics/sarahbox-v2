#!/bin/sh

sudo -E /vagrant/vagrant/build_rootfs.sh $@
/vagrant/vagrant/build_kernel.sh $@
