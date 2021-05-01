#!/bin/sh

wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.9.37.tar.xz
tar -xf linux-4.9.37.tar.xz
cd linux-4.9.37
patch -p1 < hi3536dv100_for_linux-4.9.y.patch
patch -p1 < 11_fix_yylloc_for_modern_computers.patch
cp /tmp/u-root-arm.cpio .
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage -j9
