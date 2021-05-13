# arm-cpu

This repository deals with gadgets and dev boards based on [ARM and Linux](
https://www.kernel.org/doc/html/latest/arm/index.html). There are also gadgets
based on MIPS and probably soon RISC-V, to which the concepts can be extended.

## Introduction

Modifying gadget firmware is a simple means of obtaining a reasonably priced
board for developing on ARM based platforms, independent from more mainstream
products such as Raspberry Pi.
The [idea](https://github.com/orangecms/repurposing-gadgets) is simple: obtain a
device such as an IP camera, an NVR (network video recorder), a wireless storage
device, or possibly enhanced household gear, and turn it into something else.

However, this is a bit of a tedious process: copying images over network, via
USB sticks or SD cards, loading them again and again, setting up NFS, DHCP, TFTP
and other services as well as rebuilding takes time. To boost the process, we
leverage two convenient tools:

- [`centre`](https://github.com/Harvey-OS/go/tree/main/cmd/centre), a combined
  DHCP+TFTP+HTTP serving utility,
- [`cpu`](https://github.com/u-root/cpu/), a 9p based tool to run code on and
  access resources from other machines

These only require a very basic Linux system to run:

- a Linux kernel for the respective SoC with necessary drivers and support for
  networking and the 9p filesystem
- a root filesystem with `cpud` in it

The kernel can be a bit of a challenge. Not all SoC vendors upstream patches to
Linux, but distribute PDKs and/or SDKs (product/software development kits) to
their customers, which are typically OEMs. However, some do publish the sources
again, often with prebuilt modules only available as blobs, so we are stuck with
a specific kernel version unless we want to spend time on [figuring things out](
https://github.com/pfalcon/awesome-linux-android-hacking#can-kernel-modules-built-for-one-version-be-used-with-another-kernel-version).
That is out of the scope of this project and we focus on the userland bits. :-)

For more details on `cpu`, have a look at the [chapter of the LinuxBoot book](
https://github.com/linuxboot/book/tree/master/cpu) explaining it. In fact, this
project can be seen as an implementation of [LinuxBoot](https://linuxboot.org),
since it involves booting a system involving [Linux](https://kernel.org).
You can `chroot` into another rootfs or `kexec` another kernel / image.

## Gaining Access

Connect to the UART, e.g., using dupont wires and a USB serial adapter, and run
Minicom or similar. Logging the session to a file can be *very* useful. ;-)
Basic Minicom usage: `minicom -D /dev/ttyUSB0`

Remember to unset flow control:
Press Ctrl + A, then O, select "Serial port setup", press F, ESC, ESC.

To log to a file, press Ctrl + A, then L and enter the desired name.

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

### Booting From MMC (SD Card)

The `fatload` command loads a file from a FAT filesystem into memory.
You will need to know the memory address where to load the file, which is
specific to the SoC. Check for `loadaddr` and `bootargs` in `printenv`.

This example addresses the first MMC device (`mmc 0:`), picks the first
partition (`1`), and loads to memory address `81b08000` the file named `uImage`
(relative to `/`, the root on the partition):

```
fatload mmc 0:1 81b08000 uImage
```

Then temporarily switch to single user mode by adding `single` to `bootargs`:
```
setenv bootargs console=ttySAK0,115200n8 root=/dev/mmcblk0p2 rootfstype=squashfs init=/init mem=64M memsize=64M single
```

And boot from memory:
```
bootm
```

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

## Building and Running u-root

**TODO**

## Executing Over `cpu`

### On the target

This requires the daemon running: `cpud -d -init`

Below output is from after invoking `cpu` from the host you come from.

```
PWD=/tmp ./cpu -timeout9p 1000ms -bin 'cpud -d' victure hello
1970/01/01 00:18:29
CPUD:Args [cpud -d -remote -bin cpud -d -port9p 41889 hello] pid 457 *runasinit false *remote true
1970/01/01 00:18:29
CPUD:Running as remote
1970/01/01 00:18:29 -- mkdirall
1970/01/01 00:18:29 mkdir /home: read-only file system
1970/01/01 00:18:29 CPUD:namespace is "/lib:/lib64:/usr:/bin:/etc:/home"
1970/01/01 00:18:29 -- connect
1970/01/01 00:18:29 CPUD:Dial 127.0.0.1:41889
1970/01/01 00:18:29 CPUD:Connected: write nonce 9d6adc883876e3719941ba67e49eb49e
1970/01/01 00:18:29 CPUD:Wrote the nonce
1970/01/01 00:18:29 CPUD:fd is 11
1970/01/01 00:18:29 CPUD: mount 127.0.0.1 on /tmp/cpu 9p 0x6 version=9p2000.L,trans=fd,rfdno=11,wfdno=11,uname=dan,debug=0,msize=1048576
1970/01/01 00:18:29 9p mount ERROR :( no such device
1970/01/01 00:18:29 CPUD(as remote):9p mount ERROR no such device
2021/04/07 01:37:50 SSH error Process exited with status 1
```

### On the host you come from

`cpu -timeout9p 2000ms -bin 'cpud -d' goke hello`

Yields:

```
1970/01/01 00:22:16
CPUD:Args [cpud -d -remote -bin cpud -d -port9p 51723 hello] pid 238 *runasinit false *remote true
1970/01/01 00:22:16
CPUD:Running as remote
1970/01/01 00:22:16 -- mkdirall
1970/01/01 00:22:16 mkdir /home: read-only file system
1970/01/01 00:22:16 CPUD:namespace is "/tmp/cpu/"
1970/01/01 00:22:16 -- connect
1970/01/01 00:22:16 CPUD:Dial 127.0.0.1:51723
1970/01/01 00:22:16 CPUD:Connected: write nonce effe5b0d71f86aa75036331883f304ab
1970/01/01 00:22:16 CPUD:Wrote the nonce
1970/01/01 00:22:16 CPUD:fd is 11
1970/01/01 00:22:16 CPUD: mount 127.0.0.1 on /tmp/cpu 9p 0x6 version=9p2000.L,trans=fd,rfdno=11,wfdno=11,uname=dan,debug=0,msize=1048576
1970/01/01 00:22:16 CPUD: mount done
1970/01/01 00:22:16 CPUD: mount /tmp/cpu/tmp/cpu over /tmp/cpu/
1970/01/01 00:22:16 CPUD:Mounted /tmp/cpu/tmp/cpu on /tmp/cpu/
1970/01/01 00:22:16 CPUD: bind mounts done
1970/01/01 00:22:16 CPUD:dropPrives: uid is 0
1970/01/01 00:22:16 CPUD:dropPrivs: not dropping privs
1970/01/01 00:22:16 CPUD:runRemote: command is "hello"
hello
```
