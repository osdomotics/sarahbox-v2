======
kernel
======

The kernel base config is sunxi_defconfig with everything not required for the pure kernel boot built as a module


additional options
==================

Following are the modifications that have been made to the base config


Filesystem
----------

autofs (AUTOFS_FS) for systemd
Ext4 POSIX ACLs (EXT4_FS_POSIX_ACL) for journalctl / udevd
Ext4 Security Labels (CONFIG_EXT4_FS_SECURITY) for capabilitites on binaries like ping

Networking
----------

IPv6 (CONFIG_IPV6) required for 6LoWPAN
nftables (CONFIG_NETFILTER* and CONFIG_NF*)
6LoWPAN (CONFIG_6LOWPAN*, CONFIG_IEEE802154* and CONFIG_MAC802154

Device Drivers
--------------

AXP209 power magnagement (PINCTRL_AXP209)
ATUSB (IEEE802154_ATUSB)


removed options
===============

Boot Support
------------

NFS Booting and requirements (Kernel DHCP and similar)
