#!/bin/sh
set -e

sudo -E /vagrant/vagrant/build_rootfs.sh $@
/vagrant/vagrant/build_kernel.sh $@
