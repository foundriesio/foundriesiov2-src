+++
title = "microPlatform update 0.7"
date = "2018-01-25"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.7

The most significant change in this update follows the Linux
microPlatform switch to a Linux v4.14-based tree. This impacts
compatibility with any gateways relying on the old Bluetooth
behavior, and also will cause changes to the MAC addresses reported
by the Zephyr microPlatform sample applications. Users of the
bt-joiner container whitelist feature in the Linux microPlatform
will need to update their whitelists. Specifically, the leading
D6:E7 in the MAC addresses must be changed to D4:E7.


## Linux microPlatform changes for 0.7

This kernel update includes x86 support for kernel page-table isolation
(KPTI), which mitigates the recent meltdown security vulnerability.

<!--more-->
# Zephyr microPlatform

## Summary

The most significant change in this update follows the Linux
microPlatform switch to a Linux v4.14-based tree. This impacts
compatibility with any gateways relying on the old Bluetooth
behavior, and also will cause changes to the MAC addresses reported
by the Zephyr microPlatform sample applications. Users of the
bt-joiner container whitelist feature in the Linux microPlatform
will need to update their whitelists. Specifically, the leading
D6:E7 in the MAC addresses must be changed to D4:E7.

## Highlights

- Bluetooth behaviors impacting MAC addresses are changed following Linux microPlatform update

## Components


### MCUBoot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features
- Not addressed in this update

#### Bugs

##### LWM2M packet fix: 
- The LWM2M stack includes a fix which prevents a packet
which may need to be retransmitted from being freed
until after this retransmission has completed, if necessary.



### Zephyr FOTA Samples for Hawkbit


#### Features

##### CONFIG_NET_L2_BT_ZEP1656 disabled: 
- This obscure option was used to preserve compatibility
contrary to the Bluetooth specification with
implementation characteristics in the Linux kernel. Now
that the upstream Linux microPlatform was updated to
v4.14, which has fixes for these characteristics, the
option can be disabled.


##### dm-hawkbit-mqtt cleanups and optimizations: 
- Various confusing implementation details in this
application have been fixed and otherwise cleaned
up. The resulting application now requires less memory.


#### Bugs

##### Packet pool workaround for MQTT: 
- The dm-hawkbit-mqttt sample now uses an extra packet
pool when the underlying link layer is Bluetooth. This
keeps the network stack working in the face of IPv6
packet header compression.


# Linux microPlatform

## Summary

This kernel update includes x86 support for kernel page-table isolation
(KPTI), which mitigates the recent meltdown security vulnerability.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.13
- U-Boot updated to the 2017.11 release.
- Raspberry Pi firmware updated to the 20171029 snapshot.
- Initial support for Raspberry Pi 3 64-bit.

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.14.13.
QCA6174 firmware updated to WLAN.RM.4.4.1-00079-QCARMSWPZ-1.
Initial support for Raspberry Pi 3 64-bit.


##### Build Environment Speedup: 
- The build environment has been updated to use a mirror of the
sstate cache which drastically improves the time it takes to
build the first time.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update: 
- Intel microcode updated to 20180108.


#### Bugs
- Not addressed in this update

### Meta Linaro


#### Features

##### Layer Update: 
- OPTEE OS recipe updated to simplify the deply logic.
GCC Linaro 7.1 updated to include ILP32 patches for correct
triplet.
Binutils updated to include patches for correct gnu_ilp32
triplet.


#### Bugs
- Not addressed in this update

### Meta Qualcomm


#### Features

##### Layer Update: 
- wic.bmap image type added for Dragonboard 410c.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Glibc updated to the latest on 2.26 release.
Binutils updated to 2.29.1.
Python Setuptools updated to 38.2.5.
Nss updated to 3.34.1.
Avahi updated to 0.7.
Dbus updated to 1.12.2.
Coreutils updated to 8.28.
libunistring updated to 0.9.8.
Mc updated to 4.8.20.
Psmisc updated to 23.0.
Gobject introspection updated to 1.54.1.
Pciutils updated to 3.5.6.
Alsa-utils, alsa-plugins and alsa-lib updated to 1.1.5.
Gnutls updated to 3.6.1.
Openssl10 updated to 1.0.2m.
Icu updated to 60.1.
libpciaccess updated to 0.14.
Dtc updated to 1.4.5.
Glib-2.0 updated to 2.54.2.
U-Boot updated to 2017.11.
Ethtool updated to 4.13.
Strace updated to 4.19.
Less updated to 527.
Logrotate updated to 3.13.0.
Git updated to 2.15.0.
File updated to 5.32.
e2fsprogs updated to 1.43.7.
Iproute2 updated to 4.13.
Gawk updated to 4.2.0.
Sudo updated to 1.8.21p2.
SQlite3 updated to 3.21.0.
Quota updated to 4.04.
Linux-firmware updated to the bf04291 git revision.
CMake updated to 3.9.5.
libgudev updated to 232.
Shared-mime-info updated to 1.9.
Iso-codes updated to 3.76.
Boost updated to 1.65.1.
libsolv updated to 0.6.29.
Vala updated to 0.38.2.
Qemu updated to 2.10.1.


#### Bugs

##### icu: 
- Fix double free in i18n/zonemeta.cpp.

 - [CVE-2017-14952](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14952)

##### openssl10: 
- Multiple issues.

 - [CVE-2017-3736](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3736)
 - [CVE-2017-3735](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-3735)

##### busybox: 
- Vulnerability in the tab-complete logic.

 - [CVE-2017-16544](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-16544)

##### binutils: 
- Multiple issues.

 - [CVE-2017-15939](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15939)
 - [CVE-2017-15938](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15938)
 - [CVE-2017-15225](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15225)
 - [CVE-2017-15025](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15025)
 - [CVE-2017-15024](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15024)
 - [CVE-2017-15023](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15023)
 - [CVE-2017-15022](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15022)
 - [CVE-2017-15021](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15021)
 - [CVE-2017-15020](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-15020)
 - [CVE-2017-14974](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14974)
 - [CVE-2017-14940](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14940)
 - [CVE-2017-14939](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14939)
 - [CVE-2017-14938](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14938)
 - [CVE-2017-14934](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14934)
 - [CVE-2017-14933](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14933)
 - [CVE-2017-14932](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14932)
 - [CVE-2017-14930](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14930)
 - [CVE-2017-14745](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14745)
 - [CVE-2017-14729](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14729)
 - [CVE-2017-14529](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14529)
 - [CVE-2017-14333](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14333)
 - [CVE-2017-14130](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14130)
 - [CVE-2017-14129](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14129)
 - [CVE-2017-14128](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14128)
 - [CVE-2017-13757](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13757)
 - [CVE-2017-13716](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13716)
 - [CVE-2017-13710](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13710)
 - [CVE-2017-12967](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12967)
 - [CVE-2017-12799](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12799)
 - [CVE-2017-12459](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12459)
 - [CVE-2017-12458](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12458)
 - [CVE-2017-12457](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12457)
 - [CVE-2017-12456](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12456)
 - [CVE-2017-12455](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12455)
 - [CVE-2017-12454](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12454)
 - [CVE-2017-12453](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12453)
 - [CVE-2017-12452](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12452)
 - [CVE-2017-12451](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12451)
 - [CVE-2017-12450](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12450)
 - [CVE-2017-12449](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12449)
 - [CVE-2017-12448](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12448)

### Meta Virtualization


#### Features

##### Layer Update: 
- Switch remaining pypi recipes to use the pypi class.


#### Bugs
- Not addressed in this update

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- Python-pyopenssl updated to 17.5.0.
Python-cryptography updated to 2.1.4.
Python-asn1crypto updated to 0.24.0.
Python3-certifi updated to 2017.11.5.
Python-pytest updated to 3.2.3.
Python-pyasn1 updated to 0.3.7.
Htop updated to v2.0.2.


#### Bugs

##### vim: 
- Information leak when creating swp files.

 - [CVE-2017-17087](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17087)

### Meta Raspberrypi Layer


#### Features

##### Layer Update: 
- Config RPI_EXTRA_CONFIG added to rpi-config.
Default KERNEL_IMAGETYPE changed to zImage.
Default KERNEL_IMAGETYPE for raspberrypi3-64 changed to Image.
Firmware updated to 20171029.
U-Boot support for Raspberry Pi Zero W.


#### Bugs
- Not addressed in this update

### Meta Freescale Layer


#### Features

##### Layer Update: 
- U-boot-fslc updated to 2017.11-based fork.


#### Bugs
- Not addressed in this update
