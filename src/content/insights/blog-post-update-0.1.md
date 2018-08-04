+++
title = "microPlatform update 0.1"
date = "2017-11-08"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.1

This release includes a Zephyr tree from the the 1.10 development
cycle. This tree does not yet include the conversion of the build
system to CMake.

It includes an MCUBoot tree based on work done in the master
branch following the v1.0.0 tag, which includes some work making it
easier to port new boards to the bootloader than it was in that
release.

Finally, several sample applications are included, with numerous
improvements from publicly released versions.


## Linux microPlatform changes for 0.1

This release includes a major OpenEmbedded / Yocto update, which is now based
on the latest Rocko (2.4) baseline (which is in the process to be released).

Go was updated to 1.9 and Docker was updated to the CE 17.06 release.

<!--more-->
# Zephyr microPlatform

## Summary

This release includes a Zephyr tree from the the 1.10 development
cycle. This tree does not yet include the conversion of the build
system to CMake.

It includes an MCUBoot tree based on work done in the master
branch following the v1.0.0 tag, which includes some work making it
easier to port new boards to the bootloader than it was in that
release.

Finally, several sample applications are included, with numerous
improvements from publicly released versions.

## Highlights

- Zephyr tree from 1.10 development cycle, before CMake transition
- MCUBoot tree following the 1.0.0 release
- Fixes and other improvements to sample applications

## Components


### MCUBoot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### GPIO interface deprecations: 
- The GPIO_PIN_ENABLE and GPIO_PIN_DISABLE configuration
constants, which overlap with functionality provided by the
pinux driver, were deprecated.


##### New CoAP API: 
- There is a new CoAP API; the existing API has been deprecated.


##### New HTTP API: 
- There is a new HTTP API based on the net-app framework;
the existing API has been deprecated.

Applications using the old API need to ensure
CONFIG_HTTP is enabled, and CONFIG_HTTP_APP is disabled,
to continue using the deprecated API. Such applications
should be updated to use the new API. The HTTP sample
applications were converted to use the new API, and can
be used as a reference.


##### New LED strip API: 
- A public API for strips, or strings, of individually
addressable LEDs was added, along with drivers for two
common chipsets and sample applications. Both RGB and
grayscale LED strip drivers can be implemented within
these APIs.


##### New "userspace" and driver API checking: 
- The Zephyr kernel now supports separate system and user
thread modes. User threads have limited access to kernel
objects, such as device drivers, semaphores, etc.

Many drivers had userspace system call handlers added
(I2C, ADC, PWM, RTC, etc), which enforce the separation
between the core kernel and a userspace thread at the
driver API call. However, existing APIs are unchanged.


##### New random subsystem: 
- Random number generation in Zephyr is undergoing a significant
refactor.  A new random subsystem was added, which provides
implementations for sys_rand32_get() based on hardware sources
of entropy. These sources in the drivers/random directory were
moved to "drivers/entropy". A Xoroshiro128+ PRNG was added to
the random subsystem; it is only recommended for
non-cryptographic purposes.


##### Updated crypto library usage: 
- Minor changes to the usage of the mbedtls and tinycrypt
libraries was merged.


##### New net_buf APIs: 
- Some new net_buf APIs were merged.

- net_buf_id(), which allows converting a buffer into a
  zero-based index. The utility of this API will be
  limited until a future refactor converts all struct
  net_bufs to have a fixed user data size, however.

- net_buf_slist_put() and net_buf_slist_get(), which
  should be used instead of sys_slist_*() equivalents to
  ensure correct handling of buffer fragments when
  net_bufs are placed in singly linked lists.


##### Power management for nRF52: 
- nRF52 series SoCs gained architecture-specific power
management support for transitioning the core into and
out of low power sleep states. This includes a sample
application, samples/boards/nrf52/power_mgr.


##### New sensor support for disco_l475_iot1: 
- Support for sensors on the STM32L4 board
disco_l475_iot1 was merged. This supports the LSM6DSL,
LIS3MDL, LPS22HB, and HTS221 sensors. Support is
disabled by default. Applications can enable sensor
support for this board using their .conf files.


##### USB improvements: 
- Work was merged to the USB subsystem to support CDC ECM
and composite USB devices.


##### Atmel SAM3 serial driver deprecated.: 
- The atmel_sam3 serial driver was deprecated.


##### LWM2M: 
- LwM2M protocol support migrated to the new CoAP API, and
now supports multiple network fragments.  This removes
the requirement for the large buffer sizes and makes the
overall protocol much more flexible.  It also received
various memory usage optimizations.


##### Flash scripts rewritten in Python: 
- The Zephyr flash and debug scripts, originally ported from
the RIOT RTOS, have been rewritten in Python to
eliminate a dependency on a Unix shell, replacing it with a
cross-platform alternative.


##### Miscellaneous STM32 improvements: 
- Other miscellaneous STM32-specific board code and
documentation fixups were merged.


##### Test conversions to ztest: 
- Numerous test cleanups were merged, including continued
conversions to the ztest framework.


##### Documentation updates for new website: 
- The Zephyr website was given a major re-work, and various
documentation links were updated accordingly.


#### Bugs

##### LWM2M fixes: 
- Some bug fixes and simplifications to LWM2M were merged.



##### Bluetooth Mesh: 
- Many fixes were merged for Bluetooth Mesh support.

Network Message Cache behavior was also improved.



##### Other Bluetooth fixes: 
- Some other fixes to the core BT controller and LE scan
handling code were also merged.



##### PAE fix for x86: 
- The x86 architecture MMU generation had a fix to PAE
page directory permissions.



##### Infinite loop in I2C for STM32F0, F3, F7: 
- A fix for a bug in an STM32 I2C driver was merged which
prevents the driver from entering into an infinite loop;
this affects F0, F3, and F7 based devices.



### Zephyr FOTA Samples


#### Features

##### Memory optimizations: 
- Uses of sXprintf() were replaced with sXprintk()
alternatives, saving about 3.5 KB of flash.


##### dm-hawkbit-mqtt: HTTP configuration update: 
- The application was updated to disable the new HTTP
library, preserving use of the other, now-deprecated
library. Applications can use this as a reference while
transitioning to the new APIs.


##### dm-hawkbit-mqtt: support for BLE Nano 2 board: 
- JSON buffer sizes were tweaked to support longer strings
generated at runtime on the BLE Nano 2.


##### dm-lwm2m: add firmware storage buffer: 
- The application was updated to explicitly allocate a
buffer for storing firmware during the download
process. This is necessary since the upstream LWM2M
subsystem no longer allocates its own.


##### dm-lwm2m: configuration sync with upstream: 
- The large net buffer size setting was removed.  LwM2M no
longer needs the large contiguous buffer.

Extra buffer allocations were removed by default.  These
will eventually be needed for keeping a copy of packets
to be sent via 6lowpan.  But currently, these are not
used.


#### Bugs

##### dm-hawkbit-mqtt: improved resilience to lossy transports: 
- BLE devices with minor antenna issues can have data
transmission delays.  More time is now allocated before
starting the TCP retry process.

This fixes an issue where net buffers would be exhausted
due to the previous 200ms TCP retry logic.



##### dm-hawkbit-mqtt: logging fixes: 
- Compilation warnings due to mis-used logging macros were fixed.



##### dm-lwm2m: fix for HTTP firmware updates: 
- When downloading firmware via the cf_proxy (translating
from HTTP -> CoAP) a CoAP ETAG option is used to specify
the version of the binary file.

The length of that ETAG can be quite large (including a
UUID), which is greater than what the buffer can hold by
default. This issue was resolved, fixing errors raised
when using HTTP download in resource 5/0/1 with
CONFIG_LWM2M_FIRMWARE_UPDATE_PULL_COAP_PROXY_SUPPORT=y.


# Linux microPlatform

## Summary

This release includes a major OpenEmbedded / Yocto update, which is now based
on the latest Rocko (2.4) baseline (which is in the process to be released).

Go was updated to 1.9 and Docker was updated to the CE 17.06 release.

## Highlights

- Layers updated to the latest OpenEmbedded / Yocto Rocko (2.4) baseline
- Bitbake updated to the latest 1.37 branch
- LMP distribution available as part of Meta-OSF
- Go updated to 1.9
- Docker CE updated to 17.06
- Images are now compressed (xz) by default.
- U-Boot support for RaspberryPi 3

## Components


### Meta-96boards Layer


#### Features

##### Layer Update: 
- Grub is now compatible with GCC 7 (default version in Rocko).
Grub's default boot configuration now includes the distro name.
HiKey serial console now can be configured externally.
96boards-tools was updated to 0.11, including improvements to the
rootfs resize script.


#### Bugs
- Not addressed in this update

### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Ipk package creation can now be parallelised.
Busybox updated to 1.27.2.
Cmake updated to 3.9.3.
Glibc updated to 2.25.90.
BlueZ updated to 5.47.
systemd updated to 234.
GCC updated to 7.2.0.
Binutils updated to 2.29.
CA-Certificates updated to 20170717.
U-Boot updated to 2017.09.
Go updated to 1.9, including major changes in the bbclass.
Linux-firmware updated to the latest git revision.
Improved support for WIC, with several minor bugfixes.


#### Bugs

##### libxml2: 
- Multiple issues.

 - [CVE-2017-0663](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0663)
 - [CVE-2017-5969](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-5969)
 - [CVE-2017-8872](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8872)
 - [CVE-2017-9047](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9047)
 - [CVE-2017-9048](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9048)
 - [CVE-2017-9049](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9049)
 - [CVE-2017-9050](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-9050)

##### wget: 
- CRLF injection vulnerability in the url_parse function.

 - [CVE-2017-6508](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-6508)

##### curl: 
- Multiple issues.

 - [CVE-2017-1000099](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000099)
 - [CVE-2017-1000100](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000100)
 - [CVE-2017-1000101](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000101)
 - [CVE-2017-1000254](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000254)

##### ncurses: 
- Multiple issues.

 - [CVE-2017-13728](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13728)
 - [CVE-2017-13729](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13729)
 - [CVE-2017-13730](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13730)
 - [CVE-2017-13731](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13731)
 - [CVE-2017-13732](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13732)
 - [CVE-2017-13734](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13734)

##### libgcrypt: 
- Libgcrypt before 1.8.1 does not properly consider Curve25519
side-channel attacks.

 - [CVE-2017-0379](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0379)

##### wpa_supplicant: 
- Several issues related to the Key Reinstallation Attacks (KRACK).

 - [CVE-2017-13077](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13077)
 - [CVE-2017-13078](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13078)
 - [CVE-2017-13079](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13079)
 - [CVE-2017-13080](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13080)
 - [CVE-2017-13081](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13081)
 - [CVE-2017-13082](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13082)
 - [CVE-2017-13086](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13086)
 - [CVE-2017-13087](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13087)
 - [CVE-2017-13088](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13088)

##### shadow: 
- In shadow before 4.5, the newusers tool could be made to
manipulate internal data structures in ways unintended by the
authors.

 - [CVE-2017-12424](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12424)

##### sqlite3: 
- The dump_callback function in SQLite 3.20.0 allows remote
attackers to cause a denial of service (EXC_BAD_ACCESS
and application crash) via a crafted file.

 - [CVE-2017-13685](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13685)

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- Gvfs updated to 1.32.1.
Parted updated to 0.28.1.
VIM updated to 8.0.0983.
Rsyslog updated to 8.29.
Dnsmasq upadted to 2.78.
Tcpdump updated to 4.9.2.


#### Bugs

##### tcpdump: 
- Multiple issues.

 - [CVE-2017-11543](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11543)
 - [CVE-2017-13011](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13011)
 - [CVE-2017-12989](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12989)
 - [CVE-2017-12990](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12990)
 - [CVE-2017-12995](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12995)
 - [CVE-2017-12997](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12997)
 - [CVE-2017-11541](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11541)
 - [CVE-2017-11542](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11542)
 - [CVE-2017-12893](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12893)
 - [CVE-2017-12894](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12894)
 - [CVE-2017-12895](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12895)
 - [CVE-2017-12896](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12896)
 - [CVE-2017-12897](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12897)
 - [CVE-2017-12898](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12898)
 - [CVE-2017-12899](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12899)
 - [CVE-2017-12900](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12900)
 - [CVE-2017-12901](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12901)
 - [CVE-2017-12902](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12902)
 - [CVE-2017-12985](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12985)
 - [CVE-2017-12986](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12986)
 - [CVE-2017-12987](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12987)
 - [CVE-2017-12988](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12988)
 - [CVE-2017-12991](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12991)
 - [CVE-2017-12992](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12992)
 - [CVE-2017-12993](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12993)
 - [CVE-2017-11542](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11542)
 - [CVE-2017-11541](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11541)
 - [CVE-2017-12994](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12994)
 - [CVE-2017-12996](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12996)
 - [CVE-2017-12998](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12998)
 - [CVE-2017-12999](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-12999)
 - [CVE-2017-13000](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13000)
 - [CVE-2017-13001](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13001)
 - [CVE-2017-13002](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13002)
 - [CVE-2017-13003](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13003)
 - [CVE-2017-13004](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13004)
 - [CVE-2017-13005](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13005)
 - [CVE-2017-13006](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13006)
 - [CVE-2017-13007](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13007)
 - [CVE-2017-13008](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13008)
 - [CVE-2017-13009](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13009)
 - [CVE-2017-13010](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13010)
 - [CVE-2017-13012](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13012)
 - [CVE-2017-13013](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13013)
 - [CVE-2017-13014](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13014)
 - [CVE-2017-13015](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13015)
 - [CVE-2017-11543](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-11543)
 - [CVE-2017-13016](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13016)
 - [CVE-2017-13017](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13017)
 - [CVE-2017-13018](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13018)
 - [CVE-2017-13019](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13019)
 - [CVE-2017-13020](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13020)
 - [CVE-2017-13021](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13021)
 - [CVE-2017-13022](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13022)
 - [CVE-2017-13023](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13023)
 - [CVE-2017-13024](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13024)
 - [CVE-2017-13025](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13025)
 - [CVE-2017-13026](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13026)
 - [CVE-2017-13027](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13027)
 - [CVE-2017-13028](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13028)
 - [CVE-2017-13029](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13029)
 - [CVE-2017-13030](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13030)
 - [CVE-2017-13031](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13031)
 - [CVE-2017-13032](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13032)
 - [CVE-2017-13033](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13033)
 - [CVE-2017-13034](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13034)
 - [CVE-2017-13035](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13035)
 - [CVE-2017-13036](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13036)
 - [CVE-2017-13037](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13037)
 - [CVE-2017-13038](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13038)
 - [CVE-2017-13039](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13039)
 - [CVE-2017-13040](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13040)
 - [CVE-2017-13041](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13041)
 - [CVE-2017-13042](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13042)
 - [CVE-2017-13043](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13043)
 - [CVE-2017-13044](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13044)
 - [CVE-2017-13045](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13045)
 - [CVE-2017-13046](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13046)
 - [CVE-2017-13047](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13047)
 - [CVE-2017-13048](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13048)
 - [CVE-2017-13049](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13049)
 - [CVE-2017-13050](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13050)
 - [CVE-2017-13051](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13051)
 - [CVE-2017-13052](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13052)
 - [CVE-2017-13053](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13053)
 - [CVE-2017-13054](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13054)
 - [CVE-2017-13055](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13055)
 - [CVE-2017-13687](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13687)
 - [CVE-2017-13688](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13688)
 - [CVE-2017-13689](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13689)
 - [CVE-2017-13690](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13690)
 - [CVE-2017-13725](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13725)

##### hostapd: 
- Several issues related to the Key Reinstallation Attacks (KRACK).

 - [CVE-2017-13077](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13077)
 - [CVE-2017-13078](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13078)
 - [CVE-2017-13079](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13079)
 - [CVE-2017-13080](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13080)
 - [CVE-2017-13081](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13081)
 - [CVE-2017-13082](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13082)
 - [CVE-2017-13086](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13086)
 - [CVE-2017-13087](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13087)
 - [CVE-2017-13088](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-13088)

##### bluez5: 
- SDP server in BlueZ 5.46 and earlier are vulnerable to an
information disclosure vulnerability which allows remote
attackers to obtain sensitive information from the bluetoothd
process memory

 - [CVE-2017-1000250](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000250)

##### busybox: 
- Prevent unsafe links extracting.

 - [CVE-2011-5325](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-5325)

### Meta Linaro Layer


#### Features

##### Layer Update: 
- GCC Linaro updated to 7.1.1-2017.08.
OP-TEE updated to 2.6.0.


#### Bugs
- Not addressed in this update

### Meta Virtualization Layer


#### Features

##### Layer Update: 
- runc-docker updated to to 1.0-rc3+.
Docker CE updated to 17.06.
Containerd updated to latest 0.2.x.
Added support for Python Docker 1.16.1.
Runc-opencontainers updated to v1.0.0-rc4.


#### Bugs
- Not addressed in this update

### Meta OSF Layer


#### Features

##### Layer Update: 
- Added new LMP distro configuration.
Match distro version with Yocto.
Gateway image renamed from rpb-osf-gateway-image to lmp-gateway-image.
The LMP distribution now using GCC Linaro 7.x.
Added WKS file for cl-som-imx7.


#### Bugs

##### docker: 
- Go-fsinotify fixes to enable docker logs -f on arm64.



##### 96boards-tools: 
- Force resize-helper to wait for udevadm settle so it can always
have a successful run.



### Meta Qualcomm Layer


#### Features

##### Layer Update: 
- Added firmware for ath10k (dragonboard820c).
Kernel format changed from Image to Image.gz.


#### Bugs
- Not addressed in this update

### Meta Freescale Layer


#### Features

##### Layer Update: 
- U-Boot-Fslc updated to 2017.09.
U-Boot-Fslc-fw-utils updated to 2017.09.
UEFI updated to a812f17.
Added machine configuration for imx25pdk, imx6sllevk and imx7ulpevk.
wic.gz image format is now used for all i.MX machines by default.
Added i.MX SDMA firmwares.
imx-vpu updated to v5.4.37.
Change git.freescale repository URLs (using code aurora mirror instead).


#### Bugs
- Not addressed in this update

### Meta Freescale 3rdparty Layer


#### Features

##### Layer Update: 
- Added machine configuration for imx7d-pico.
Added support for Wandboard D1.
Added wic image support for several supported machines.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi Layer


#### Features

##### Layer Update: 
- RaspberryPi firmware updated to tag 1.20170811.
Updated linux-firmware-brcmfmac43430 to 7.45.41.46.
Improved support for raspberrypi3-64.


#### Bugs
- Not addressed in this update

### Meta Yocto Layer


#### Features

##### Layer Update: 
- Added kernel device tree config for Beagle Bone Green.


#### Bugs
- Not addressed in this update
