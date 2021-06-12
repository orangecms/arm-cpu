# OLinuXino-A64

This board is based on the Allwinner A64 SoC.

There is a variant that comes with a SPI flash.

## Flash Mode

As per https://linux-sunxi.org/BROM#A64, hold U-Boot(/FEL) while pressing reset.

## udev

https://bbs.archlinux.org/viewtopic.php?id=213767

`lsusb`

```
1f3a:efe8 Allwinner Technology sunxi SoC OTG connector in FEL/flashing mode
```

```sh
echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", GROUP="uucp", MODE="0660" SYMLINK+="usb-chip"
SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="1010", GROUP="uucp", MODE="0660" SYMLINK+="usb-chip-fastboot"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="1010", GROUP="uucp", MODE="0660" SYMLINK+="usb-chip-fastboot"
SUBSYSTEM=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="uucp", MODE="0660" SYMLINK+="usb-serial-adapter"
' | sudo tee /etc/udev/rules.d/99-allwinner.rules
```

## Flashing

**Note**: Install `sunxi-tools-git`; no tag exists for recent versions with SPI flash support

```sh
sunxi-fel spiflash-write 0 u-boot-sunxi-with-spl.bin
```

## DTS

Besides the DTS in U-Boot, there are also these:

https://github.com/torvalds/linux/raw/master/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts

https://github.com/OLIMEX/OLINUXINO/raw/master/SOFTWARE/A64/A64-ubuntu_built_preliminary_rel_2/a64-olinuxino.dts
https://wiki.amarulasolutions.com/bsp/sunxi/a64/a64-oli.html

## Arch

```sh
yay -S \
	aur/aarch64-elf-gcc-linaro-bin \
	swig \
	python-setuptools
```

## Firmware

https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/snapshot/trusted-firmware-a-2.5.tar.gz

```sh
make CROSS_COMPILE=aarch64-elf- PLAT=sun50i_a64 bl31
## build/sun50i_a64/release/bl31.bin successfully
```

## U-Boot

https://source.denx.de/u-boot/u-boot/-/archive/v2021.04/u-boot-v2021.04.tar.gz

```sh
export BL31=`$(pwd)/../bl31.bin`
make a64-olinuxino_defconfig
make CROSS_COMPILE=aarch64-elf-
```

```
  OBJCOPY u-boot-nodtb.bin
  RELOC   u-boot-nodtb.bin
  CAT     u-boot-dtb.bin
  COPY    u-boot.bin
  SYM     u-boot.sym
  CC      spl/common/spl/spl.o
  LD      spl/common/spl/built-in.o
  CC      spl/lib/display_options.o
  LD      spl/lib/built-in.o
  LD      spl/u-boot-spl
  OBJCOPY spl/u-boot-spl-nodtb.bin
  COPY    spl/u-boot-spl.bin
  SYM     spl/u-boot-spl.sym
  MKIMAGE spl/sunxi-spl.bin
  MKIMAGE u-boot.img
  MKIMAGE u-boot-dtb.img
  BINMAN  all
Image 'main-section' is missing external blobs and is non-functional: scp

/binman/u-boot-sunxi-with-spl/fit/images/scp/scp:
   SCP firmware is required for system suspend, but is otherwise optional.
   Please read the section on SCP firmware in board/sunxi/README.sunxi64

Some images are invalid
```

## Linux

TBD
