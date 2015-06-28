sarahbox-v2
===========

Systemimage builder for 6LoWPAN Boarder Router

Vagrant setup to build debian stable sd images with lightweight mainline
kernel

Requirements
------------

- amd64 OS (Debian, ArchLinux tested)
- vagrant
- Virtualbox (vmware untested)
- at least 5GB free space

Quickstart
----------

- Clone repository
- ``vagrant up``
- ``vagrant ssh -c build``

This will create the file ``rootfs.raw`` inside the project directory. Use ``build_rootfs``, ``build_kernel``, ``build_uboot`` and/or ``build_image`` to run the steps separately.

The system will try to fetch an IP using dhcp.

Access the system using a serial connection or ssh as user ``osd`` with password ``osd``,
default ``root`` password is ``root``, **change both passwords asap**.

Restrictions
------------

-  hardware may not be fully supported by mainline kernel (e.g. GPU)
-  kernel config only supports minimal features needed for border
   routers, adapt kernel-config-x.x if necessary

Supported Hardware
------------------

-  Olimex A20-Lime

Planned
~~~~~~~

-  Olimex A10-Lime
-  Olimex A20-Lime2
