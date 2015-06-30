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
- ``vagrant ssh -c "build <board-dirname>"`` e.g. ``olimex-A20-lime``

This will create the file ``rootfs.raw`` inside the board directory.
Use ``build_rootfs``, ``build_kernel``, ``build_uboot`` and/or ``build_image`` to run the steps separately.
Don't forget to provide the board name.

The system will try to fetch an IP using dhcp.

Access the system using a serial connection or ssh as user ``osd`` with password ``osd``,
default ``root`` password is ``root``, **change both passwords asap**.

Restrictions
------------

-  hardware may not be fully supported by mainline kernel (e.g. GPU)
-  kernel config only supports minimal features needed for border
   routers, adapt kernel-config-x.x if necessary

Tweaks
------

- add ``export DEBMIRROR="<fast-mirror>"`` to ~vagrant/.bashrc inside the vm

Supported Hardware
------------------

-  Olimex A10-Lime
-  Olimex A20-Lime
-  Olimex A20-Lime2 (untested)

Planned
~~~~~~~

- Cubietech Cubieboard
- Cubietech Cubieboard2
- create an issue or pull-request for more hardware support
