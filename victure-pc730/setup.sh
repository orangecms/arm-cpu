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
sleep 5
hostapd /etc/jffs2/hostapd.conf -B
ifconfig wlan1 10.1.8.1
udhcpd /etc/udhcpd.conf
# ifconfig wlan0 up
# ifconfig wlan0 192.168.111.222

# u-root
# cd /tmp/ramdisk && tar -xf /mnt/root-arm-cpud.tar
# ./root-arm-cpud/bbin/cpud -d -init
mkdir /tmp/rootfs
#mount -t squashfs /mnt/root-arm-cpud.sfs /tmp/rootfs
mount -t squashfs /mnt/u-root-victure.sfs /tmp/rootfs
cp /mnt/cpu_rsa.pub /tmp/key.pub
mount -o bind  /dev /tmp/rootfs/dev
mount -o bind /proc /tmp/rootfs/proc
mount -o bind  /sys /tmp/rootfs/sys
#cd /tmp/ && ./rootfs/bbin/cpud -d -init -remote
chroot /tmp/rootfs/ /init
# cpud -d -init -remote
