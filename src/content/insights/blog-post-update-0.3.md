+++
title = "microPlatform update 0.3"
date = "2017-12-07"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.3

This is the first Zephyr microPlatform update which uses the new CMake
build system, which has replaced the use of Kbuild.

As described in the summary from https://app.foundries.io/mp/zmp/0.2, all
users will need to update any out of tree application build systems.


## Linux microPlatform changes for 0.3

Linux microPlatform add supports for generic 64bit Intel targets.
Validated with Minnowboard Turbot and NUC variants.

Layer updates for meta-osf, and meta-intel.

<!--more-->
# Zephyr microPlatform

## Summary

This is the first Zephyr microPlatform update which uses the new CMake
build system, which has replaced the use of Kbuild.

As described in the summary from https://app.foundries.io/mp/zmp/0.2, all
users will need to update any out of tree application build systems.

## Highlights

- Zephyr tree from 1.10 release candidate, with CMake
- MCUBoot and FOTA sample build systems ported to CMake

## Components


### MCUBoot


#### Features

##### CMake-based build system:
- The Zephyr build system was rewritten to use cmake
instead of Kbuild, following the equivalent upstream
change.


#### Bugs

##### Fix jump to invalid target when not validating slot 0:
- A bug fix to the core bootloader was merged which
affects configurations that do not validate slot 0
before booting into it. In these configurations, the
bootloader would jump to any flash, regardless of if the
mcuboot header contained a valid magic number.



##### Build fix for Zephyr with ECSDA:
- A bug fix to Zephyr targets was merged which restores
the build when using ECDSA (rather than the default
RSA).



### Zephyr


#### Features

##### New build system:
- "The most significant change facing application
developers is a complete rewrite of the build system to
use CMake instead of the Makefile-based Kbuild system
borrowed from the Linux kernel. All applications will
need to rewrite their build systems to adapt;
instructions are available in the Zephyr Application
Development Primer, available in the Zephyr
documentation:

http://docs.zephyrproject.org/application/application.html"


##### Wide-ranging Bluetooth Mesh improvements:
- Over a hundred patches, fixes, documentation, release
notes, and other improvements to Bluetooth Mesh were
merged.


##### NXP i.MX support:
- Support for the NXP i.MX SoC family was merged, along
with board support for a new target, mimxrt1050_evk.


##### Device tree comes to x86...:
- X86 devices based on QUARK_X1000 gained device tree
support. The galileo board has a devicetree defined
which can be used as an example when starting to use DT
on x86.


##### ...and to ARC:
- Among Device tree support was added for ARC devices, as
well as minnowboard, atom based devices,
arduino_101_sss, quark_se_c1000_ss_devboard.


##### Network loopback devices:
- Loopback device support was merged in the networking
subsystem.


##### Additional format specifiers for printk():
- The printk() function now supports string format
specifiers.


##### TinyCrypt update:
- TinyCrypt was updated to 0.2.8.


##### New Atmel SAM drivers:
- New drivers were added for Atmel SAM I2S and DMA
(XDMAC).


##### Particulate matter sensor support:
- Sensor channels for particulate matter were added, and a
driver for the plantower PMS7003 sensor was merged.


##### User buffer validation support for ARM:
- Support for validating user buffers when
CONFIG_USERSPACE=y was merged for the ARM architecture.


##### Userspace protection tests:
- Tests for userspace protection were merged.


##### STM32L476G Discovery:
- Board support was added for STM32L476G Discovery.


##### OpenOCD improvements to STM32 targets:
- openocd support was added for nucleo_l476rg and
stm32l496g_disco.


##### PWM2 for stm32f4_disco:
- PWM2 support was added for stm32f4_disco.


##### Additional em-starterkit configurations:
- EM11D and EM7D configurations were added for
em-starterkit.


##### Altera HAL support:
- External library support was added for the Altera
Hardware Abstraction Library (HAL).


##### Altera soft IP serial and timers:
- New drivers were merged for Altera soft IP serial ports
and timers.


##### Additional mcux targets:
- Driver support was added using the mcux driver for
mimxrt1051 and mimxrt1052 devices.


##### Entropy for nRF5:
- An entropy device driver was merged for nRF5 targets.


##### Ethernet over USB documentation:
- Documentation was added for Ethernet over USB.


##### More tests converted to ztest:
- The push to convert to the ztest framework continues.


#### Bugs

##### ARM fix for crashes setting up new threads:
- A bug fix for ARM which prevents crashes when setting up
new threads was merged.



##### Build fixes for x86_jailhouse and nucleo_f091rc:
- Build breaks for the x86_jailhouse and nucleo_f091rc
boards were fixed.



##### Kconfig cleanups:
- Some Kconfig dependencies and definitions were fixed and
cleaned up.



##### STM32 I2C and USB fixes:
- Bugs affecting STM32 I2C v2 and USB were fixed.



##### Net fixes:
- A few bug fixes for struct net_pkt were merged,
correcting the data length appended by net_pkt_append(),
fixing accounting for IP header lengths, and avoiding a
possible division by zero. The MTU is now honored when
TLS and DTLS are used, among other MTU-related fixes.
Network contexts are unlocked in case of error,
resolving possible deadlock issues. Sockets now support
IPv6 wildcard and loopback addresses. A net packet leak
in the socket layer was fixed. Several LWM2M fixes were
merged, both to the engine core and to the temperature
IPSO object. Several fixes were merged to the new HTTP
library, which is the subject of ongoing discussion on
the mailing list.



##### Fixes to 802.15.4 L2 core:
- A few fixes and improvements to the core 802.15.4
implementation were merged.



##### 802.15.4 on kw41z fixes:
- Various fixes for 802.15.4 on kw41z were merged.



##### PWM on nRF5 fixes:
- Fixes were merged for PWM on nRF5 targets



##### GPIO on ESP32 fixes:
- Fixes were merged for GPIO on esp32.



##### DesignWare USB fixes:
- Fixes were merged for the DesignWare USB IP block driver.



##### Miscellaneous kernel fixes:
- Miscellaneous minor improvements and cleanups were made
in the core kernel.



##### Shell subsystem fixes:
- The shell subsystem received numerous updates, fixes,
and cleanups.



### Zephyr FOTA Samples


#### Features

##### Port to CMake:
- The application build systems were converted to CMake.


##### dm-hawkbit-mqtt uses mgmt.foundries.io for hawkBit:
- The dm-hawkbit-mqtt sample now uses mgmt.foundries.io as
its hawkBit host. This is not a public host managed by
Foundries.io; instead, it is an unused host
that needs to be configured in the local network for the
sample to work properly. This can be done via hosts
configuration on a gateway device.


#### Bugs

##### Fix Bluetooth MAC address for Linux 4.12 and later:
- Bluetooth communication from Zephyr with stacks on
Linux kernels newer than 4.11 require the removal of
CONFIG_NET_L2_BT_ZEP1656 due to several bugs being
fixed in Linux.

One of these changes stops toggling the U/L bit of the
BT MAC address as a signifier for a public or random
address. Due to this change, the FOTA samples adjust
the fifth octet of the address to work correctly when
CONFIG_NET_L2_BT_ZEP1656 is disabled.

This fixes communication problems with several nodes
connected via 6lowpan on recent Linux kernels.


# Linux microPlatform

## Summary

Linux microPlatform add supports for generic 64bit Intel targets.
Validated with Minnowboard Turbot and NUC variants.

Layer updates for meta-osf, and meta-intel.

## Highlights

- Added meta-intel layer to provide intel-corei7-64 machine type
- Switched Intel targets to use OSF kernel
- Enabled specific drivers for Minnowboard Turbot variants
- Migrated linux-osf to use the linux-yocto infrastructure

## Components


### Meta OSF Layer


#### Features

##### Layer Update:
- Added support for generic 64bit Intel targets using OSF
kernel.
Enabled Minnowboard Turbot specific platform drivers.
Migrated linux-osf to use the linux-yocto infrastructure.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Addition:
- Initial import of the meta-intel layer.


#### Bugs
- Not addressed in this update
