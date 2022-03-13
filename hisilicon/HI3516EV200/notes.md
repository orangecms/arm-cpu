# Platform Integration Notes

## Vendor Code

```sh
YUV_TYPE0=0;                # 0 -- raw, 1 --DC, 3 --bt656
CHIP_TYPE=hi3516ev200;      # chip type
BOARD=demo;

#DDR start:0x40000000, kernel start:0x40000000,  OS(32M); MMZ start:0x42000000
mem_total=64                  # 64M, total mem
mem_start=0x40000000          # phy mem start
os_mem_size=32                # 32M, os mem
mmz_start=0x42000000;         # mmz start addr
mmz_size=32M;                 # 32M, mmz size

insmod sys_config.ko chip=hi3516ev200 sensors=SNS_TYPE0=imx307 g_cmos_yuv_flag=0 board=demo
insmod hi_osal.ko anony=1 mmz_allocator=hisi mmz=anonymous,0,0x42000000,32M
```
