#!/bin/bash
set -e

boards=( "olimex-A10-lime" "olimex-A20-lime" "olimex-A20-lime2" "olimex-A20-micro" "lemaker-banana-pro" "cubieboard2" )

/vagrant/vagrant/build_board_independent.sh

for i in "${boards[@]}"
do
   /vagrant/vagrant/build_board_dependent.sh $i
done
