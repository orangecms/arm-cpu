#!/bin/sh

set -e

export GO111MODULE=off
export GOARCH=arm
_NAME=u-root-arm
_DIR=/tmp/$_NAME

# deliberately not /lib/modules because u-root would load them automatically
# but then in the wrong order
u-root -o $_DIR.cpio \
  -files cpu_rsa.pub:key.pub \
  -files modules:modules \
  -files insmod.sh \
  core \
  github.com/u-root/cpu/cmds/cpud

# https://github.com/u-root/u-root/#compression
xz --check=crc32 -9 --lzma2=dict=1MiB --stdout $_DIR.cpio | \
  dd conv=sync bs=512 of=$_DIR.cpio.xz
