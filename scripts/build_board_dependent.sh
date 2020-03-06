#!/bin/sh
set -e

./scripts/build_uboot.sh $@
./scripts/build_image.sh $@
