#!/bin/sh
set -e

. ./settings.sh

wget -c https://ftp.denx.de/pub/u-boot/u-boot-$UBOOTVER.tar.bz2
tar -xf u-boot-$UBOOTVER.tar.bz2
cd u-boot-$UBOOTVER
BOARDCONFIG=$(cat ./$1/uboot.conf)
make CROSS_COMPILE=arm-linux-gnueabihf- $BOARDCONFIG
# minimize boot delay
sed -i "s/CONFIG_BOOTDELAY=[0-9][0-9]*/CONFIG_BOOTDELAY=0/" .config
# disable usb ehci drivers to prevent probes
sed -i "s/CONFIG_USB_HOST=y/# CONFIG_USB_HOST is not set/" .config
sed -i "s/CONFIG_USB_EHCI_HCD=y/# CONFIG_USB_EHCI_HCD is not set/" .config
sed -i "s/CONFIG_USB_EHCI_GENERIC=y/# CONFIG_USB_EHCI_GENERIC is not set/" .config
sed -i "s/CONFIG_USB_OHCI_HCD=y/# CONFIG_USB_OHCI_HCD is not set/" .config
sed -i "s/CONFIG_USB_OHCI_GENERIC=y/# CONFIG_USB_OHCI_GENERIC is not set/" .config
make CROSS_COMPILE=arm-linux-gnueabihf-
