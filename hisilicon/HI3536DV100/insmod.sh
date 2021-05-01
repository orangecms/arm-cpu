# sys_config(drv/sys_config): pinmux and ddr priority configuration
insmod /modules/sys_config.ko mode=demo codec="inner"
# MEM_LEN=`echo "234 155"|awk '{printf("%d",$1-$2)}'` ## 79M
# MEM_START=`echo "0x800 0x1 155"|awk '{printf("0x%03x00000",$1+$2*$3)}'` ## 0x89B00000
# osal load (contains mmz.ko/hiuser.ko/media.ko)
insmod /modules/hi_osal.ko  mmz=anonymous,0,0x89B00000,79M:vou,0,0x8EA00000,22M anony=1
#insmod mmz.ko mmz=anonymous,0,$mmz_start,$mmz_size anony=1 || report_error
#insmod hiuser.ko
#insmod hi_media.ko
insmod /modules/hi3536dv100_base.ko
insmod /modules/hi3536dv100_sys.ko mem_total=256

insmod /modules/hi3536dv100_vdec.ko MiniBufMode=1 VBSource=0 u32ProtocolSwitch=1
insmod /modules/hi3536dv100_vfmw.ko
insmod /modules/hi3536dv100_tde.ko
insmod /modules/hi3536dv100_region.ko
insmod /modules/hi3536dv100_vgs.ko

insmod /modules/hi3536dv100_vpss.ko
insmod /modules/hi3536dv100_vou.ko bSaveBufMode=1
insmod /modules/hifb.ko  video="hifb:vram0_size:7200,vram1_size:128" softcursor="off"
insmod /modules/hi3536dv100_hdmi.ko

insmod /modules/hi3536dv100_venc.ko
insmod /modules/hi3536dv100_chnl.ko

insmod /modules/hi3536dv100_jpege.ko
insmod /modules/hi3536dv100_jpegd.ko

# external
# insmod extdrv/hi_rtc.ko
# insmod extdrv/at24c.ko
# insmod extdrv/hiwdt.ko
# insmod extdrv/ES8218_mody.ko
# insmod extdrv/hi_ir.ko
# insmod extdrv/usb-storage.ko
# insmod extdrv/usbserial.ko
# insmod extdrv/usb_wwan.ko
# insmod extdrv/option.ko
# insmod extdrv/GobiNet.ko
#	insmod extdrv/ki_cdc_ether.ko
# insmod extdrv/mtprealloc7601Usta.ko
# insmod extdrv/mt7601Usta.ko

# audio
insmod /modules/hi3536dv100_aio.ko
insmod /modules/hi3536dv100_ai.ko
insmod /modules/hi3536dv100_ao.ko
insmod /modules/hi3536dv100_aenc.ko
insmod /modules/hi3536dv100_adec.ko
#insmod /modules/extdrv/tlv_320aic31.ko
insmod /modules/hi_acodec.ko
