+++
title = "microPlatform update 0.15"
date = "2018-04-26"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.15

Zephyr with improved network logging and initial WiFi, MCUboot
headed towards 1.2.0, LWM2M usability improvements.


## Linux microPlatform changes for 0.15

Core layer updates based on the latest sumo changes.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr with improved network logging and initial WiFi, MCUboot
headed towards 1.2.0, LWM2M usability improvements.

## Highlights

- Zephyr tree from 1.12 development series
- Minor MCUboot changes from 1.2.0 development series
- LTE-M usability improvements in the dm-lwm2m sample

## Components


### MCUboot


#### Features

##### imgtool create: 
- The imgtool command added a "create" alias for "sign".
This makes the usage more clear when creating an image
for consumption by mcuboot, but deferring the
signature step until later.


##### Configurable number of image sectors: 
- The maximum number of image sectors is now
configurable, which is useful on devices with large
flash devices with many sectors.


##### TinyCBOR copy removed: 
- Zephyr targets no longer use an internal copy of
tinycbor, now that the library has been added to
upstream Zephyr.


##### Documentation: 
- Several documentation improvements were made,
including using serial bootloader mode on MyNewt,
signing instructions for Zephyr, and configuration of
maximum number of boot sectors.


#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### Userspace calling convention change: 
- System calls from userspace on ARM targets now expect all
arguments to be passed via registers, instead of mixing stack and
registers as done previously.


##### DTS alias renames: 
- Various DTS aliases with underscores ("_") in their names were
renamed to use dash ("-") instead. Apparently, underscores were
technically always illegal to use in alias names. This change
avoids a dtc warning in newer versions. In-tree users were
updated; any out of tree applications using the old names will
need changes as well.


##### WiFi: 
- The initial outline for Zephyr's WiFi suport was
merged. Initial definitions were added in the following
areas:

  - device driver skeleton in drivers/wifi
  - an mostly stubbed out main header file,
  include/net/wifi.h
  - WiFi network management in include/net/wifi_mgmt.h,
    including definitions for events from so-called "offloaded"
    devices (which are separate cores that implement WiFi
    funcionality and communicate with the IC running Zephyr
    via a higher-level protocol)
  - shell support for controlling the network management API in
    subsys/net/ip/l2/wifi_shell.c, which can be selected with
    CONFIG_NET_L2_WIFI_SHELL. The initial commands are "wifi
    connect", "wifi disconnect", and "wifi scan".

This is the groundwork for future changes completing the
generic framework and adding individual device drivers.


##### Device tree bindings for GPIO keys and LEDs: 
- Generic device tree bindings for GPIO-based buttons ("keys") and
LEDs were added in dts/bindings/gpio/gpio-keys.yaml and
dts/bindings/gpio/gpio-leds.yaml respectively.

The initial users are STM32-based boards, which now have device
tree nodes for their buttons and onboard LEDs defined.

This change breaks the LED0_GPIO_PORT define
previously present on STM32 builds, changing it to
LED0_GPIO_CONTROLLER. This will affect NXP builds as
well in the next update.


##### ARM privileged mode I-cache flush: 
- ARM cores now flush the instruction pipeline after switching
privilege levels, to prevent execution of pre-fetched
instructions with the previous privilege.


##### Boards: 
- SoC support was added for the Cortex M4 core which is
present in the imx7d SoC. The Zephyr image must be
loaded and run by an A7 core also present on the
SoC. Initial board support was added for the Colibri
iMX7D as "colibri_imx7d_m4".

Sanitycheck now runs on hifive1.

96b_carbon_nrf51 now uses the new nRF SPIS driver.

Userspace mode was enabled by default for sam_e70_xplained.


##### Device tree: 
- Device tree bindings for STM32 GPIOs were defined, and all
STM32-based boards now have GPIO device nodes.


##### Drivers: 
- The native POSIX Ethernet driver now supports network statistics
collection, extending support for the Ethernet interface network
statistics framework that was recently merged.

The driver for the KW41Z BLE and 802.15.4 chip now
supports the OpenThread L2 layer, and received changes
to its RNG source which now feed its (slow and
blocking) entropy source's output into the Xoroshiro
PRNG.

The nRF SPI drivers now appear to be completely supported. There
are three available drivers: spi_nrfx_spi.c is a master-only
driver for older devices (or devices with anomalies) without
direct memory access (DMA) support, spi_nrfx_spim.c is a master
driver for devices with DMA support, and spi_nrfx_spis.c is a
driver for the experimental SPI slave API which uses DMA.


#### Bugs

##### Memory allocation overflow checks: 
- The k_malloc() and k_calloc() calls in the mempool implementation
now properly check for overflow in all configurations.



##### IPv6 crash fixes: 
- A pair of patches fixing IPv6 crashes were merged.



##### Windows getting started guide fixes: 
- Following reports of confusion, the Windows installation guide
has been restructured to make it easier for new users to
understand what their choices are.



##### USB vendor and product ID fixes: 
- A few sample applications (BT's hci_usb, as well as USB dfu and
wpanusb) now use the Kconfig knobs CONFIG_USB_DEVICE_VID and
CONFIG_USB_DEVICE_PID to configure the USB vendor and product
IDs. These knobs say they "MUST be configured by vendor"
(e.g. http://docs.zephyrproject.org/reference/kconfig/CONFIG_USB_DEVICE_VID.html);
they default to 0x2FE3 and 0x100 respectively. The VID 0x2FE3
doesn't appear to be allocated by the USB-IF.



##### Drivers fixes: 
- The wpanusb sample and ENC28J60 Ethernet driver
received fix-ups, and, in the ENC28J60 case,
optimizations.



##### IRQ configuration fix for nRF52840: 
- The number of interrupts on the nRF52840 SoC was fixed.



##### Board configuration fix for nucleo_f103rb: 
- PWM was disabled on nucleo_f103rb, fixing some test build breaks
and continuing Zephyr's move towards a consistent set of default
board configurations.



##### CONFIG_CUSTOM_LINKER_SCRIPT works again: 
- CONFIG_CUSTOM_LINKER_SCRIPT, which allows the user to override
the linker scripts provided by Zephyr itself, was fixed. This had
been broken since the transition to CMake, so it seems to have
few, if any, active users.



##### SAM0 flash driver build fix: 
- The Atmel SAM0 flash driver's build is fixed when
CONFIG_FLASH_PAGE_LAYOUT is disabled.



##### SPI driver core locking fix: 
- A concurrency fix to the SPI driver core was merged.



### hawkBit and MQTT sample application


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### Logging improvements for LTE-M modem build: 
- The modem logging has been improved to allow
sign-of-life output to appear a few seconds from boot
when using the application configuration for the
WCN14A2A LTE-M modem.


##### Endpoint name fix: 
- The endpoing name is now prefixed with "osf:sn:". This
makes it easier to tell apart on busy LWM2M servers,
such as the public Eclipse Leshan instance.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

Core layer updates based on the latest sumo changes.

## Highlights

- Binutils updated to the 2.30 release.
- Glibc updated to the 2.27 release.
- Systemd updated to the 237 release.
- NetworkManager updated to the 1.10.6 release.
- Docker updated to the 18.03.0 release.
- Containerd updated to the 1.0.2 release.
- Runc updated to the 1.0.0-rc5 release.

## Components


### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Binutils updated to 2.30.
Cmake updated to 3.10.3.
Curl updated to 7.58.0.
Git updated to 2.16.1.
Glib-2.0 updated to 2.54.3.
Glibc updated to 2.27.
Go updated to 1.9.4.
Go-dep updated to 0.4.1.
Iptables updated to 1.6.2.
Libpng updated to 1.6.34.
Libunistring updated to 0.9.9.
Linux-libc-headers updated to 4.15.7.
Llvm updated to 6.0.
Musl updated to 1.1.19.
Nspr updated to 4.19.
Nss updated to 3.35.
Openssl updated to 1.1.0h and 1.0.2o.
Patch updated to 2.7.6.
Pkgconf updated to 1.4.2.
Python3 updated to 3.5.5.
Python3-dbus updated to 1.2.6.
Python3-pip updated to 9.0.2.
Python3-pygobject updated to 3.28.1.
Python3-setuptools updated to 39.0.0.
Qemu updated to 2.11.1.
Slang updated to 2.3.2.
Sudo updated to 1.8.22.
Systemd updated to 237.
Vala updated to 0.38.8.
Time updated to 1.8.
Tzdata updated to 2018d.


#### Bugs

##### busybox: 
- runCnt overflow in bunzip2.

 - [CVE-2017-15873](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15873)

##### dhcp: 
- Failure to properly clean up closed OMAPI connections can
exhaust available sockets.

 - [CVE-2017-3144](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3144)

##### libvorbis: 
- Multiple issues.

 - [CVE-2018-5146](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-5146)
 - [CVE-2017-14632](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14632)
 - [CVE-2017-14633](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14633)

##### patch: 
- Multiple issues.

 - [CVE-2018-1000156](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-1000156)
 - [CVE-2018-6951](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-6951)

##### python3: 
- Possible integer overflow in PyBytes_DecodeEscape.

 - [CVE-2017-1000158](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000158)

##### tiff: 
- Multiple issues.

 - [CVE-2017-9935](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9935)
 - [CVE-2017-18013](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-18013)
 - [CVE-2018-5784](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-5784)

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- NetworkManager updated to 1.10.6.
Python-cffi updated to 1.11.4.
Python-cython updated to 0.28.
Python-ply updated to 3.11.


#### Bugs
- Not addressed in this update

### Meta Virtualization


#### Features

##### Layer Update: 
- Docker updated to 18.03.0.
Containerd updated to v1.0.2.
Runc updated to 1.0.0-rc5.


#### Bugs
- Not addressed in this update

### Meta 96boards


#### Features

##### Layer Update: 
- EDK2, ATF and OPP updated to the current upstream revision.
Updated partition table for HiKey, including a new l-loader
recovery binary.
96boards-tools updated to 0.12.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update: 
- U-boot-fslc updated to a07698f.
New machine configuration for t4240rdb, t2080rdb, t1024rdb,
p5040ds, p4080ds, p3041ds, p2041rdb and p1020rdb.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update: 
- Intel-microcode updated to 20180312.
Ixgbe updated to v5.3.6.
Ixgbevf updated to v4.3.4.
Systemd-boot bbappend updated to work with Systemd 237.


#### Bugs
- Not addressed in this update

### Meta Qualcomm


#### Features

##### Layer Update: 
- Firmware-qcom-dragonboard updated to r1034.2.1.
New machine configuration for Dragonboard 600c.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update: 
- BCM43430A1 firmware updated to the latest public revision.
BCM4345C0.hcd added for Raspberry Pi 3B+.
Improved support for Raspberry Pi Zero W and 3B+.
Linux-firmware-raspdebian is now used for the Raspberry Pi
specific firmware packages.


#### Bugs
- Not addressed in this update

### Meta Updater Layer


#### Features

##### Layer Update: 
- Python dependency removed from OSTree.


#### Bugs
- Not addressed in this update

### Meta OSF Layer


#### Features

##### Layer Update: 
- Distro version bumped to 2.5 (sumo based).
Added recipe for docker-init, used by docker.
Python3-docker updated to 3.2.1.
Python3-docker-compose updated to 1.21.0.
Python3-docker-pycreds updated to 0.2.2.


#### Bugs
- Not addressed in this update
