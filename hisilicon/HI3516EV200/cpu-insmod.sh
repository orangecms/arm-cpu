#!/bin/sh

CFG="chip=hi3516ev200 board=demo"

./cpu /bbin/insmod ./squashfs-root/lib/modules/sys_config.ko $CFG
