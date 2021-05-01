#!/bin/sh

dd if=firmware.bin bs=1024            count=320  of=boot.bin
dd if=firmware.bin bs=1024 skip=320   count=3968 of=romfs.bin
dd if=firmware.bin bs=1024 skip=4288  count=7040 of=usr.bin
dd if=firmware.bin bs=1024 skip=11328 count=1600 of=web.bin
dd if=firmware.bin bs=1024 skip=12928 count=2816 of=custom.bin
dd if=firmware.bin bs=1024 skip=15744 count=128  of=logo.bin
dd if=firmware.bin bs=1024 skip=15872 count=512  of=mtd.bin
