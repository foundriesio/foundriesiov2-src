+++
title = "microPlatform update 0.8"
date = "2018-02-02"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.8


This is a new MCUBoot release, and an incremental merge of the
Zephyr development branch.


## Linux microPlatform changes for 0.8

OSF Unified Linux Kernel updated to the 4.14.15 stable release.
Default GCC version was changed from the 7.1-Linaro to the latest OpenEmbedded 7.2 release.

<!--more-->
# Zephyr microPlatform

## Summary


This is a new MCUBoot release, and an incremental merge of the
Zephyr development branch.

## Highlights

- MCUboot based on v1.1.0 release, which supports ECDSA signatures and provides tools for password-protected private keys.
- Zephyr changes from the v1.11 development branch integrated.
- No changes to the sample applications.

## Components


### MCUboot


#### Features

##### C99 mode: 
- MCUboot is now built in C99 mode.


##### ECDSA Support: 
- MCUboot now supports ECDSA signatures in both the
Zephyr and Mynewt ports, as well as the simulator.


##### Password-protected keys: 
- The imgtool helper script now supports generating and
managing password-protected private keys. This adds a
new dependency on the Python cryptography module,
replacing the Crypto and pyasn1 dependencies. As a
result of this change, private keys are now stored in
the PKCS#8 format, rather than the previous raw
format.


##### Further PKCS1.5 removals: 
- The imgtool script no longer supports the PKCS1.5
algorithm; this should not be a problem for users,
since MCUboot itself has not supported this algorithm
for some time.


##### MCUBOOT_VALIDATE_SLOT0 is now a feature macro: 
- Including a feature macro, MCUBOOT_VALIDATE_SLOT0, for
controlling whether slot 0 is validated each boot.


##### Mynewt Tinycrypt and mbedTLS: 
- The Mynewt port uses the bundled tinycrypt and mbedtls
libraries.


##### Serial bootloader mode for Zephyr: 
- The Zephyr port now suports a serial bootloader mode,
by which firmware updates can be sent to the
bootloader via a console-friendly UART protocol.


##### Application Kconfig file for Zephyr: 
- The Zephyr port now has a top-level Kconfig
configuration file.


#### Bugs

##### Numerous minor improvements: 
- Various tweaks, improvements, and fixes were merged to
the core image update code.



### Zephyr


#### Features

##### \"Native\" architecture: 
- It is now possible to run Zephyr natively in a POSIX
OS.  This \"Architecture\" uses pthreads to emulate
the context switching.  Also includes a new \"SoC\"
which emulates a CPU running at an infinitely high
clock so that when the CPU wakes it runs to
completion.  A new \"board\" supports timer and IRQ
functionality.  For more information, see

http://docs.zephyrproject.org/boards/posix/native_posix/doc/board.html


##### Build system improvements: 
- Lots of cmake-related bugfixes and additions,
including the concept of Zephyr interface libraries
which lets the build process know which libraries
should be linked with the Zephyr \"app\" library.  See
mbedTLS as an example.


##### SPI for STM32F0: 
- SPI support was added for STM32F0 targets, as well as
several supported boards.


##### Panther board removed: 
- Board support was removed for the unreleased x86
\"Panther\" board, which was similar to quark_se_c1000_devboard.


##### SparkFun nRF52832 breakout: 
- Support for the Sparkfun nRF52832 breakout board was merged.


##### Flash target for nrf51_blenano: 
- The nrf51_blenano board can now be flashed from the
Zephyr build system in the usual way, using the flash
target.


##### GDB for nRF: 
- Support was added for for GDB debugging on ARM
nRF-based hardware.


##### New Atmel SAM0 drivers: 
- "Support for the following Atmel SAM0 drivers was added:
watchdog, GPIO, serial, flash and SPI."


##### TI CC1200 support: 
- Support was added for the sub-GHz TI CC1200 chip


##### Flash Circular Buffer support: 
- Flash Circular Buffer (FCB) was ported from MyNewt as
a native Zephyr module to support a lightweight storage
mechanism (for when NFFS is too resource intensive).


##### STM32L4 HAL updates: 
- STM32L4 Cube updated to version V1.10.0 and STM32F4
Cube was updated to version V1.18.0.


##### Boot banner enabled by default: 
- Zephyr Boot Banner is now enabled by default, along
with the build timestamp. Applications which aim for
reproducible builds will need to disable these if they
have not done so already.


##### LwM2M improvements: 
- The LwM2M subsystem added CoAP/CoAP proxy,
write-attribute, and DTLS (Datagram Transport Layer
Security) support.

For more information, see http://docs.zephyrproject.org/samples/net/lwm2m_client/README.html


#### Bugs

##### Bluetooth fixes: 
- Bluetooth saw more bugfixes and updates to Mesh
support as well as increased use of the new testing
API.



##### Ethernet fixes for K64F: 
- On K64F, ETH_MCUX_0 will only be enabled if
CONFIG_NET_L2_ETHERNET is enabled in the application.



##### IEEE 802.15.4 fixes: 
- Several improvements in the ieee802154 subsystem were merged.



##### USB fixes: 
- Several improvements and additions to the USB
subsystem were merged.



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

OSF Unified Linux Kernel updated to the 4.14.15 stable release.
Default GCC version was changed from the 7.1-Linaro to the latest OpenEmbedded 7.2 release.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.15
- Default GCC changed from 7.1-Linaro to 7.2-OE.
- Raspberry Pi 3 image format changed from rpi-sdimg to WIC (standard OE format).

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.14.15.
Default inputrc config file changed for better serial (readline) support.
Runc-Docker updated to improve the terminal settings.
Default GCC changed from 7.1-Linaro to 7.2-OE.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Coreutils updated to 8.29.
Linux-firmware updated to the 65b1c68c git revision.
libgcrypt updated to 1.8.2.
gnupg updated to 2.2.4.
BlueZ updated to 5.48.
Icu updated to 60.2.
Iproute2 updated to 4.14.1.
CMake updated to 3.10.1.
Qemu updated to 2.11.
Usbutils updated to 009.
Go-dep updated to 0.3.2.


#### Bugs
- Not addressed in this update

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- Python-pytest updated to 3.3.2.
Consolekit dependency removal from NetworkManager.
Bridge-utils updated to v1.6.
Python-cffi updated to 1.11.4.


#### Bugs
- Not addressed in this update

### Meta Virtualization


#### Features

##### Layer Update: 
- Docker-compose now rdepends on python3-terminal.


#### Bugs
- Not addressed in this update
