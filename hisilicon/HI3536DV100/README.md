## Original Firmware

### Bootargs (kernel cmdline)

`mem=155M console=ttyAMA0,115200 root=/dev/mtdblock1 rootfstype=squashfs mtdparts=hi_sfc:320K(boot),3968K(romfs),7040K(usr),1600K(web),2816K(custom),128K(logo),512K(mtd) coherent_pool=2M`

### Backup

Back up the SPI flash contents, e.g. using the U-Boot shell and `tftp` commands.
You can use [`atftpd`](https://linux.die.net/man/8/atftpd) as a server to upload files;
[`centre`](https://github.com/Harvey-OS/go/tree/main/cmd/centre) does not offer that (yet!).
Note: ATFTP is [easy to use on Arch Linux](https://wiki.archlinux.org/index.php/TFTP#atftp).

The goal now is to extract the kernel modules from the SPI flash backup and put them here
in a `modules/` directory. These modules are proprietary and no sources available as of now.

### Extract

You can just follow the `mtdparts` argument and split up the backup image.
See `split-fw.sh` here. You can just run it to get the partitions as `*.bin` files.

Extract `usr.bin`, which came from `mtdblock2` in the original system:
```sh
unsquashfs -d usr usr.bin
```

You should now find a file `usr/lib/modules.tar.lzma`. So extract that again:
```sh
tar -xf usr/lib/modules.tar.lzma
```

## Build your own

### u-root cpio

With [u-root](https://u-root.org/), we build the initramfs as a cpio, which will hold basic CLI tools,
kernel modules, a module load script, and `cpud`.

- install a Go toolchain and `go get github.com/u-root/u-root`
- add it to your `$PATH`, e.g., in `bash`: `export PATH="$HOME/go/bin:$PATH`
- generate an SSH key pair with `ssh-keygen` for `cpu`; the public key needs to be part of the cpio
- put the public key here as `cpu_rsa.pub` as per the build script or adapt as you like

Now run the build script included here: `./build-arm-cpio.sh`

### kernel uImage

- get a Linux `4.9.37` tarball: https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.9.37.tar.xz
- extract it and apply the HiSilicon patch
- copy over the u-root cpio frem the previous step
- build the kernel using `config-HI3536DV100-9p` and an Arm toolchain, e.g. Linaro's

Again, you can use an included script: `./build-uimage.sh`

This will get you `arch/arm/boot/uImage`, which you can now put in your tftp root directory.

## Run it

Now it's time to fetch the `uImage` and run it over U-Boot / tftp :)

```
tftp 0x82000000 uImage
bootm 0x82000000
```
