+++
title = "microPlatform update 0.9"
date = "2018-02-21"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.9

MCUboot history was rewritten following v1.1.0 release. Zephyr
integrates OpenThread support, and has the usual set of
incompatible changes.


## Linux microPlatform changes for 0.9

OSF Unified Linux Kernel updated to the 4.14.17 stable release.
Default GCC version was updated to the latest upstream 7.3 release.

<!--more-->
# Zephyr microPlatform

## Summary

MCUboot history was rewritten following v1.1.0 release. Zephyr
integrates OpenThread support, and has the usual set of
incompatible changes.

## Highlights

- Non-fast-forward update for MCUboot onto the post-v1.1.0 development branch
- Zephyr updates from the 1.11 development branch

## Components


### MCUboot


#### Features

##### Flash mass erase: 
- MCUboot's build system now tries to mass-erase the
flash device when the board runner supports it. This
ensures a consistent initial state. It can be disabled
using the CONF_ZEPHYR_TRY_MASS_ERASE bootloader
configuration option.


#### Bugs

##### Zephyr workaround for FLASH_DRIVER_NAME rename: 
- The Zephyr port has a shim to work around a rename of
FLASH_DRIVER_NAME to FLASH_DEV_NAME upstream.



##### Documentation fixes: 
- Various documentation fixes were merged. The
documentation was rewritten as markdown, and all moved
to docs/.



##### Zephyr usability fixes: 
- Numerous bug fixes and usability improvements were
merged for the Zephyr port.



### Zephyr


#### Features

##### OpenThread support with 802.15.4 improvements: 
- OpenThread support was merged into Zephyr, along with
support for the 802.15.4 radio layer. This affects the
L3 and L2 layers of the Zephyr networking stack as
well.


##### DTC_OVERLAY_FILE now accepts a list: 
- Multiple device tree overlay files are now supported
by setting DTC_OVERLAY_FILE to a whitespace-separated
list of files to use. This is analogous to how
CONF_FILE works. The file dts.overlay in the
application directory will be used by default if it is
present and DTC_OVERLAY_FILE is not defined.


##### DTC_OVERLAY_DIR removed: 
- The old DTC_OVERLAY_DIR variable is no longer
supported; applications should update to use
DTC_OVERLAY_FILE only.


##### FLASH_DRIVER_NAME renamed to FLASH_DEV_NAME: 
- The old FLASH_DRIVER_NAME was removed. Applications
should use FLASH_DEV_NAME. MCUboot has been updated to
reflect this change.


##### Legacy HTTP removed upstream: 
- The legacy HTTP API has been removed, but the commit
with this support has serious problems, as detailed
in the following issue.

https://github.com/zephyrproject-rtos/zephyr/issues/6010

The OSF tree has temporarily reverted this commit; we
are working with upstream on a better solution.


##### Humidity sensor channel units redefined: 
- The humidity sensor channel units were redefined to
percents, not milli-percents. Applications using this
API will need to update to the new unit.


##### GET_DISK_SIZE ioctl removed: 
- The filesystem GET_DISK_SIZE IOCTL was removed.


##### Bluetooth refactoring continues: 
- The Bluetooth controller core continues to be cleaned
up and refactored as part of a sequence of general
improvements.

Various Bluetooth APIs were renamed from the radio_ to
the ll_ namespace.


##### ARM CMSIS headers updated: 
- ARM CMSIS headers were updated to version 5.2.0.


##### New sensor channels: 
- New sensor channels were added for CO2, VOC, voltage,
and current, along with support for the CCS811 gas
sensor device.


##### POSIX interaction with stdin: 
- The native POSIX target now supports console
interaction with stdin.


##### External mbedTLS support: 
- It is now possible to use an external mbedtls
implementation. Applications interested in taking
advantage of this should refer to the help for
CONFIG_MBEDTLS_LIBRARY.


##### USB HID support: 
- The USB subsystem now includes an HID class and sample
application demonstrating its functionality.


##### IPv6 improvements: 
- IPv6 neighbor addition and deletion is now supported.
Network interfaces using IPv6 can now route packets
between themselves.


##### Flashing for JLink boards: 
- Boards using JLink can now be flashed using the build system
flash target.


##### New STM32 features: 
- SPI support was added for STM32F1 targets.

STM32F072 SoC support added as well as board
configurations for STM32F072-EVAL and
STM32F072B-DISCO.

I2C support was added to the nucleo_f411re and for
nucleo_f429zi boards.


##### ST vl53l0x time of flight sensor: 
- Added support for the ST vl53l0x time of flight
sensor. This included an import of the official ST
library supporting the vl53l0x.


##### DFU/mcuboot subsystem improvements: 
- The DFU subsystem received miscellaneous improvements,
as well as additional APIs useful for targets built
for chain-loading by MCUboot.


##### PCI enumberation for Atom-based targets: 
- Atom-based targets now support enumerating PCI
devices.


##### erase-block-size property for DTS flash nodes: 
- The DTS flash bindings now support an optional erase-
block-size property.


##### Flash page layout support for NXP devices: 
- NXP-based devices use newly updated flash DTS bindings
to support the flash page layout APIs, which improves
their MCUboot support and eliminates compiler warnings
when building MCUboot on those targets


##### DTS sensor nodes for NXP boards: 
- Various DTS nodes and fixup files were added for
sensor nodes on NXP boards.


##### Pinux for Atmel SAM0: 
- SAM0 based devices now have a pinmux driver.


##### New kconfig options for controlling optimization: 
- A new CONFIG_NO_OPTIMIZATIONS flag allows users to
control the optimization level with GCC compatible
compilers with a single switch, among other
optimization level changes.


##### NXP LPC SoC family support: 
- Add Zephyr support for NXP's LPC SoC family. Including
an initial import of the device header and driver
files for lpc54114 from mcux 2.2.1. The first board
supported is the lpcxpresso54114. Shim drivers were
also introduced for pinmux, GPIO and USART.


##### Emulated vector table relocation for M0 targets: 
- For ARM Cortex M0 targets, support was added for a
software relay table for interrupt handling. This
allows runtime changes to IRQ handler routines on
these targets, which do not have hardware support for
relocating the vector table. This is a prerequisite
for enabling MCUboot support on these targets.


##### Support for M0 targets with hardware vector table relocation: 
- Additional support for M0 targets which do support
hardware vector table relocation, such as STM32F0, was
also added.


##### SoC-level device tree fixup files: 
- Add support for SoC family level fixup files. This
should remove the need for several duplicated fixup
files at the board level.


##### Runtime for simulated nRF52 devices: 
- Zephyr now supports running simulated nRF52 hardware.


##### Nordic HAL updates: 
- Replace the Nordic HAL and MDK with the nrfx extract
based on the nRF5 SDK 0.8.0.


##### abs function added to Zephyr minimal libc: 
- Added abs function to minimal libc implementation.


##### New kconfig option for enabling MCUboot support: 
- Added the BOOTLOADER_MCUBOOT config to make the
resulting image bootable by the MCUboot open source
bootloader. Currently, this includes the text section
offset and the vector relay table for Cortex-M0.


##### New DTS bindings: 
- In device tree, YAML bindings were added for SPI
devices, bluetooth modules, and SPI bluetooth modules.
Support was also added for flash controller nodes on
STM32 targets. Applications may also now add their own
dts.fixup files. All x86 targets now support device
tree.


##### Console harness support for samples: 
- Various samples now support a console harness, which
can be used to evaluate whether their console output
matches expectated values.


#### Bugs

##### Ninja fixes for flashing and debugging: 
- The flash, debug, and debugserver targets now properly
interact with the console when Ninja is used instead
of Make. This is an important fix for users who have
multiple boards using the same flash or debug backend.



##### Hackaround for flash write protection on NXP mcux devices: 
- A hacky fix for a missing write protection
implementation was merged for the mcux flash driver,
which allows it to interoperate with the DFU subsystem
for MCUboot.



##### LWM2M fixes: 
- The LWM2M subsystem received four fixes.



##### Networking fixes: 
- Seven other fixes were merged to the networking
subsystem, mostly related to RPL.



##### Build break fixed on ARM with userspace enabled: 
- The build was fixed on ARM if user space support was
selected.



##### Native target fixes for code coverage testing: 
- The native target saw several bug fixes, excluding
unlikely or unreachable code from the coverage
reports.



##### Core Bluetooth fixes: 
- The core Bluetooth controller saw several fixes for
edge cases. It continues to pass conformance tests.


Various tweaks and refactoring patches were merged
into the Bluetooth subsystem, including timing
adjustments for nRF52840-DK, support for non-
connectable builds, and separation of some Nordic-
specific code from the core into the HAL.



##### Bluetooth Mesh fixes: 
- Bluetooth Mesh saw five fixes related to SeqAuth
values, timeout calculations, CID passing, and Kconfig
documentation.



##### Documentation spelling fixes: 
- Various spelling fixes throughout the documentation
were merged.



##### nRF PWM fixes: 
- The nRF PWM driver received three fixes.



##### STM32 UART fixes: 
- The STM32 UART driver received a fix related to baud
rate setting.



##### Atmel SAM0 SPI fixes: 
- The SAM0 SPI driver received a group of fixes.



##### Size report fixes for Windows: 
- Fixed up the size reporting on Windows.



##### Console fix for NXP FRDM KL25Z: 
- Console support was fixed on NXP FRDM KL25Z.



##### Crash fix when CONFIG_THREAD_MONITOR enabled: 
- Fixed bug when CONFIG_THREAD_MONITOR is enabled,
repeated thread abort calls on a dead thread will
cause the _thread_monitor_exit to crash.



### hawkBit and MQTT sample application


#### Features

##### FLASH_DEV_NAME update: 
- The FLASH_DRIVER_NAME to FLASH_DEV_NAME rename was handled.


##### DTC_OVERLAY_FILE update: 
- The removal of DTC_OVERLAY_DIR in favor of using
DTC_OVERLAY_FILE as a list was handled.


##### FRDM-K64F temp sensor via DTS: 
- The sensor which provides temperature readings on
FRDM-K64F was converted from Kconfig to device
tree. This was handled.


##### Upstream DFU library: 
- The sample was converted to use the upstream version
of the DFU/mcuboot library. It now prints its image
version on startup as a consequence.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### FLASH_DEV_NAME update: 
- The FLASH_DRIVER_NAME to FLASH_DEV_NAME rename was handled.


##### DTC_OVERLAY_FILE update: 
- The removal of DTC_OVERLAY_DIR in favor of using
DTC_OVERLAY_FILE as a list was handled.


##### FRDM-K64F temp sensor via DTS: 
- The sensor which provides temperature readings on
FRDM-K64F was converted from Kconfig to device
tree. This was handled.


##### Upstream DFU library: 
- The sample was converted to use the upstream version
of the DFU/mcuboot library. It now prints its image
version on startup as a consequence.


##### Firmware version fixed: 
- The dummy firmware version object implementation was
replaced with the actual version read via the MCUboot
header.


##### Cleanups: 
- Various cleanups were performed. An obsolete README
was removed, the NET_DEBUG_APP Kconfig was fixed, the
IPSO light control object setup was moved into its own
file, resource usage was reduced to keep DTLS working
after some upstream Zephyr size increases, and old
Linaro references were removed, among others.


#### Bugs

##### Fix for DTLS credentials: 
- A bug affecting correct parsing of DTLS credentials
was fixed.


# Linux microPlatform

## Summary

OSF Unified Linux Kernel updated to the 4.14.17 stable release.
Default GCC version was updated to the latest upstream 7.3 release.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.17.
- GCC updated to the latest 7.3 release.
- U-Boot updated to the 2018.01 release.
- QEMU guest support added to intel-corei7-64.

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.14.17.
QEMU guest support added to intel-corei7-64.
Default EFI_PROVIDER for intel-corei7-64 changed to grub-efi.
Machine specific configuration moved from conf/local.conf to
lmp-machine-custom.bbclass.
Initial support for colibri-imx7.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Python packaging was restructured and replaced with autopackaging.
U-Boot updated to the 2018.01 release.
Bash updated to 4.4.12.
Gdbm updated to 1.14.1.
Iw updated to 4.14.
Systemd-bootchart updated to v233.
Python-setuptools updated to 38.4.0.
Nspr updated to 4.18.
Sqlite3 updated to 3.22.0.
Vte updated to 0.50.2.
Curl updated to 7.57.0.
Tzcode and tzdata updated to 2018c.
GCC updated to 7.3.
Hdparm updated to 9.53.
Gzip updated to 1.9.
Lsb updated to 5.0.
Kmod updated to 25.
Less updated to 529.
Libunwind updated to 1.2.1.
Linux-libc-headers updated to 4.14.13.
Man-pages updated to 4.14.
E2fsprogs updated to 1.43.8.


#### Bugs

##### glibc: 
- Multiple issues.

 - [CVE-2017-15671](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15671)
 - [CVE-2017-16997](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-16997)
 - [CVE-2017-17426](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17426)

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- Python-certifi updated to 2018.1.18.


#### Bugs
- Not addressed in this update

### Meta Virtualization


#### Features

##### Layer Update: 
- Fixes required by latest OE-Core update.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update: 
- New machine configuration files for t1042d4rdb, t1042d4rdb-64b,
p2020rdb and mpc8548cds.
imx-codec, imx-parser and imx-vpuwrap updated to v4.3.2.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update: 
- Default EFI_PROVIDER changed to systemd-boot.
Thermald updated to 1.7.1.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update: 
- BCM43430A1 firmware updated to the latest public revision.


#### Bugs

##### broken wifi support: 
- Linux-firmware changed to use the correct override for bcm43430.



### Meta 96boards


#### Features

##### Layer Update: 
- EDK2, ATF and OPP updated to the current upstream revision.
New machine configuration file for orangepi i96.


#### Bugs
- Not addressed in this update
