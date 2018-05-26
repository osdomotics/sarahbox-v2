#!/bin/sh

sudo -u vagrant mkdir -p ~vagrant/bin
sudo -u vagrant ln -fs /vagrant/vagrant/prepare_new_kernel.sh ~vagrant/bin/prepare_new_kernel
sudo -u vagrant ln -fs /vagrant/vagrant/build.sh ~vagrant/bin/build
sudo -u vagrant ln -fs /vagrant/vagrant/build_all.sh ~vagrant/bin/build_all
sudo -u vagrant ln -fs /vagrant/vagrant/build_kernel.sh ~vagrant/bin/build_kernel
sudo -u vagrant ln -fs /vagrant/vagrant/build_rootfs.sh ~vagrant/bin/build_rootfs
sudo -u vagrant ln -fs /vagrant/vagrant/build_uboot.sh ~vagrant/bin/build_uboot
sudo -u vagrant ln -fs /vagrant/vagrant/build_image.sh ~vagrant/bin/build_image
sudo -u vagrant ln -fs /vagrant/vagrant/build_board_dependent.sh ~vagrant/bin/build_board_dependent
sudo -u vagrant ln -fs /vagrant/vagrant/build_board_independent.sh ~vagrant/bin/build_board_independent
