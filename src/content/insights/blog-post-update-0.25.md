+++
title = "microPlatform update 0.25"
date = "2018-07-27"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.25

MCUboot 1.2.0 contains mostly fixes around the serial
bootloader. The Zephyr tree from the v1.13 development cycle
contains several significant improvements and new features.

## Linux microPlatform changes for 0.25

Linux microPlatform meta-osf layer was renamed to meta-lmp.
Core layer updates based on the latest OE/Yocto master changes.

<!--more-->
# Zephyr microPlatform

## Summary

MCUboot 1.2.0 contains mostly fixes around the serial
bootloader. The Zephyr tree from the v1.13 development cycle
contains several significant improvements and new features.

## Highlights

- MCUboot 1.2.0
- Zephyr from the v1.13 development series

## Components


### MCUboot


#### Features

##### Updated simulator dependencies:
- The Rust simulator dependencies were updated to avoid
warnings in recent development environments.


#### Bugs

##### Serial overflow:
- The Zephyr serial adapter port was overwriting
received but unprocessed data buffers; this has been
fixed.



##### imgtool corruption fix:
- A bug in the imgtool script which could result in
corrupted hex files was fixed.



##### assemble.py regular expression fix:
- A regular expression bug in the assemble.py script was
fixed.



##### Zephyr test Makefile fix:
- The Makefile used to build Zephyr binaries for testing
had an invalid command line fixed.



### Zephyr


#### Features

##### Initial socket-based TLS support:
- Initial support was added for network communication
via TLS through the sockets API. Support includes:

- a credential management subsystem: the
  <net/tls_credentials.h> API allows users to define
  and manage a pool of *credentials*, which include
  certificates, private keys, and pre-shared symmetric
  keys. The nonstandard TLS_SEC_TAG_LIST setsockopt()
  option was added to allow credential selection.
- I/O syscalls: send(), recv(), and poll() support was
  added (poll() was also made thread safe).
- hostname support: the TLS_HOSTNAME socket option can be used
  to set the system's hostname.
- handshake management: cipher suite management is done via the
  TLS_CIPHERSUITE_LIST and TLS_CIPHERSUITE_USED socket
  options; the TLS_PEER_VERIFY option can be used to
  override mbedTLS's default settings for peer
  verification
- sample support: the http_get and big_http_download now support
  TLS sockets, including certificate validation via Let's
  Encrypt certificates provided with the samples.

TLS support was also added to the echo_client and
echo_server samples.

The merger of this code is a significant change, as it
unblocks rewrites or adaptations of Zephyr's network
protocol support stacks (such as MQTT, HTTP, CoAP and
LWM2M, etc.) to support TLS via a setsockopt() API.


##### Standard C Memory Allocation:
- Built-in support was added for malloc(), free(),
calloc(), realloc(), and reallocarray(). The size of
the memory pool which backs these allocations is
determined by CONFIG_MINIMAL_LIBC_MALLOC_ARENA_SIZE,
which defaults to zero to disable these functions
unless they are needed. Support for this
implementation is incompatible with use of the Newlib
C library (which provides its own primitives based on
a _sbrk() implementation provided by its runtime
environment.)


##### New "Logger" Subsystem:
- Zephyr has a new logging subsystem called Logger,
which lives in subsys/logging, and which now has
upstream documentation:

http://docs.zephyrproject.org/subsystems/logging/logger.html

This is a significant departure, both in terms of
supported features and complexity, from the
longstanding SYS_LOG APIs in <logging/sys_log.h>.

It seems to be early days, as no upstream subsystems
have been moved over to Logger from SYS_LOG. It's not
clear if Logger will replace SYS_LOG in the long term.

Foundries.io is publishing a blog series discussing
both Logger and SYS_LOG. The SYS_LOG post is
available:

https://foundries.io/blog/2018/07/24/zephyr-logging-part-1/

and we'll be releasing part 2 on Logger pending the
results of a pull request containing some minor bug
fixes.


##### Zephyr SDK minimum version bumped to 0.9.3:
- Linux users who build with the Zephyr SDK are advised
that the minimum version has been increased from 0.9.2
to 0.9.3, which was released in May. Zephyr will now
refuse to build programs with older SDK versions.


##### Networking promiscuous mode support:
- A new API was merged to <net/net_if.h> which allows
entering and exiting promiscuous mode, as well as
querying this mode, on a per-interface basis:

- net_if_set_promisc(struct net_if*)
- net_if_unset_promisc(struct net_if*)
- net_if_is_promisc(struct net_if*)

Currently, support, testing, and samples are provided
for Ethernet L2s. Users curious to try it out should
see samples/net/promiscuous_mode.


##### Application shared memory:
- When userspace is enabled, Zephyr now supports control
of shared memory regions between threads. General
usage information has been added to Zephyr's
documentation:

http://docs.zephyrproject.org/kernel/usermode/usermode_sharedmem.html


##### Ethernet driver API break:
- The API in <net/ethernet.h> saw an incompatible
change. The get_stats API callback now takes a struct
device *, rather than a struct net_if *. In-tree users
were updated; out of tree users will need updates.


##### Network packet format change:
- The IPv6 implementation now handles large packets
correctly. Fixing this required some changes to struct
net_pkt, the core representation for network packets.


##### sys_clock_us_per_tick deprecated:
- Usage of this variable was deprecated, as its value
does not portably fit into an integer. Users are
directed to use sys_clock_hw_cycles_per_sec and
sys_clock_ticks_per_sec instead.


##### Arches:
- The Atmel SAM SoC files saw a cleanup as part of the
SAMD20 support effort described below.

ARC architecture support for nsim was added.

Initial support for a new caching infrastructure on
ARM SoCs was added with support for memory caching on
ARM MPUs. See issue 8784 for more details and current
status:

https://github.com/zephyrproject-rtos/zephyr/issues/8784

On x86, Zephyr can now boot on systems with a 64-bit
BIOS, and got SoC support for Apollo Lake. A new
architecture-specific CONFIG_REALMODE option was added
as well; this enables booting Zephyr from real mode on
x86, which was previously only available in the
Jailhouse target.

The "native POSIX" pseudo-architecture grew support
for registering functions which run at exit via the
NATIVE_EXIT_TASK macro available in <soc.h>

ARM SoCs gained new abilities to recover from
otherwise-fatal MPU faults.


##### Bluetooth:
- Support was added for runtime configuration of the GAP
device name. Changes are persisted to nonvolatile
memory if CONFIG_BT_SETTINGS is enabled. The Bluetooth
shell now has a name command which can be used to
exercise this feature; without arguments, it prints
the current name, and with a single argument, it sets
the device name to the given value.


##### Boards:
- New board support was added for the Silabs EFR32 Flex
Gecko Wireless Starter Kit, Atmel SAMD20 XPlained Pro
boards, nRF52 AdaFruit Feather, nRF52840 USB Dongle
and x86 UP Squared.

The stm32f723e_disco board now has support for USB FS
OTG and I2C, following the extension of driver support
for those peripherals to STM32F7 MCUs.

The nrf52_pca10040 board has the UARTE peripheral
enabled; the console now uses this instead of RTT.

FRDM-K64F now supports
CONFIG_FS_FLASH_STORAGE_PARTITION.

The cc3220sf_launchxl board now automatically
reconnects to the last known good WiFi AP at startup.


##### Build:
- Crosstool-NG (stylized "xtools") support has been
added for the ARC architecture and IAMCU x86 variant.
Xtools support was also declared on QEMU for ARM
Cortex M3, NIOS-II, RISCV32, three variants of x86,
and a couple of real ARM and x86 boards; this was
merged as part of enabling CI testing for the new
toolchain.

Vigilant removal of redundant default n properties
from Kconfig files continues.

The build system's calls to objcopy now fill gaps with
0xff bytes. This reduces time spent programming flash
on some targets, since this value is what erased flash
pages are filled with. Flash programmers which are
smart enough to skip setting runs of 0xff will thus
see improvements.


##### Cryptography:
- The subsystem-wide TLS rewrite saw an interesting new
addition, in the form of a "generic" mbedTLS
configuration file in
ext/lib/crypto/mbedtls/configs/config-tls-generic.h.
This is now the default mbedTLS configuration file.

Users of the mbedTLS library will be familiar with its
header-file system of configuration: when the library
is compiled with the macro MBEDTLS_CONFIG_FILE
defined, its sources include the file that macro
expands to, which in turn enables, disables, or
configures their features.

In the past, Zephyr has managed separate configuration
files for different use cases. With this new addition,
a single mbedTLS file can be maintained within tree,
whose contents are controllable via Kconfig options
defined in ext/lib/crypto/mbedtls/Kconfig.tls-generic.
This bit of cleverness allows individual applications
to set their TLS configuration within Kconfig fragment
files.


##### Device Tree:
- Bindings for i.MX7d I2C and PWM drivers were added in
dts/bindings/i2c/fsl,imx7d-i2c.yaml and
fsl,imx7d-pwm.yaml.

Bindings for STM32 OTG HS USB were added in
dts/bindings/usb/st,stm32-otghs.yaml, along with SoC
DTSI nodes for STM32F4 and STM32F7.


##### Documentation:
- The documentation itself can now be built on all
supported platforms, following conversion of its build
system to CMake, and some helper scripts to Python.
Its build system now also supports out of tree builds
and inclusion within other builds, among a variety of
other cleanups, fixes, and improvements.

The Doxygen documentation for the ARM SoC specific
_Fault() routine, which handles fatal errors, has been
improved and clarified.


##### Drivers:
- gPTP support was added for the MCUX-based Ethernet
driver for NXP devices.

An API was merged for Audio Codec devices. No drivers
yet.

Support was added to the USB subsystem for Microsoft
OS Descriptors, version 1:

https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/microsoft-defined-usb-descriptors

Additionally, USB device firmware authors can now
override the usb_update_sn_string_descriptor()
function to populate serial number descriptors at
runtime.

PWM and I2C master drivers were added for the
Cortex-M4 cores present on NXP i.MX7 SoCs (the
nxp_imx/mcimx7_m4 SOC variant).

The nRF serial driver saw a lot of love. It now
supports Device Tree, power management, and both 31250
and 56000 baud rates. The last improvement may be
particularly useful for any users implementing Zephyr-
based dial-up modem support.

The SiLabs GPIO and UART drivers now have support for
EFR32 MCUs.

Driver support was added for Analog Devices ADT7420
16-bit I2C temperature sensors.


##### On STM32 MCUs:
- - USB OTG support was added for STM32F7 by adapting
  existing support for the STM32F4 series.

- STM32F7 also grew I2C support.

- The USB HS peripheral now has pin mux support for
  PB14/PB15 on STM32F4.


##### External:
- The Zlib-licensed SiLabs "Gecko SDK" HAL was added, in
order to support EFR32 MCUs.

Version 1.2.91 of the Atmel SAMD20 HALs were merged,
in order to support the SAMD20 Xplained Pro board.

Kconfiglib was updated, bringing in support for the
preprocessing language extensions described in the
Linux file kconfig-macro-language.txt:

https://github.com/torvalds/linux/blob/master/Documentation/kbuild/kconfig-macro-language.txt

as well as adding additional warnings.


##### Kernel:
- Applications can now define their own system calls
using the CONFIG_APPLICATION_DEFINED_SYSCALL Kconfig
option.  Previously, only source files in Zephyr's
include/ directory were scanned by the build system
when looking for supported system calls.

Support for read() and write() was added when using
Newlib.


##### Libraries:
- Support for the CRC32 checksum algorithm was added to
Zephyr's CRC library. It can be accessed via
<crc32.h>.

The JSON library grew a new helper macro with an
apparently misleading name. The macro in question,
JSON_OBJ_DESCR_ARRAY_ARRAY, appears to be used to
declare descriptors for arrays of structs, rather than
arrays of arrays.

POSIX compatibility was added for the pthread_once_t
and pthread_key_t typedefs.


##### Networking:
- The LWM2M implementation now allows its users to
supply callbacks which are invoked on object creation
and deletion (which, in the LWM2M protocol, may be
initiated from across the network).


##### Samples:
- A sample application demonstrating use of the new
Analog Devices ADT7420 16-bit I2C temperature sensor
driver was added to samples/sensor/adt7420.

The boards/nrf52/mesh/ samples were updated to pass
the Bluetooth Profile Tuning Suite, among several
other improvements:

https://www.bluetooth.com/develop-with-bluetooth/qualification-listing/qualification-test-tools/profile-tuning-suite

The gptp networking sample has FRDM-K64F support,
following the addition of PTP protocol support to that
board's Ethernet driver.


##### Scripts:
- A new import_mcux_sdk.py script was added, which
automates merging of new versions of the NXP MCUX HAL.


##### Testing:
- The sanitycheck script now supports nsim as an
emulation backend, following addition of this program
as a mechanism for running ARC binaries in emulation.

The saga continues on the large project of adding
Doxygen-based metadata to Zephyr's test infrastructure
to support more sophisticated CI, requirements
traceability, etc.

A variety of tests were added or improved for
multicore configurations and power management.


#### Bugs

##### Arches:
- ARM MPU support now follows recommendations for the
proper use of data and instruction synchronization
barriers when enabling and disabling the MPU.

Exception return on ARC no longer ignores updates to
the PC register.



##### Device Tree:
- The nRF UART0 peripheral with register base address
0x40002000 can be of two types (UART or UARTE),
depending on the SoC. An internal cleanup fixing the
dts.fixup and SoC dtsi files now forces their users to
declare which peripheral is in use.

The NXP device tree binding YAML files saw some
cleanups and build warning resolutions.



##### Documentation:
- The documentation covering the gPTP networking
protocol saw some fixes and enhancements.



##### Drivers:
- A bug causing overwritten GPIO configurations and
unstable firmware on Nordic devices was fixed.

The nRF serial port driver's dependency on the Zephyr
GPIO driver was replaced with calls into the nrfx GPIO
HAL to avoid initialization order issues (UART is
needed early for the console, but the GPIO driver
isn't initialized until later in the boot).

The nRF timer driver saw a bug fix related to the
combination of a tickless kernel, k_busy_wait(), and
k_sleep().

Improved management support for nRF52, including a bug
fix for wake from sleep, were merged.



##### External:
- Some out of tree patches were merged fixing bugs in
the NXP MCUX Ethernet HAL driver.



##### Kernel:
- Conversion results between system ticks and
milliseconds when the system clock is set at runtime
were fixed.

Use of the "errno" lvalue from userspace was fixed.

Use of the console from userspace with Zephyr's built-
in libc was fixed.



##### Libraries:
- A variety of fixes were merged affecting printf format
string parsing and handling in Zephyr's "minimal"
libc.

Similarly, measures were introduced to ease
compilation of various samples and libraries with the
Newlib C library.



##### Networking:
- The getaddrinfo() socket system call now properly
allocates memory for its results, which can be freed
with freeaddrinfo(). Previously, the implementation
was simply using a global variable for its results,
which precluded concurrent usage.

The LWM2M implementation ignores TLV options it cannot
handle, rather than halting option processing when it
receives one.

A potential null dereference in IPv6 address parsing
was fixed, as was a memory leak which occurs when a
neighbor solicitation request fails.

A variety of cleanups and fixes were merged affecting
IPv4 and ICMPv4 support.



##### Samples:
- The echo_server sample now uses the correct networking
APIs to handle large IPv6 packets.

The Kconfig fragments used to build the echo_client
and echo_server applications with TLS support on
qemu_x86 were fixed, fixing the build in
that configuration.



##### Testing:
- A variety of incompatibilities between Zephyr's fixed
size integer types and those provided by the standard
library were worked around or fixed.



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

Linux microPlatform meta-osf layer was renamed to meta-lmp.
Core layer updates based on the latest OE/Yocto master changes.

## Highlights

- Linux microPlatform meta-osf layer was renamed to meta-lmp
- Linux-osf recipe (unified kernel) was renamed to linux-lmp
- New layer Meta rtlwifi added to LMP (OOT Realtek WiFi Linux drivers)
- Systemd updated to the 239 release.
- U-Boot updated to the 2018.07 release.
- U-Boot-Fslc updated to the 2018.07-based release.
- NetworkManager updated to the 1.10.10 release.

## Components


### OpenEmbedded-Core Layer


#### Features

##### Layer Update:
- Automake updated to 1.16.1.
Bc updated to 1.07.1.
Ccache updated to 3.4.2.
Cmake updated to 3.11.4.
Curl updated to 7.61.0.
Debianutils updated to 4.8.6.
Dhcp updated to 4.4.1.
E2fsprogs updated to 1.44.2.
Elfutils updated to 0.172.
Ethtool updated 4.17.
File updated to 5.33.
Git updated to 2.18.0.
Go-1.10 updated to 1.10.3.
Go-1.9 updated to 1.9.7.
Gpgme updated to 1.11.1.
Iproute2 updated to 4.17.
Libgcrypt updated to 1.8.3.
Libgpg-error updated to 1.32.
Libunistring updated to 0.9.10.
Libyaml updated to 0.2.1.
Linux-firmware updated to the d114732 revision.
Ncurses updated to 6.1+20180630.
Nfs-utils updated to 2.3.1.
Nss updated to 3.38.
Pciutils updated to 3.6.1.
Procps updated to 3.3.15.
Psmisc updated to 23.1.
Python3-dbus updated to 1.2.8.
Python3-pip updated to 10.0.1.
Python3-pygobject updated to 3.28.3.
Python3-setuptools updated to 40.0.0
Shared-mime-info updated to 1.10.
Strace updated to 4.23.
Systemd updated to 239.
U-Boot updated to the 2018.07 release.
Xz updated to 5.2.4.


#### Bugs

##### qemu:
- Heap buffer overflow.

 - [CVE-2018-11806](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-11806)

##### glibc:
- Buffer overflow in the __mempcpy_avx512_no_vzeroupper
function when particular conditions are met. An attacker
could use this vulnerability to cause a denial of service
or potentially execute code.

 - [CVE-2018-11237](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-11237)

##### libxml2:
- The htmlParseTryOrFinish function in HTMLparser.c in
libxml2 2.9.4 allows attackers to cause a denial of
service (buffer over-read) or information disclosure.

 - [CVE-2017-8872](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8872)

### Meta OpenEmbedded Layer


#### Features

##### Layer Update:
- Dnsmasq updated to 2.79.
Libndp updated to 1.7.
Mozjs updated to 52.8.1.
NetworkManager updated to 1.10.10.
Polkit updated to 0.115.
Python3-certifi updated to 2018.4.16.
Python3-cryptography updated to 2.2.2.
Python3-cython updated to 0.28.4.
Python3-dbus updated to 1.2.8.
Python3-idna updated to 2.7.
Python3-ndg-httpsclient updated to 0.5.0.
Python3-pip updated to 10.0.1.
Python3-pyasn1 updated to 0.4.3.
Python3-pygobject updated to 3.28.3.
Python3-pyopenssl updated to 18.0.0.
Python3-pytest-runner updated to 4.2.
Python3-pyyaml updated to 3.13.
Python3-requests updated to 2.19.1.
Python3-setuptools-scm updated to 2.1.0.
Python3-urllib3 updated to 1.23.
Vim updated to 8.1.0172.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update:
- Intel-microcode updated to 20180703.
Iucode-tool updated to 2.3.1.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update:
- CM3 dtb included as part of raspberrypi3-64.
Firmware updated to 20180619.
Userland updated to 20180702.


#### Bugs
- Not addressed in this update

### Meta RISC-V


#### Features

##### Layer Update:
- SSP and Fortify flags disabled for riscv64.
Gdb updated to the latest RISC-V fork.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update:
- U-boot-fslc updated to the 2018.07-based release.
Firmware-imx updated to 7.5.


#### Bugs
- Not addressed in this update

### Meta Freescale 3rdparty


#### Features

##### Layer Update:
- U-boot-toradex updated to the latest git revision.
New machine configuration for colibri-imx6ull.


#### Bugs
- Not addressed in this update

### Meta LMP Layer


#### Features

##### Layer Update:
- Initramfs-ostree-osf-image was renamed to initramfs-ostree-lmp-image.
Linux-osf recipe was renamed to linux-lmp.
OSF_LMP_GIT variables were renamed to FIO_LMP_GIT.
Python3-docker updated to 3.4.1.
Python3-docker-compose updated to 1.22.0.
U-boot-compulab updated to the Compulab 1.5 release.


#### Bugs
- Not addressed in this update
