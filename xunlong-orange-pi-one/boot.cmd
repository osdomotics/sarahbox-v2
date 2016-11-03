ext4load mmc 0:1 0x46000000 /boot/zImage
ext4load mmc 0 0x49000000 /boot/dtb/sun8i-h3-orangepi-pc.dtb
setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p1 rootwait panic=10 ${extra}
bootz 0x46000000 - 0x49000000
