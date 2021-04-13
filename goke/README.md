## chroot into u-root

### Mount Basic Filesystems

```sh
mount /dev
mount /sys
mount /tmp
mount /proc
mdev -s
```

### Activate Wi-Fi

The original firmware has a script to set up an access point. This is enough for
the PoC. For the eventual image, we will later connect to another AP we provide.

```sh
mount -t jffs2 -o ro /dev/mtdblock4 /bak
insmod /bak/drv/9083h.ko.lzma
mkdir /tmp/var
PATH="/bak/ap:$PATH" /bak/ap/start-ap.sh gokewifi
```

### Mount SD Card and u-root rootfs

```sh
mkdir /tmp/r
mkdir /tmp/m
mount -t vfat /dev/mmcblk0p1 /tmp/m
mount -t squashfs /tmp/m/u-root.sfs /tmp/r
```

### Bind Mount and chroot

```sh
mount -o bind /dev /tmp/r/dev
mount -o bind /sys /tmp/r/sys
mount -o bind /proc /tmp/r/proc
/tmp/r/bbin/chroot /tmp/r/ /init
```

### Launch `cpud` from u-root

```
cpud -d -init
```
