#!/bin/sh

CFG="chip=hi3516ev200 sensors=SNS_TYPE0=imx307 g_cmos_yuv_flag=0 board=demo"

./cpu /bbin/insmod ./squashfs-root/lib/modules/sys_config.ko $CFG
