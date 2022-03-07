_KERNEL := linux-4.9.37

all: initramfs/initramfs.cpio xzcpio kernel

initramfs/initramfs.cpio:
	cd initramfs/u-root && \
	GOARCH=arm go run . -o ../initramfs.cpio \
		-files ../../cpu_rsa.pub:key.pub \
		github.com/u-root/u-root/cmds/core/elvish \
		github.com/u-root/u-root/cmds/core/init \
		github.com/u-root/u-root/cmds/core/cat \
		github.com/u-root/u-root/cmds/core/dhclient \
		github.com/u-root/u-root/cmds/core/ls \
		../cpu/cmds/cpu

.PHONY: clean xzcpio

clean:
	rm -f initramfs/initramfs.cpio

xzcpio: initramfs/initramfs.cpio
	xz --check=crc32 -9 --lzma2=dict=1MiB --stdout initramfs/initramfs.cpio | \
		dd conv=sync bs=512 of=$(_KERNEL)/u-root-arm.cpio.xz

fetchuroot:
	mkdir -p initramfs
ifeq (,$(wildcard ./initramfs/u-root))
	cd initramfs && \
		git clone https://github.com/u-root/u-root
endif
ifeq (,$(wildcard ./initramfs/cpu))
	cd initramfs && \
		git clone https://github.com/u-root/cpu
endif

fetchkernel:
ifeq (,$(wildcard ./$(_KERNEL).tar.xz))
	wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/$(_KERNEL).tar.xz
endif

.PHONY: fetch fetchkernel fetchuroot

fetch: fetchuroot fetchkernel

$(_KERNEL): fetchkernel
ifeq (,$(wildcard ./$(_KERNEL)))
	tar -xf $(_KERNEL).tar.xz
	cp config-HI3516EV200-9p $(_KERNEL)/.config
	cd $(_KERNEL) && \
		patch -p1 < ../00_hi3516ev200_kernel-4.9.37_sdk-1.0.1.2.patch && \
		patch -p1 < ../12_add_support_for_xt25f64b-s_and_w25q128jvsq_flash.patch && \
		patch -p1 < ../../11_fix_yylloc_for_modern_computers.patch
endif

kernel: $(_KERNEL)
ifeq (,$(wildcard ./$(_KERNEL)/arch/arm/boot/uImage))
	cd $(_KERNEL) && \
	$(MAKE) ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage -j9
endif
	echo Kernel image ready at $(_KERNEL)/arch/arm/boot/uImage
