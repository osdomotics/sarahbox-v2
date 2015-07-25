#!/bin/sh

/vagrant/vagrant/build_uboot.sh $@
sudo /vagrant/vagrant/build_image.sh $@
