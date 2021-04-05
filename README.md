# Modifying Gadget Firmware

## Gaining Access

Connect to the UART, e.g., using dupont wires and a USB serial adapter, and run
Minicom or similar. Logging the session to a file can be *very* useful. ;-)
Basic Minicom usage: `minicom -D /dev/ttyUSB0`

Remember to unset flow control:
Press Ctrl + A, select "Serial port setup", press F, ESC, ESC, ESC.

To log to a file, press Ctrl + L and enter the desired name.

## U-Boot Shell

On bootup, press Ctrl + C or something to drop into the U-Boot shell. There may
be a hint printed in the console regarding special key combinations etc.

### Editing kernel commandline

Check the current settings:
```
printenv
```

Find the `bootargs` line. Copy and adjust it, adding `single` behind it, e.g.:

```
setenv bootargs root=/dev/mtdpart4 rootfstype=squashfs init=/init mem=64M memsize=64M single
```

Save and reset:
```
saveenv
reset
```

Now you will boot into Linux in single user mode, with no init interfering. :-)

## Backup and Extraction

### From U-Boot

**TODO**: TFTP put etc

### From Linux

The simplest way: Insert an SD card, possibly mount it manually, and copy over
the partitions. Your mount point etc may differ. This here assumes a FAT
partition and the kernel on your gadget to support the filesystem.

```sh
mkdir /tmp/sdcard
mount -t vfat /dev/mmcblk0p1 /tmp/sdcard
cp /dev/mtdblock* /tmp/sdcard/
```

More interesting information:

```sh
cat /proc/cpuinfo > /tmp/sdcard/cpuinfo.log
dmesg > /tmp/sdcard/dmesg.log
mount > /tmp/sdcard/mount.log
```

### rootfs, extras, etc

You will need the following tools:

- for JFFS2: [`jefferson`](https://github.com/sviehb/jefferson)
- for squashfs: `unsquashfs` (usually `squashfs-tools` in OS distro)

From your `dmesg` backup, check the mtd partitions. For example:

```
Creating 6 MTD partitions on "spi0.0":
0x000000039000-0x000000239000 : "KERNEL"
0x000000239000-0x00000023a000 : "MAC"
0x00000023a000-0x00000023b000 : "ENV"
0x00000023b000-0x0000003bb000 : "A"
0x0000003bb000-0x000000438000 : "B"
0x000000438000-0x0000007ee000 : "C"
```

This may not be too meaningful. Also check your `mount` and `dmesg` logs to see
what each partition is. A common setup is to have a rootfs, a separate `/usr`
partition, both being squashfs, plus a (writable) JFFS2 partition for settings.
This is where you can check how the system was originally set up, what kernel
modules (drivers) were loaded, what was mounted, etc. See `etc/init.d` in the
root filesystem. In this example, it is `mtdblock4`, and `mtdblock6` is `/usr`.
The config data is in `mtdblock5`.

```sh
unsquashfs -d rootfs mtdblock4
unsquashfs -d usr mtdblock6
jefferson -d etc mtdblock5
```

Now you can copy over all the pieces to stitch together a new initramfs.
