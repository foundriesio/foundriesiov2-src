+++
title = "microPlatform update 0.13"
date = "2018-04-11"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.13

Zephyr tree with new networking features, driver updates, and bug
fixes, among other improvements.

A new zmp tool build option, --overlay-config, makes it easier to
mix-in configuration fragments when building.

Experimental support for the Wistron WCN14A2A LTE-M Modem is
provided in Zephyr microPlatform specific patches provided by Open
Source Foundries.


## Linux microPlatform changes for 0.13

OSF Unified Linux Kernel updated to the 4.14.26 stable release.
Support for OTA software updates is now enabled by default in the Linux
microPlatform, supporting OSTree with TUF and compatible with the ATS
Garage and ATS OTA Community Edition services.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr tree with new networking features, driver updates, and bug
fixes, among other improvements.

A new zmp tool build option, --overlay-config, makes it easier to
mix-in configuration fragments when building.

Experimental support for the Wistron WCN14A2A LTE-M Modem is
provided in Zephyr microPlatform specific patches provided by Open
Source Foundries.

## Highlights

- Zephyr tree from the v1.12 merge window
- A small set of MCUboot changes
- OSF samples with updates for Zephyr API changes and a new zmp feature
- OSF initial support for LTE-M

## Components


### MCUboot


#### Features

##### Logging on MyNewt:
- The MyNewt port supports logging.


##### Switch to base64 library for Zephyr port:
- The Zephyr serial boot target now uses the base64
library provided by the RTOS instead of linking in
mbedTLS just for this feature.


##### Sample application improvement:
- The sample application now uses BOOTLOADER_MCUBOOT
instead of configuring MCUboot-related options by
hand.


#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### arduino_101_ble removal:
- The duplicated arduino_101_ble board was removed.
Users should use the curie_ble board name instead.


##### Non-volatile configuration system:
- The Apache MyNewt non-volatile configuration system
was ported to Zephyr. The purpose of this subsystem is
to allow storage and retrieval of persistent values to
flash or other storage media. Storage access is either
via a file system or the lower-resource but less
featureful Flash Circular Buffer (FCB) framework,
which was also adapted from MyNewt.


##### Network interface re-work:
- The net_if structure, which represents a network
interface, was radically altered to move almost all of
its fields in preparation for VLAN support. Much of
the information is still available via the net_if
structure with additional indirection; for example,
the \"->ipv4\" structure is now in
\"->config.ip.ipv4\". Users accessing fields through
the convenience functions in net_if.h may not need
code changes, but code which accessed fields directly
will need updates.


##### Config knobs for allocating IP addresses:
- This initial work was followed up by static
declaration of the number of IP addresses desired on
the device, via new CONFIG_NET_IF_MAX_IPV4_COUNT and
CONFIG_NET_IF_MAX_IPV6_COUNT knobs and APIs for
allocating structures like net_if_config_ipv4_get().
This saves memory when the user specifies the number
and type of IP addresses to suit their application.


##### Options and priority for network contexts:
- Network contexts (Zephyr's internal, socket-like
structure) now support setting and getting options.
The initial supported option is a priority value,
which allows classifying traffic flows by priority.
The new APIs are available as net_context_set_option()
and net_context_get_option(), with NET_OPT_PRIORITY
the only value.


##### Network flow traffic class support:
- This is meant to be combined with traffic class
support controlled by a new CONFIG_NET_TC_COUNT
option, which allocates work queues meant for handling
flows within a certain traffic class. Independent
support for transmit and receive traffic classes is
supported.


##### Networking refactoring:
- Numerous other under-the-hood changes and refactoring
commits were merged affecting various networking
areas.


##### Message queues for POSIX:
- The POSIX target now has a message queue compatibility
API.


##### Nordic HAL and SVD updates:
- The Nordic HAL was updated to version 1.0.0, and SVD
(system view description) files were merged for nRF5
SoCs. These files provide a structured representation,
in XML format, for all of the peripherals, registers,
and register fields available on an SoC. They are
commonly used by embedded IDE debuggers and other
libraries which interact with registers on a running
target, etc.


##### Documentation improvements:
- Various documentation improvements were made,
affecting Bluetooth, web sockets, and the display of
Kconfig symbols.


##### New drivers:
- New driver support includes GPIO P1 port on nRF52840,
sample support for USB HID composite configurations,
SPI master suport for lsm6dsl
accelerometer/gyroscopes, and improved temperature
sensor reporting.


##### New samples:
- New sample features include custom board definitions,
networking traffic classes, USB HID mouse support, and
CoAP PUT and POST methods.


##### Foundries.io initial support for LTE-M:
- A number of Foundries.io-specific patches
were merged to enable the Wistron WCN14A2A LTE-M
Modem. These are being targeted for upstream merge,
but have been included here for subscriber access in
the meantime.


#### Bugs

##### User-mode security fix for ARM:
- User mode code can no longer access PPB/IO regions on
ARM targets with MPUs.



##### Bluetooth fixes:
- A Bluetooth fix for an assert in use cases when
whitelists were used was merged, among other fixes and
simplifications.



##### nRF DK board switch fixes:
- nRF DK boards now correctly have pull-up modes
configured on GPIOs connected to switches.



##### USB fixes:
- USB bugs causing random address access and unaligned
access faults in netusb and various CDC ACM issues were
fixed.



##### lis3dh accelerometer fix:
- A bug affecting I2C burst read on the lis3dh
accelerometer was fixed.



##### Stack pointer randomization fix:
- An arithmetic underflow when stack pointer
randomization is enabled was fixed.



##### Networking fixes:
- Various fixes to the network management layer, as well
as protocols such as DNS, TCP, and UDP, were merged.



### hawkBit and MQTT sample application


#### Features

##### DTLS specific settings in a .conf overlay:
- The DTLS-specific configuration file, prj_dtls.conf,
contained duplicated configuration with prj.conf, the
non-DTLS configuration. This duplication was
eliminated and the resulting fragment has been renamed
to overlay-dtls.conf. The sample can now be built with
DTLS support using zmp with \"./zmp build
--overlay-config overlay-dtls.conf
zephyr-fota-samples/dm-lwm2m\".


##### Temperature sensor changes:
- The temperature driver usage was updated to follow
upstream Zephyr API deprecation of the single
temperature sensor channel in favor of separate
ambient and die temperature sensor channels.

This also resulted in a JSON schema change for the
data reported via MQTT.


##### Network interface changes:
- Some network interface management code was updated to
keep up with upstream API changes.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### Temperature sensor changes:
- The temperature driver usage was updated to follow
upstream Zephyr API deprecation of the single
temperature sensor channel in favor of separate
ambient and die temperature sensor channels.

The temperature sensing LWM2M interface was not
affected.


##### Network interface changes:
- Some network interface management code was updated to
keep up with upstream API changes.


##### Initial LTE-M support:
- Initial support for the Wistron WCN14A2A LTE-M Modem
was merged. This can be used with the frdm_k64f board.

See the commit log in f8a19f23 ("dm-lwm2m: add LTE-M
Modem WCN14A2A .conf fragment") for usage
instructions.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

OSF Unified Linux Kernel updated to the 4.14.26 stable release.
Support for OTA software updates is now enabled by default in the Linux
microPlatform, supporting OSTree with TUF and compatible with the ATS
Garage and ATS OTA Community Edition services.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.26.
- New layer Meta Updater added to LMP (provides SOTA support).
- U-Boot support for Dragonboard 410c and 820c.
- VMDK and VDI images are now available for the intel-corei7-64 target.
- Support for OTA software updates using OSTree and TUF.
- OTA compatibility with ATS Garage and ATS OTA Community Edition.

## Components


### Meta OSF Layer


#### Features

##### Layer Update:
- OSF Unified Linux Kernel updated to 4.14.26.
New u-boot-script-toradex recipe added.
U-Boot-Compulab updated to the 2017.07-cl-som-imx7-1.1 release.
New u-boot-ostree-src recipe added.
Python3-docker updated to 2.7.0.
Python3-docker-compose updated to 1.19.0.
Docker-compose is now installed by default in lmp-gateway-image.
New lshw recipe added based on latest upstream git snapshot.


##### U-Boot support for DB410c and DB820c targets:
- Default LMP image now ships with u-boot support for the DB410c
and DB820c targets (requirement for OTA+ support).


##### OSTree support:
- Root filesystem is now OSTree-based. Please check
https://ostree.readthedocs.io for the upstream OSTree documentation.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update:
- Musl updated to the latest upstream master.
Python 3 target and native recipes updated to 3.5.4.
Ncurses updated to 6.0+20171125.
Tar updated to 1.30.
Pigz updated to 2.4.
Wget updated to 1.19.4.
Rsync updated to 3.1.3.
Ninja updated to 1.8.2 (major release update).
RPM updated to 4.14.1.
Openssl updated to 1.0.2n.
Libnl updated to 3.4.0.
Boost updated to 1.66.0.
Iputils updated to 20161105.
Linux-libc-headers updated to v4.15.
Ccache updated to 3.3.5.
Libva updated to 2.0.0.
Strace updated to 4.20.


#### Bugs

##### qemu:
- VNC server implementation in QEMU was found to be vulnerable to
an unbounded memory allocation issue.

 - [CVE-2017-15124](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15124)

### Meta Virtualization


#### Features

##### Layer Update:
- Fixes required by latest OE-Core update.


#### Bugs
- Not addressed in this update

### Meta OpenEmbedded Layer


#### Features

##### Layer Update:
- Python-ndg-httpsclient updated to 0.4.4.
Python 3 depends on python3-misc removed due missing _pydecimal.py.


#### Bugs
- Not addressed in this update

### Meta Yocto


#### Features

##### Layer Update:
- Fixes required by latest OE-Core update.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update:
- U-boot-fw-utils added to u-boot-fslc-fw-utils provides.


#### Bugs
- Not addressed in this update

### Meta Freescale 3rdparty


#### Features

##### Layer Update:
- broadcom-nvram-config changed to use nonarch_base_libdir
instead of /lib.


#### Bugs
- Not addressed in this update
