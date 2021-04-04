#!/bin/sh

export GO111MODULE=off

_BASE=https://github.com/u-root
_UROOT_REF=master
_CPU_REF=main

wget $_BASE/u-root/archive/$_UROOT_REF.tar.gz -O u-root.tar.gz
tar -xf u-root.tar.gz
wget $_BASE/cpu/archive/$_CPU_REF.tar.gz -O cpu.tar.gz
tar -xf cpu.tar.gz

makebb u-root-$_UROOT_REF/cmds/core/* cpu-$_CPU_REF/cmds/cpud
