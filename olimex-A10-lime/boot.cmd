fatload mmc 0 0x46000000 zImage
fatload mmc 0 0x49000000 sun4i-a10-olinuxino-lime.dtb
setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait panic=10 ${extra}
bootz 0x46000000 - 0x49000000
