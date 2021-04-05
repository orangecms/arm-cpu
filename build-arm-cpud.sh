#!/bin/sh

export GO111MODULE=off
export GOARCH=arm
_DIR=root-arm-cpud

# TODO: initcmd, shell, copy modules using -files from:to, etc

rm -rf $_DIR
u-root -initcmd="" -defaultsh="" -format dir -o $_DIR \
 core \
 github.com/u-root/cpu/cmds/cpud

# tar.gz
tar -czf $_DIR.gz $_DIR
# squashfs
mksquashfs $_DIR $_DIR.sfs -comp xz
