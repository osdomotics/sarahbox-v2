FROM debian:9

RUN dpkg --add-architecture armhf
RUN apt-get update

# build tools
RUN apt-get install -y vim curl binfmt-support debootstrap qemu-user-static crossbuild-essential-armhf kpartx u-boot-tools dosfstools device-tree-compiler ncurses-dev zerofree bc swig bison flex libpython-dev apt-transport-https

#cleanup
RUN rm -rf /var/cache/apt/*pkgcache.bin /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN find /var/log -type f -delete

