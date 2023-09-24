#!/bin/bash
set -e

boards=( "olimex-A20-lime" )

/vagrant/vagrant/build_board_independent.sh

for i in "${boards[@]}"
do
   /vagrant/vagrant/build_board_dependent.sh $i
done
