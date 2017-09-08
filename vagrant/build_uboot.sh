#!/bin/sh
set -e

. /vagrant/vagrant/settings.sh

wget -c ftp://ftp.denx.de/pub/u-boot/u-boot-$UBOOTVER.tar.bz2
tar -xf u-boot-$UBOOTVER.tar.bz2
cd u-boot-$UBOOTVER
BOARDCONFIG=$(cat /vagrant/$1/uboot.conf)
make CROSS_COMPILE=arm-linux-gnueabihf- $BOARDCONFIG
# minimize boot delay
sed -i "s/CONFIG_BOOTDELAY=[0-9][0-9]*/CONFIG_BOOTDELAY=0/" .config
# disable usb ehci drivers to prevent probes
sed -i "s/CONFIG_USB_HOST=y//" .config
sed -i "s/CONFIG_USB_EHCI_HCD=y/# CONFIG_USB_EHCI_HCD is not set/" .config
sed -i "s/CONFIG_USB_EHCI=y/# CONFIG_USB_EHCI is not set/" .config
make CROSS_COMPILE=arm-linux-gnueabihf-
