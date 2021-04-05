#!/bin/sh

## mounts
mount /proc
mount /tmp
mount /var
mount /sys
mkdir /dev/pts
mount /dev/pts
#mount -t vfat /dev/mmcblk0p1 /mnt
mount /dev/mtdblock6 /usr
mount -t jffs2 /dev/mtdblock5 /etc/jffs2
# mount -t tmpfs -o size=32m tmpfs /tmp/ramdisk

## modules
insmod /usr/modules/sdio_wifi.ko
insmod /usr/modules/8188fu.ko
insmod /usr/modules/otg-hs.ko

# Wi-Fi
mkdir -p /var/run
hostapd /etc/jffs2/hostapd.conf -B
ifconfig wlan1 10.1.8.1
udhcpd /etc/udhcpd.conf
# ifconfig wlan0 up
# ifconfig wlan0 192.168.111.222

# u-root
# cd /tmp/ramdisk && tar -xf /mnt/root-arm-cpud.tar
# ./root-arm-cpud/bbin/cpud -init
mkdir /tmp/rootfs
mount -t squashfs /mnt/root-arm-cpud.sfs /mnt/rootfs
cp /mnt/cpu_rsa.pub /tmp/key.pub
cd /tmp/
./rootfs/bbin/cpud -init -d
