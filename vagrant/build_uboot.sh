#!/bin/sh
set -e
. /vagrant/vagrant/settings.sh

echo downloading u-boot...
curl -LOC - "https://ftp.denx.de/pub/u-boot/u-boot-$UBOOTVER.tar.bz2"

echo unpacking u-boot...
rm -rf "u-boot-$UBOOTVER"
tar -xf u-boot-$UBOOTVER.tar.bz2

echo patching u-boot...
cd "u-boot-$UBOOTVER"
QUILT_PATCHES=/vagrant/u-boot-patches quilt --quiltrc - push -a

echo configuring u-boot...
BOARDCONFIG=$(cat /vagrant/$1/uboot.conf)
make CROSS_COMPILE=arm-linux-gnueabihf- $BOARDCONFIG
# minimize boot delay
sed -i "s/CONFIG_BOOTDELAY=[0-9][0-9]*/CONFIG_BOOTDELAY=0/" .config
# disable usb host drivers to prevent probes
sed -i "s/CONFIG_USB_HOST=y/# CONFIG_USB_HOST is not set/" .config
sed -i "s/CONFIG_USB_EHCI_HCD=y/# CONFIG_USB_EHCI_HCD is not set/" .config
sed -i "s/CONFIG_USB_EHCI_GENERIC=y/# CONFIG_USB_EHCI_GENERIC is not set/" .config
sed -i "s/CONFIG_USB_OHCI_HCD=y/# CONFIG_USB_OHCI_HCD is not set/" .config
sed -i "s/CONFIG_USB_OHCI_GENERIC=y/# CONFIG_USB_OHCI_GENERIC is not set/" .config

echo building u-boot...
make CROSS_COMPILE=arm-linux-gnueabihf-
