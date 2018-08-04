+++
title = "microPlatform update 0.2"
date = "2017-11-16"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.2

"This is the final release which uses the Linux kernel Kbuild
build system. The next release will have a CMake-based build
system. **All out of tree applications will need updates** to
their build systems to move to CMake. Refer to the Zephyr
Application Development Primer for details:

http://docs.zephyrproject.org/application/application.html"


## Linux microPlatform changes for 0.2

Linux microPlatform build system improvements to easy the platform build process
in docker containers.

Layer updates for meta-osf, meta-freescale-3rdparty meta-qcom, meta-raspberrypi
and openembedded-core and meta-linaro.

<!--more-->
# Zephyr microPlatform

## Summary

"This is the final release which uses the Linux kernel Kbuild
build system. The next release will have a CMake-based build
system. **All out of tree applications will need updates** to
their build systems to move to CMake. Refer to the Zephyr
Application Development Primer for details:

http://docs.zephyrproject.org/application/application.html"

## Highlights

- Final Zephyr commit before the build system moves to CMake
- MCUBoot memory and flash space optimizations

## Components


### MCUBoot


#### Features

##### Simulator tests rewritten in Cargo test format: 
- "The simulator tests have been rewritten to use Rust's
native testing framework. Users can run the tests by
running \"cargo test\" from the sim/ directory."


##### mbedTLS memory allocator: 
- The Zephyr port now uses a memory allocator from
mbedTLS, which provides some memory and flash savings
over the native Zephyr allocator.


##### New overwrite-only mode optimization option: 
- The overwrite-only update mode has a new option which
provides a performance optimization at the cost of not
erasing all of the old images. The optimization, when
enabled, only deletes the sectors in slot 0 needed to
copy in the update in slot 1. This is the new default
when overwrite-only is chosen.


#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### Final KBuild-based commit: 
- This is the **final Zephyr patch** which uses Kbuild as
the build system. The next Zephyr tree released will use
CMake. Applications should prepare for a build system
rewrite.


##### Memory domains for x86: 
- Memory domain APIs were implemented and merged for x86
and ARM targets. These allow generic API access to
architecture-specific hardware which can isolate memory
areas to individual threads.


##### Jailhouse support: 
- "Zephyr can now be run as a Jailhouse hypervisor's
\"inmate cell\". This port boots with the processor in
real mode, and handles the transition to 32-bit
protected mode before jumping to Zephyr's start code.
Detailed usage instructions are given in the commit
message for 97a871 (\"x86: Jailhouse port, tested for
UART (# 0, polling) and LOAPIC timer\")."


##### Bluetooth Mesh friend support: 
- Complete Friend support was merged for Bluetooth Mesh,
with corresponding updates to samples/bluetooth/mesh.


##### STM32 NUCLEO-F091RC board support: 
- SoC support for the STM32F091 has been added, along with
board support for NUCLEO-F091RC.


##### Tickless kernel for XTensa: 
- A tickless kernel implementation was merged for XTensa
targets.


##### DTS partition resizes for Nordic DKs: 
- Official nRF52 targets from Nordic (nrf52_pca10040,
nrf52840_pca10056) had their DTS partitions tweaked,
which may affect mcuboot users on those targets.


##### User mode documentation: 
- Documentation was added for the user mode threads kernel
feature.


##### USB CDC improvements: 
- Continuing improvements and breaking changes to USB were
merged, targeting the Communications Device Class. In
particular, the usb_cdc.h header has replaced cdc_acm.h,
as part of a series of changes improving support for CDC
ethernet devices.  The zperf performance testing
application received a netusb confinguration for testing
and using these changes, along with a build regression
fix.


##### Networking improvements: 
- In networking, the TCP implementation received support
for options parsing and storage of sent MSS, among other
improvements.


#### Bugs

##### Bluetooth Mesh fixes: 
- Numerous bug fixes to Bluetooth Mesh were merged
(affecting provisioning, network decryption, credentials
selection, transport layer heartbeat subscription
matching, and more).



##### LWM2M fixes: 
- "A pair of LWM2M fixes were also merged, which fix the
engine's response to the peer when a write fails and
avoid a possible null pointer dereference."



### Zephyr FOTA Samples


#### Features
- Not addressed in this update

#### Bugs

##### dm-lwm2m: Fix for temperature min/max values: 
- A bug fix was merged to the LWM2M demonstration
application which properly maintains the minimum and
maximum observed temperature values managed by the IPSO
temperature object.


# Linux microPlatform

## Summary

Linux microPlatform build system improvements to easy the platform build process
in docker containers.

Layer updates for meta-osf, meta-freescale-3rdparty meta-qcom, meta-raspberrypi
and openembedded-core and meta-linaro.

## Highlights

- Build system improvements to easy the platform build process in docker containers
- Removal of the ACCEPT_EULA variable for firmware-qcom-dragonboard410c
- SD card image now available for DragonBoard-410c

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- Default distro maintainer set to OSF Support.
Clear TCLIBCAPPEND for a single TMPDIR as LMP only supports one
libc at this point.
Default git repository and namespace used by the Linux recipe
changed to use the subscriber repository by default.


#### Bugs
- Not addressed in this update

### Meta Freescale 3rdparty Layer


#### Features

##### Layer Update: 
- U-boot-toradex updated to 2016.11 (toradex bsp 2.7.4).
SPL, wic and device tree machine fixes for apalis-imx6 and
colibri-imx7.
Added device tree for the aster carrier board and migrated
colibri-vf machine configuration to use wic image format.


#### Bugs
- Not addressed in this update

### Meta Linaro Layer


#### Features

##### Layer Update: 
- linux.inc no longer includes linux-dtb.inc, removing a build
warning.
Stress-ng recipe removed as it was merged into meta-oe.


#### Bugs
- Not addressed in this update

### Meta Qualcomm Layer


#### Features

##### Layer Update: 
- Removal of the ACCEPT_EULA variable for firmware-qcom-dragonboard410c.
Added firmware recipe and package for DragonBoard-820c.
Added support for a bootable SD card image for DragonBoard-410c.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi Layer


#### Features

##### Layer Update: 
- Disable asm for raspberrypi0-wifi when building x264.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Tzdata updated to 2017c.
Bind updated to 9.10.6.
OpenSSH updated to 7.6.
Wic now supports part-name argument for naming GPT partitions.
Util-linux updated to 2.31.
libxml2 updated to 2.9.7.
Wget updated to 1.19.2.
Expact updated to 2.2.5.


#### Bugs

##### bind: 
- Multiple issues.

 - [CVE-2017-3142](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3142)
 - [CVE-2017-3143](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3143)
 - [CVE-2017-3141](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3141)
 - [CVE-2017-3140](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3140)

##### wget: 
- Multiple issues.

 - [CVE-2017-13089](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13089)
 - [CVE-2017-13090](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13090)
 - [CVE-2017-6508](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-6508)
