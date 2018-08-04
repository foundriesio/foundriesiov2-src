+++
title = "microPlatform update 0.10"
date = "2018-03-13"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.10

Zephyr tree from the 1.11 stabilization process, related
MCUboot updates for CVE-2018-0488 and CVE-2018-0487.


## Linux microPlatform changes for 0.10

OSF Unified Linux Kernel updated to the 4.14.19 stable release.
UsrMerge (https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/)
is now enabled by default in LMP.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr tree from the 1.11 stabilization process, related
MCUboot updates for CVE-2018-0488 and CVE-2018-0487.

## Highlights

- Zephyr support for SMP, Arm v8-M, out of tree boards, and more
- MCUboot updates for Zephyr mbedTLS update to fix a security issue
- No changes to the sample applications
- New Python dependency on intelhex module

## Components


### MCUboot


#### Features

##### Serial boot for Mynewt port: 
- The serial boot protocol now works in the Mynewt port.
The UART is now only initialized when the serial
protocol is requested.


##### Configuration fixes for RSA: 
- Some configuration fixes were merged related to RSA-
based image signatures.


##### Intel: 
- 'The imgtool script now supports Intel Hex images. This
adds a new intelhex PyPI dependency. Users can install
the new dependency by running the following command:'

pip3 install --user intelhex


#### Bugs

##### mbedTLS 2.7.0 support fix: 
- A fix was merged which enables MCUboot to work with
mbedTLS 2.7.0. This new version resolves remote code
execution bugs identified as CVE-2018-0488 and
CVE-2018-0487.



### Zephyr


#### Features

##### Symmetric multiprocessing support: 
- The Zephyr kernel now has symmetric multiprocessing
(SMP) support. The Xtensa architecture uses this
feature to support SMP SoCs on ESP32.


##### Initial Arm v8-M support: 
- 'Basic support for Arm v8-M cores was merged. This
breaks Kconfig options related to the core; for
example, CONFIG_ARMV6_M no longer exists. There are
new options, such as CONFIG_ARMV6_M_ARMV8_M_MAINLINE,
which cover a more general set of CPUs. See the
updated list in a0a03d75 ("arch: arm: common Armv8-M
support") for more details.'


##### Out of tree board support: 
- 'Support for out of tree custom boards was merged. This
allows users to support a board without having to
change the Zephyr tree itself. The directory
containing the board definition files can be provided
via the BOARD_ROOT CMake variable. This directory must
have the same structure as the contents of Zephyr\'s
own "boards" top-level directory.'


##### Sanitycheck uses Ninja by default: 
- Sanitycheck now defaults to using Ninja. Users who are
running sanitycheck on their own systems must install
Ninja or explicitly add the -M option to continue
using Make.


##### ZEPHYR_GCC_VARIANT deprecated and renamed: 
- The ZEPHYR_GCC_VARIANT environment variable is now
deprecated. Users must move to using
ZEPHYR_TOOLCHAIN_VARIANT instead.


##### Network buffer management re-written: 
- The network buffer management strategy was re-worked
to separate data and meta-data into separate buffers.
This is part of a longer-term re-work of the network
buffer management to allow better offloading support,
among other features and optimizations.


##### HTTP library restored to mainline version: 
- The upstream HTTP library has been fixed, so OSF is no
longer carrying a revert of upstream changes which
introduced regressions.


##### User-space for Arm cores with MPU: 
- User-space support for Arm MCUs with Memory Protection
Units (MPUs) was merged, including support for the NXP
and Arm MPUs.


##### User-space for ARC: 
- User-space support for the ARC architecture was
merged, which implied several changes to thread
context management.


##### Device tree fixups refactored to SoC level: 
- Various device tree fixup files were refactored into
SoC-specific files.


##### Entropy device for native port: 
- The native port now has an entropy device.


##### New Linux Foundation Bluetooth company ID: 
- Bluetooth improvements related to continuous scanning,
random number use, and using the new Linux Foundation
company ID were merged, among various refactorings.


##### zephyr-env.cmd for Windows: 
- Windows users now have a zephyr-env.cmd command, which
sets up the environment analogously to zephyr-env.sh
in Unix environments.


##### Flash device labels for device tree: 
- Device tree now supports flash labels.


##### Common device tree overlay support files: 
- There is now support for a common set of DTS overlays,
via the DTS_COMMON_OVERLAYS CMake variable. The first
user is to enable a common flash-related overlay when
CONFIG_BOOTLOADER_MCUBOOT is set.


##### SPI nodes for STM32 device trees: 
- SPI nodes were added to STM32 device trees.


##### USB nodes for STM32 device trees: 
- STM32 USB device tree bindings were merged.


##### Nested interrupt controller support: 
- Support was added for nesting interrupt controllers.


##### Improved CRC16 implementation: 
- A new, faster CRC16 implementation was added.


##### I2C master for Nios-II: 
- An I2C master driver for Nios-II cores was added.


##### APA102 LED driver: 
- A driver for the APA102 LED chip driver was added,
along with a bit-banged implementation of WS2812B LED
chips for nRF51.


##### Interrupt driven UART for SAM: 
- An interrupt-driver UART driver was added for Atmel
SAM MCUs.


##### PWM for ESP32: 
- A PWM LED driver was added for ESP32.


##### TinyCBOR library dependency vendored: 
- The TinyCBOR library was added as an external
dependency.


##### mcumgr support: 
- Zephyr gained support for mcumgr-based device
management in the new mgmt subsystem.


##### Spinlock API: 
- A new spinlock API was added. This is used by the SMP
implementation.


##### POSIX compatibility layers: 
- Compatibility layers were added for the POSIX pthread,
scheduler, sleep, clock, and timer APIs. These and
other POSIX-related headers can be found in the
include/posix directory.


##### Statistics subsystem: 
- A new subsystem, stats, was added as a generalized
mechanism for collecting statistics about events.


##### Default network device selection: 
- The default network interface can now be selected via
Kconfig.


##### Device power sources knob for LWM2M: 
- The LWM2M implementation now has a maximum device
power source configuration option.


#### Bugs

##### Networking fixes: 
- Numerous networking fixes were merged, related to
getaddrinfo(), TCP packet retransmission, and ICMP
packet rejection, handling of the L2 carrier going
down, and IPv6 neighbor solicitation. Various HTTP
library regressions and other issues were also fixed.



##### Kconfig fixes from native architecture: 
- 'The native architecture has fixes for Kconfig
"multiple prompts" warnings, timers, IRQs, and tickless
mode.'



##### Arm stack size fixes: 
- Arm has fixes related to calculating the stack size
and fault address logging.



##### x86 build warning fix: 
- x86 has a build warning fix.



##### XTensa thread fixes: 
- XTensa has fixes for thread entry, stack alignment,
and compilation warnings on ESP32.



##### Bluetooth core fixes: 
- The core Bluetooth controller received over ten fixes,
largely related to timing.



##### Bluetooth Mesh fixes: 
- Bluetooth Mesh received five fixes, including a null
pointer dereference and issues related to failed
transmission handling.



##### STM32 device tree fixes: 
- Numerous device tree fixes were merged for
STM32 SoCs.



##### I2C fixes for ESP32: 
- The I2C driver for ESP32 received seven fixes related
to message transmission and reception.



##### PWM fix for nRF51: 
- The PWM configuration for nRF51 was fixed.



##### Flash and Bluetooth fix for nRF5: 
- The nRF5 flash driver's cooperation with the Bluetooth
controller received a bugfix.



##### GPIO fix for Nios-II: 
- The Nios-II GPIO controller configuration received a
bug fix.



##### Network loopback driver fix: 
- The loopback network driver fixed a double-unreference
bug.



##### Thread monitor fix for Arm: 
- Thread monitor swapping on Arm received a bugfix.



##### SLIP fix: 
- The network SLIP driver received a fix when not
operating in TAP mode.



##### Miscellaneous net-app fixes: 
- The net-app library received multiple fixes, including
for issues affecting connection closure and
configuring a local context.



##### Network event fixes: 
- The network management implementation received a fix
for routing network events.



##### Network offload fixes: 
- Network offload management received a concurrency and
socket flag fix.



##### Entropy driver fixes: 
- Various fixes to the entropy drivers were fixed.



### hawkBit and MQTT sample application


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

OSF Unified Linux Kernel updated to the 4.14.19 stable release.
UsrMerge (https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/)
is now enabled by default in LMP.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.19.
- Root file system is now compatible with UsrMerge.
- Beaglebone machine name renamed to beaglebone-yocto.

## Components


