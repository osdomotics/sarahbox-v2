#!/bin/sh
set -e
VBID=`cat .vagrant/machines/default/virtualbox/id`
DISK=`VBoxManage showvminfo "$VBID" --machinereadable | grep vmdk | cut -d \" -f 4`

echo disk image is "$DISK"

echo mounting image via qmeu-nbd
sudo modprobe nbd
sudo qemu-nbd -c /dev/nbd0 "$DISK"
sudo kpartx -avs /dev/nbd0

echo optimizing image
sudo zerofree -v /dev/mapper/nbd0p1

echo unmounting image
sudo kpartx -dvs /dev/nbd0
sudo qemu-nbd -d /dev/nbd0
