insmod /modules/sys_config.ko chip=hi3516ev200 sensors=unknown g_cmos_yuv_flag=0 board=demo
# 16M means the OS can take the rest of the 64M, so in U-Boot, set `osmem=48M`
# by default, it is `osmem=39M`
insmod /modules/hi_osal.ko anony=1 mmz_allocator=hisi mmz=anonymous,0,0x42000000,16M
insmod /modules/hi3516ev200_base.ko
insmod /modules/hi3516ev200_isp.ko
insmod /modules/extdrv/hi_sensor_i2c.ko
insmod /modules/extdrv/hi_sensor_spi.ko
insmod /modules/extdrv/hi_pwm.ko

insmod /modules/hi3516ev200_sys.ko
insmod /modules/hi3516ev200_rgn.ko
insmod /modules/hi3516ev200_vgs.ko
insmod /modules/hi3516ev200_vi.ko
insmod /modules/hi3516ev200_vpss.ko
insmod /modules/hi3516ev200_chnl.ko
insmod /modules/hi3516ev200_vedu.ko
insmod /modules/hi3516ev200_rc.ko
insmod /modules/hi3516ev200_venc.ko
insmod /modules/hi3516ev200_h264e.ko
insmod /modules/hi3516ev200_h265e.ko
insmod /modules/hi3516ev200_jpege.ko
insmod /modules/hi3516ev200_ive.ko save_power=0

# 1080P@30fps
# insmod /modules/extdrv/hi_sil9024.ko norm=12 i2c_num=2
# norm_mode = 0:PAL, 1:NTSC
# insmod extdrv/hi_adv7179.ko norm_mode=0 i2c_num=2

# audio
insmod /modules/hi3516ev200_aio.ko
insmod /modules/hi3516ev200_ai.ko
insmod /modules/hi3516ev200_ao.ko
insmod /modules/hi3516ev200_aenc.ko
insmod /modules/hi3516ev200_adec.ko
insmod /modules/hi3516ev200_acodec.ko
insmod /modules/hi_mipi_rx.ko
insmod /modules/hi_user.ko
insmod /modules/hi3516ev200_wdt.ko
