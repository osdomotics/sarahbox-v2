sarahbox-v2
===========

Systemimage builder for 6LoWPAN Boarder Router

Vagrant setup to build debian stable sd images with lightweight mainline
kernel

Requirements
------------

- amd64 OS (Debian, ArchLinux tested)
- vagrant (>=1.6.5)
- Virtualbox
- at least 5GB free space

Quickstart (vagrant)
--------------------

- Clone repository
- ``vagrant up``
- ``vagrant ssh -c "build <board-dirname>"`` e.g. ``olimex-A20-lime``

This will create the file ``sarahbox_<board-dirname>.img`` inside the project directory.
Use ``build_board_independent`` and ``build_board_dependent`` to build board
(in)dependent parts.
Use ``build_rootfs`` as root, ``build_kernel``, ``build_uboot`` and/or ``build_image`` as root to run the steps separately.
Don't forget to provide the board name.

The generated 1GB image can be written on a sdcard using dd.

The system will try to fetch an IP using dhcp.

Access the system using a serial connection or ssh as user ``osd`` with password ``osd``,
default ``root`` password is ``root``, **change both passwords asap**.

Quickstart (docker)
-------------------

WARNING: it is necessary to run docker in priviledged mode, use on your own risk
Howto for podman planned

- Clone repository
- Download https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh
- ``chmod +x qemu-binfmt-conf.sh``
- ``./qemu-binfmt-conf.sh --systemd arm``
- ``systemctl start systemd-binfmt``
- ``docker run --privileged --rm -it -v $(pwd):/code``
- ``cd /code``
- ``./scripts/build.sh <board-dirname>``

Restrictions
------------

-  hardware may not be fully supported by mainline kernel (e.g. GPU)
-  kernel config only supports minimal features needed for border
   routers, adapt kernel-config-x.y.z if necessary

Supported Hardware
------------------

- Olimex A10-Lime
- Olimex A20-Lime
- Olimex A20-Lime2
- Olimex A20-Micro (untested)
- Cubietech Cubieboard2 (untested)
- Lemaker Banana Pro
- Xunlong OrangePi One (untested)
- FriendlyARM NanoPi Neo (no eth)
- Xunlong OrangePi Zero (no eth)

Planned
~~~~~~~

- create an issue or pull-request for more hardware support
