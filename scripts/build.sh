#!/bin/sh
set -e

./scripts/build_rootfs.sh $@
./scripts/build_uboot.sh $@
./scripts/build_image.sh $@
