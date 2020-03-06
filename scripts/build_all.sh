#!/bin/bash
set -e

boards=( "olimex-A10-lime" "olimex-A20-lime" "olimex-A20-lime2" "olimex-A20-micro" "lemaker-banana-pro" "cubieboard2" "xunlong-orange-pi-one" "xunlong-orange-pi-zero"  "friendlyarm-nanopi-neo" )

./scripts/build_board_independent.sh

for i in "${boards[@]}"
do
   ./scripts/build_board_dependent.sh $i
done
