+++
title = "microPlatform update 17.10.1"
date = "2017-10-13"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 17.10.1

This release includes MCUBoot version 1.0.0, and a Zephyr tree that
is based on 1.10. It also includes a new IoT Foundry application.

The Zephyr tree includes many new features and bug fixes. Notable
improvements for the Zephyr microPlatform include LWM2M protocol
support, mainline support for 96Boards Carbon networking, DTLS
support for the net_app library, and various Bluetooth and networking
fixes.

A new IoT Foundry application was added for a demonstration system
providing firmware update and device communication via LWM2M.


## Linux microPlatform changes for 17.10.1

This is the first Linux microPlatform release created by Foundries.io.

<!--more-->
# Zephyr microPlatform

## Summary

This release includes MCUBoot version 1.0.0, and a Zephyr tree that
is based on 1.10. It also includes a new IoT Foundry application.

The Zephyr tree includes many new features and bug fixes. Notable
improvements for the Zephyr microPlatform include LWM2M protocol
support, mainline support for 96Boards Carbon networking, DTLS
support for the net_app library, and various Bluetooth and networking
fixes.

A new IoT Foundry application was added for a demonstration system
providing firmware update and device communication via LWM2M.

## Highlights

- Zephyr tree from 1.10 development tree, with LWM2M support, support for 96Boards Carbon, and libraries for managing interactions with MCUBoot
- MCUBoot version 1.0.0
- New application for IoT Foundry demonstrating LWM2M
- Many other bug fixes and improvements across the trees

## Components


### MCUBoot


#### Features

##### New header format:
- For the 1.0 release, MCUBoot has received a new image
header format.

The most important change from version 0.9 is a new
header format, in which all signature information is
moved from the header into the block of key/value TLVs
which follow the image, in a new format. This allows
supporting multiple signatures, changing the signature
without changing the image, and other feature
improvements. See docs/release-notes.md for more
details.

Since this is a breaking change, the magic number for
the image header is now different, along with other
incompatible image format changes. Tooling and build
systems which rely on imgtool.py should not need any
changes beyond a re-build; other build flows may require
additional changes.


##### Zephyr release test improvements:
- The MCUBoot build system was made more configurable;
more of the behavior of the bootloader can be configured
by passing arguments to make. Compile-time configurable
behavior includes the signature type, whether the image
at slot 0 is validated at every boot, and whether the
"overwrite only" upgrade method is used instead of the
default swapping method.

The release test suite has been updated to take
advantage of this; the test scripts now invoke make with
different configurations, rather than applying different
patches to the build system to generate builds with
different configurations.


##### Tinycrypt version 0.2.6 imported:
- MCUBoot has imported the Tinycrypt version 0.2.6 source
code into the tree, and uses it directly. This is
because Zephyr has moved to version 0.2.7, which
introduces incompatible API changes which other
platforms do not yet support. The Tinycrypt sources use
both 3-clause and 2-clause BSD-style licenses.


##### PKCSv1.5 removal:
- The obsolete PKCSv1.5 signature format option has been
removed.


##### License cleanups:
- A LICENSE file was added, which contains the Apache
license v2.


##### Support for additional boards:
- Zephyr board support was added for Hexiwear K64,
nrf52_blenano2, and the nRF51 and nRF52832 development
kits from Nordic Semiconductors.


##### Design document improvements.:
- The design document has been significantly re-worked,
with various fixes and improvements.


##### Improved Zephyr sample applications.:
- The Zephyr sample applications have been reduced to a
single application, which can be built for multiple
boards.


#### Bugs

##### Build system fixes to remain in boot partition:
- The build system has been fixed so that the MCUBoot
image is checked to fit within the boot partition at
build time.



### Zephyr


#### Features

##### Bluetooth configuration namespace renamed:
- In a breaking API change, upstream has changed the
Bluetooth Kconfig namespace from CONFIG_BLUETOOTH_* to
CONFIG_BT_*. All applications which use Bluetooth, along
with any out of tree patches, will need updates.
Bluetooth Controller Kconfig options were also renamed
from CONFIG_BT_CONTROLLER_* to CONFIG_BT_CTLR_*. A small
set of other Bluetooth fixes and improvements were also
merged.


##### LWM2M protocol support:
- Zephyr support for the Lightweight Machine to Machine
(LWM2M) protocol, provided and maintained by the Linaro
Technologies Division, was merged into the Zephyr
mainline, and has seen significant cleanup and testing
since its initial merge in the 1.9 development
cycle. It includes IPSO Light Control object support.

A fully documented sample application named lwm2m_client
was merged.


##### k_poll() allows multiple threads to poll:
- struct k_poll was updated to allow multiple threads to
use the same poll object.


##### x86 support for kernel/userspace separation:
- Userspace APIs were added to support kernel/user mode
(supported for x86).


##### DFU support for MCUBoot:
- DFU module was added to support building Zephyr with
MCUBoot.


##### DTS for Quark SE C1000:
- The Quark SE C1000 SoC received DTS support.


##### USB serial for x86:
- Serial over USB support was added for X86.


##### sa_family field added to struct sockaddr:
- POSIX compatibility patch caused changes across the
entire network subsystem by renaming the family field in
sockaddr to sa_family.


##### ARC memory protection:
- The ARC architecture added MPU and stack guard support.


##### Crypto library updates:
- TinyCrypt was updated to version 0.2.7, and received
some coverty adjustments.  Due to a security advisory
released on August 28th 2017, mbedTLS was updated to
2.6.0.  An mbedTLS shim layer was added which is
compliant with Zephyr crypto APIs.


##### MQTT conversion to net_app API:
- The MQTT networking library was converted to use the
net_app API. This improves its behavior at the cost of
API breakage.


##### MQTT TLS support:
- TLS support was added to MQTT library.


##### DTLS support for net_app:
- DTLS support added to net_app library.


##### Bluetooth network support for net_app:
- Generic bluetooth network support
(CONFIG_NET_APP_BLUETOOTH_NODE) was added to the net_app
library, and enabled for many samples.


##### Project configuration unification:
- Many board-specific network sample prj.conf files were
unified into single prj.conf files, along with other
clean-ups.


##### Test case conversion to ztest:
- Many test files were converted to use the ztest API.
This makes test case result parsing more uniform.


##### Test case filtering improvements:
- Various improvements to test case filtering for
continuous integration were merged, including better
specification of minimum RAM requirements.


##### TCP receive window management:
- Initial support for TCP receive window management was
merged.


##### STM32 improvements:
- The STM32 pinmux driver was completely re-worked. The
new version will better support Device Tree, though full
DT integration is ongoing work.

Support was added for the TIM3 peripheral.

Support for the STM32F417 and STM32F405 SoCs was merged,
along with fixes and improvements to the STM32 pinmux
drivers.


##### OpenOCD symbol generation:
- Zephyr builds now include OpenOCD symbols.


##### Initial POSIX thread support:
- Support for POSIX thread IPC, partially implementing the
IEEE 1003.1 pthread API, was merged.


##### Bluetooth HCI SPI slave application:
- A Bluetooth HCI SPI handler sample application was merged.
This sample is compatible with the Zephyr HCI SPI
protocol and enables Bluetooth connectivity on 96Boards
Carbon via the nrf51 SoC (96b_carbon_nrf51).


##### Bluetooth support for more boards:
- Bluetooth support for 96Boards Carbon and
disco_l475_iot1 was merged.


##### Updated TI CC22xx support.:
- TI CC3200 SoC and LaunchXL board support removed in
favor of CC3220SF LaunchXL.

TI SimpleLink SDK host driver for CC3220SF was merged,
and is enabled by default on CC3220SF_LaunchXL. This
enables WiFi support via an external coprocessor.


##### Flash partitions for nrf52_blenano2:
- Flash partitions added for nrf52_blenano2, making it
compatible with FOTA via MCUBoot and dual partitions.


##### Flash layout API:
- New flash driver API to query flash layout (supported on
nRF5 and STM32).


##### I2S driver support:
- A new driver API and infrastructure for the I2S (Inter-IC
Sound) protocol was merged.


##### ESP32 drivers:
- Driver support for ESP32-based targets continues to
increase, with the merging of random number generator,
GPIO, serial, watchdog, and pinmux drivers.


##### Improved board support:
- Board support was added for the STM32F429I-DISC1,
olimex_stm32_p405, and STM32F412G-DISCO boards. Board
support for the hexiwear_k64 was extended to support
additional existing sample applications. Support for
12C_2 was added for 96b_carbon.


##### New PWM driver for NXP SoCs:
- Support for a new mcux-based driver was merged for
various NXP SoCs and boards.


##### ARM vector table relocation:
- Support for relocating the vector table on the ARM
architecture was merged.


##### ARM stack macros:
- Improved support for architecture-specific stack
management macros was merged for ARM targets.


##### ARC updates:
- Nested interrupt support was added to the ARC
architecture. Various fixes, cleanups, and SoC vendor
library updates were also merged for ARC.


##### net_app gateway and netmask:
- Users of the net app framework can now set IPv4 Netmask
and Gateway via 2 new Kconfig settings:
CONFIG_NET_APP_MY_IPV4_NETMASK and
CONFIG_NET_APP_MY_IPV4_GW.


##### Simplified documentation hierarchy:
- Zephyr documentation saw a series of patches moving
content around into more simplified groupings.


#### Bugs

##### Networking fixes:
- The network application (net-app) framework received
some bugfixes.  Many of them involve trying to build
with various combinations of CONFIG options and
IPv4/IPv6. A patch preventing unaligned access was
added, as well as re-initialization of connection
structures after a disconnect.  A regression bugfix for
using POST method with the HTTP client was also merged.



##### JSON fixes:
- JSON library received some bug fixes and compiler
warning cleanup.



##### k_timer_start() fix for zero parameter:
- k_timer_start() was fixed to accept a zero
parameter. This expires the timer as soon as possible.



##### Boot banner fix:
- The boot banner now prints before any other messages at
the application log level.



##### Bluetooth conformance fixes:
- Bluetooth controller and mesh changes to related to
conformance and qualification testing were merged.



##### Bluetooth RTC fix:
- The Bluetooth subsystem saw a bluetooth regression fix
(cb90fbe Bluetooth: controller: Fix controller assert at
clock rollover) which reverts the clock rollover
calculation back to its original form.  This seems to
have fixed the crashes observed in the Bluetooth
controller on nRFxx.



##### Bluetooth buffer fixes:
- The default setting and range of BT_RX_STACK_SIZE was
fixed when checking if BT_HCI_RAW was selected.



##### TI SimpleLink removal:
- The TI SimpleLink SDK was removed due to restrictive
host driver source licensing.



##### Bluetooth Mesh fixes:
- Several fixes were merged improving Bluetooth mesh support.



##### 802.15.4 fixes:
- Various fixes were merged for the IEEE 802.15.4 radio layer.



##### RPL fixes:
- Various fixes were merged for the RPL routing protocol.



##### TCP fixes:
- Various fixes were merged for the TCP protocol.



##### HTTP fixes:
- Various fixes were merged for the HTTP protocol.



##### Work queue fixes:
- Support to remove elements from k_queue added via
k_queue_remove. The Work queue implementation migrated from
k_fifo to k_queue as it now offers a more flexible API.



##### STM32 DTS and driver fixes:
- Bug fixes for DTS and I2C on STM32 targets were merged.
Several bug fixes to the STM32 SPI drivers were merged.



##### ESP32 clock fix:
- A clock-related fix to the ESP32 architecture was merged.



##### Memory management and protection fixes:
- Various MPU related fixes were merged for the ARM
architecture, and a bug fix was merged on the X86
architecture related to MMU management.



##### XTensa fixes:
- A bug fix related to using the newlib C library on the
XTensa architecture was merged. The interrupt management
on that architecture was converted to use the Zephyr
script gen_isr_table for generating interrupt tables.



### Zephyr FOTA Samples


#### Features

##### dm-hawkbit-mqtt:
- The MQTT And hawkBit device management application is
synchronized and tested with the updated Zephyr tree.


##### LWM2M application:
- A new application, dm-lwm2m, is provided which
demonstrates firmware update and device communication
via LWM2M.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

This is the first Linux microPlatform release created by Foundries.io.

## Highlights

- Converted to Foundries.io Meta Layer

## Components
