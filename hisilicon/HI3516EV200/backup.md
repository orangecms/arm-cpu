# Original Firmware Backup

## Via U-Boot

### Run TFTP Server on Host

1. Install `tftpd-hpa`
2. Adjust config:

`/etc/default/tftpd-hpa`
```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/srv/tftp"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure -c"
```

3. Change permissions on TFTP directory:
```
sudo chown tftp:tftp /srv/tftp/
```

4. Download U-Boot from OpenIPC

**TODO**

5. Boot into OpenIPC U-Boot from memory

**TODO**

6. Load from flash part to memory and send backup to TFTP server:
Camera:

```
sf probe
sf read 0x43000000 0x800000
tftpput 0x43000000 0x800000 192.168.0.82:fw.bin
```

## From Linux via LinuxBoot/u-root

1. Build image (`make`)

2. Boot image on camera

**TODO**

Note: `serverip` is your host's IP address (where you run the TFTP server)

Camera / U-Boot:
```
printenv
setenv bootcmdbak ${bootcmd}
setenv bootargbak ${bootargs}
setenv ipaddr 192.168.0.222
setenv serverip 192.168.0.82
setenv bootcmd 'tftp 0x42000000 HI3516EV200.uimage;setenv setargs setenv bootargs ${bootargs};run setargs;bootm 0x42000000'
setenv bootargs mem=49M console=ttyAMA0,115200 root=/dev/mtdblock1 rootfstype=squashfs mtdparts=hi_sfc:0x40000(boot),0x2E0000(romfs),0x420000(user),0x40000(web),0x30000(custom),0x50000(mtd) ethaddr=00:12:41:b3:7e:70
saveenv
```

3. Network Setup
```sh
dhclient -ipv6=false
```

4. Copy over files

Host:
```sh
nc -l 3333 > mtdblock1.bin
```

Camera:
```sh
cat /dev/mtdblock1 | netcat 192.168.0.82:3333
```
