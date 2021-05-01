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
