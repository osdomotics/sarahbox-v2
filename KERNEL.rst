======
kernel
======

The kernel base config is sunxi_defconfig with everything not required for the pure kernel boot built as a module


additional options
==================

Following are the modifications that have been made to the base config

General Setup
-------------

/proc/config.gz support (IKCONFIG_PROC)
Control Group Support (CGROUPS, CGROUP_*)
Namespaces support (NAMESPACES, CONFIG_*_NS)


Filesystem
----------

autofs (AUTOFS_FS) for systemd
Ext4 POSIX ACLs (EXT4_FS_POSIX_ACL) for journalctl / udevd
Ext4 Security Labels (CONFIG_EXT4_FS_SECURITY) for capabilitites on binaries like ping

Networking
----------

IPv6 (CONFIG_IPV6) required for 6LoWPAN
nftables (CONFIG_NETFILTER* and CONFIG_NF*)
6LoWPAN (CONFIG_6LOWPAN*, CONFIG_IEEE802154* and CONFIG_MAC802154)

Device Drivers
--------------

AXP209 power management (PINCTRL_AXP209,AXP20X_ADC,CHARGER_AXP20X,BATTERY_AXP20X)
ATUSB (IEEE802154_ATUSB)
WireGuard (WIREGUARD)


removed options
===============

Boot Support
------------

NFS Booting and requirements (IP_PNP, NETWORK_FILESYSTEMS)
initial ramdisk/ramfs (BLK_DEV_RAM)

Device Drivers
--------------

Various network devices (NET_VENDOR_*) but keeping NET_VENDOR_ALLWINNER and NET_VENDOR_STMICRO
