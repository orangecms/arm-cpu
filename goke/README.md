## chroot into u-root

### Mount Basic Filesystems

```sh
mount /dev
mount /sys
mount /tmp
mount /proc
mdev -s
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
