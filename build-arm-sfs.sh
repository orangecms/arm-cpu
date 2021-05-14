#!/bin/sh

set -e

export GO111MODULE=off
export GOARCH=arm
_NAME=u-root-victure
_DIR=/tmp/$_NAME

u-root -o $_DIR.cpio \
  -files ~/.ssh/cpu_rsa.pub:key.pub \
  -files usr/modules/8188fu.ko:lib/modules/8188fu.ko \
  -files usr/modules/otg-hs.ko:lib/modules/otg-hs.ko \
  -files usr/modules/sdio_wifi.ko:lib/modules/sdio_wifi.ko \
  core \
  github.com/u-root/cpu/cmds/cpud

sudo rm -rf $_DIR
mkdir -p $_DIR
(cd $_DIR && sudo cpio -i < $_DIR.cpio)
rm $_NAME.sfs
mksquashfs $_DIR $_NAME.sfs -comp xz
