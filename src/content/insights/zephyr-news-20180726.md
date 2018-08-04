+++
title = "Zephyr Development News 26 July 2018"
date = "2018-07-26"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 26 July 2018 newsletter tracking the latest
[Zephyr](https://www.zephyrproject.org/) development merged into the
[mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

<!--more-->

As usual, content is broken down as follows:

- **Highlights**
  - Important changes: ABI/API breaks and some features
  - New features: non-exhaustive descriptions of new features
  - Bug fixes: non-exhaustive list of fixed bugs
- **Individual changes**: a complete list of patches, sorted chronologically and categorized into areas, like:
  - Architectures
  - Kernel
  - Drivers
  - etc.

Highlights
==========

This newsletter covers Zephyr between the following commits:

- [8c2acab5](https://github.com/zephyrproject-rtos/zephyr/commit/8c2acab53a212738e9a5e013fb28aa3fd1a2cdc0)
  ("drivers: add i.MX I2C driver shim"), merged 6 July 2018
- [29b65859](https://github.com/zephyrproject-rtos/zephyr/commit/29b65859b158fd24122ecf6e7ac077ef9e423406)
  ("net: samples: Add TLS support to socket echo_client/echo_server"),
  merged 26 July 2018

Important Changes
-----------------

**Initial socket-based TLS support:**

Initial support was added for network communication via TLS through
the sockets API. Support includes:

- a credential management subsystem: the `<net/tls_credentials.h>` API
  allows users to define and manage a pool of *credentials*, which
  include certificates, private keys, and pre-shared symmetric
  keys. The nonstandard `TLS_SEC_TAG_LIST` `setsockopt()` option was
  added to allow credential selection.
- I/O syscalls: `send()`, `recv()`, and `poll()` support was added
  (poll() was also made thread safe).
- hostname support: the `TLS_HOSTNAME` socket option can be used to
  set the system's hostname.
- handshake management: cipher suite management is done via the
  `TLS_CIPHERSUITE_LIST` and `TLS_CIPHERSUITE_USED` socket options;
  the `TLS_PEER_VERIFY` option can be used to override mbedTLS's
  default settings for peer verification.
- sample support: the `http_get` and `big_http_download` now support
  TLS sockets, including certificate validation via Let's Encrypt
  certificates provided with the samples. TLS support was also added
  to the `echo_client` and `echo_server` samples.

The merger of this code is a significant change, as it unblocks
rewrites or adaptations of Zephyr's network protocol support stacks
(such as MQTT, HTTP, CoAP and LWM2M, etc.) to support TLS via a
setsockopt() API.

**Standard C Memory Allocation:**

Built-in support was added for `malloc()`, `free()`, `calloc()`,
`realloc()`, and `reallocarray()`. The size of the memory pool which
backs these allocations is determined by
`CONFIG_MINIMAL_LIBC_MALLOC_ARENA_SIZE`, which defaults to zero to
disable these functions unless they are needed. Support for this
implementation is incompatible with use of the Newlib C library (which
provides its own primitives based on a `_sbrk()` implementation
provided by its runtime environment.)

**New "Logger" Subsystem:**

Zephyr has a new logging subsystem called Logger, which lives in
`subsys/logging`, and which now has [upstream
documentation](http://docs.zephyrproject.org/subsystems/logging/logger.html).
This is a significant departure, both in terms of supported features
and complexity, from the longstanding SYS_LOG APIs in `<logging/sys_log.h>`.

It seems to be early days, as no upstream subsystems have been moved
over to Logger from SYS\_LOG. It's not clear if Logger will replace
SYS_LOG in the long term.

Foundries.io is publishing a blog series discussing both Logger and
SYS\_LOG. The [SYS_LOG post is
available](https://foundries.io/blog/2018/07/24/zephyr-logging-part-1/),
and we'll be releasing part 2 on Logger pending the results of a pull
request containing some [minor bug
fixes](https://github.com/zephyrproject-rtos/zephyr/pull/9129).

**Zephyr SDK minimum version bumped to 0.9.3:**

Linux users who build with the Zephyr SDK are advised that the minimum
version has been increased from 0.9.2 to 0.9.3, which was released in
May. Zephyr will now refuse to build programs with older SDK versions.

**Networking promiscuous mode support:**

A new API was merged to `<net/net_if.h>` which allows entering and
exiting promiscuous mode, as well as querying this mode, on a
per-interface basis:

- `net_if_set_promisc(struct net_if*)`
- `net_if_unset_promisc(struct net_if*)`
- `net_if_is_promisc(struct net_if*)`

Currently, support, testing, and samples are provided for Ethernet
L2s. Users curious to try it out should see
`samples/net/promiscuous_mode`.

**Application shared memory:**

When userspace is enabled, Zephyr now supports control of shared
memory regions between threads. [General usage
information](http://docs.zephyrproject.org/kernel/usermode/usermode_sharedmem.html)
has been added to Zephyr's documentation.

**Ethernet driver API break:**

The API in `<net/ethernet.h>` saw an incompatible change. The
`get_stats` API callback now takes a `struct device *`, rather than a
`struct net_if *`. In-tree users were updated; out of tree users will
need updates.

**Network packet format change:**

The IPv6 implementation now handles large packets correctly. Fixing
this required some changes to `struct net_pkt`, the core
representation for network packets.

**sys_clock_us_per_tick deprecated:**

Usage of this variable was deprecated, as its value does not portably
fit into an integer. Users are directed to use
`sys_clock_hw_cycles_per_sec` and `sys_clock_ticks_per_sec` instead.

Features
--------

**Arches:**

The Atmel SAM SoC files saw a cleanup as part of the SAMD20 support
effort described below.

ARC architecture support for nsim was added.

Initial support for a new caching infrastructure on ARM SoCs was added
with support for memory caching on ARM MPUs. See [issue
8784](https://github.com/zephyrproject-rtos/zephyr/issues/8784) for
more details and current status.

On x86, Zephyr can now boot on systems with a 64-bit BIOS, and got SoC
support for Apollo Lake. A new architecture-specific `CONFIG_REALMODE`
option was added as well; this enables booting Zephyr from real mode
on x86, which was previously only available in the Jailhouse target.

The "native POSIX" pseudo-architecture grew support for registering
functions which run at exit via the `NATIVE_EXIT_TASK` macro available
in `<soc.h>`

ARM SoCs gained new abilities to recover from otherwise-fatal MPU
faults.

**Bluetooth:**

Support was added for runtime configuration of the GAP device name.
Changes are persisted to nonvolatile memory if
[CONFIG_BT_SETTINGS](http://docs.zephyrproject.org/reference/kconfig/CONFIG_BT_SETTINGS.html)
is enabled. The Bluetooth shell now has a `name` command which can be
used to exercise this feature; without arguments, it prints the
current name, and with a single argument, it sets the device name to
the given value.

**Boards:**

New board support was added for the Silabs EFR32 Flex Gecko Wireless
Starter Kit, Atmel SAMD20 XPlained Pro boards, nRF52 AdaFruit Feather,
nRF52840 USB Dongle and x86 UP Squared.

The stm32f723e_disco board now has support for USB FS OTG and I2C,
following the extension of driver support for those peripherals to
STM32F7 MCUs.

The nrf52_pca10040 board has the UARTE peripheral enabled; the console
now uses this instead of RTT.

FRDM-K64F now supports
[CONFIG_FS_FLASH_STORAGE_PARTITION](http://docs.zephyrproject.org/devices/dts/flash_partitions.html).

The `cc3220sf_launchxl` board now automatically reconnects to the last
known good WiFi AP at startup.

**Build:**

[Crosstool-NG](https://crosstool-ng.github.io/) (stylized "xtools")
support has been added for the ARC architecture and IAMCU x86 variant.
Xtools support was also declared on QEMU for ARM Cortex M3, NIOS-II,
RISCV32, three variants of x86, and a couple of real ARM and x86
boards; this was merged as part of enabling CI testing for the new
toolchain.

Vigilant removal of redundant `default n` properties from Kconfig
files continues.

The build system's calls to `objcopy` now fill gaps with 0xff
bytes. This reduces time spent programming flash on some targets,
since this value is what erased flash pages are filled with. Flash
programmers which are smart enough to skip setting runs of 0xff will
thus see improvements.

**Cryptography:**

The subsystem-wide TLS rewrite saw an interesting new addition, in the
form of a "generic" mbedTLS configuration file in
`ext/lib/crypto/mbedtls/configs/config-tls-generic.h`. This is now the
default mbedTLS configuration file.

Users of the mbedTLS library will be familiar with its header-file
system of configuration: when the library is compiled with the macro
`MBEDTLS_CONFIG_FILE` defined, its sources include the file that macro
expands to, which in turn enables, disables, or configures their
features.

In the past, Zephyr has managed separate configuration files for
different use cases. With this new addition, a single mbedTLS file can
be maintained within tree, whose contents are controllable via Kconfig
options defined in `ext/lib/crypto/mbedtls/Kconfig.tls-generic`. This
bit of cleverness allows individual applications to set their TLS
configuration within Kconfig fragment files.

**Device Tree:**

Bindings for i.MX7d I2C and PWM drivers were added in
`dts/bindings/i2c/fsl,imx7d-i2c.yaml` and `fsl,imx7d-pwm.yaml`.

Bindings for STM32 OTG HS USB were added in
`dts/bindings/usb/st,stm32-otghs.yaml`, along with SoC DTSI nodes for
STM32F4 and STM32F7.

**Documentation:**

The documentation itself can now be built on all supported platforms,
following conversion of its build system to CMake, and some helper
scripts to Python. Its build system now also supports out of tree
builds and inclusion within other builds, among a variety of other
cleanups, fixes, and improvements.

The Doxygen documentation for the ARM SoC specific `_Fault()` routine,
which handles fatal errors, has been improved and clarified.

**Drivers:**

gPTP support was added for the MCUX-based Ethernet driver for NXP
devices.

An API was merged for Audio Codec devices. No drivers yet.

Support was added to the USB subsystem for [Microsoft OS Descriptors,
version
1](https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/microsoft-defined-usb-descriptors). Additionally,
USB device firmware authors can now override the
`usb_update_sn_string_descriptor()` function to populate serial number
descriptors at runtime.

PWM and I2C master drivers were added for the Cortex-M4 cores present
on NXP i.MX7 SoCs (the `nxp_imx/mcimx7_m4` SOC variant).

The nRF serial driver saw a lot of love. It now supports Device
Tree, power management, and both 31250 and 56000 baud rates. The
last improvement may be particularly useful for any users implementing
Zephyr-based dial-up modem support.

The SiLabs GPIO and UART drivers now have support for EFR32 MCUs.

Driver support was added for Analog Devices ADT7420 16-bit I2C
temperature sensors.

On STM32 MCUs:

- USB OTG support was added for STM32F7 by adapting existing
  support for the STM32F4 series.

- STM32F7 also grew I2C support.

- The USB HS peripheral now has pin mux support for PB14/PB15 on
  STM32F4.

**External:**

The Zlib-licensed SiLabs "Gecko SDK" HAL was added, in order to
support EFR32 MCUs.

Version 1.2.91 of the Atmel SAMD20 HALs were merged, in order to
support the SAMD20 Xplained Pro board.

Kconfiglib was updated, bringing in support for the preprocessing
language extensions described in the Linux file
[kconfig-macro-language.txt](https://github.com/torvalds/linux/blob/master/Documentation/kbuild/kconfig-macro-language.txt),
as well as adding additional warnings.

**Kernel:**

Applications can now define their own system calls using the
[CONFIG_APPLICATION_DEFINED_SYSCALL](http://docs.zephyrproject.org/reference/kconfig/CONFIG_APPLICATION_DEFINED_SYSCALL.html)
Kconfig option.  Previously, only source files in Zephyr's `include/`
directory were scanned by the build system when looking for supported
system calls.

Support for `read()` and `write()` was added when using Newlib.

**Libraries:**

Support for the CRC32 checksum algorithm was added to Zephyr's CRC
library. It can be accessed via `<crc32.h>`.

The JSON library grew a new helper macro with an apparently misleading
name. The macro in question, `JSON_OBJ_DESCR_ARRAY_ARRAY`, appears to
be used to declare descriptors for arrays of structs, rather than
arrays of arrays.

POSIX compatibility was added for the `pthread_once_t` and
`pthread_key_t` typedefs.

**Networking:**

The LWM2M implementation now allows its users to supply callbacks
which are invoked on object creation and deletion (which, in the LWM2M
protocol, may be initiated from across the network).

**Samples:**

A sample application demonstrating use of the new Analog Devices
ADT7420 16-bit I2C temperature sensor driver was added to
`samples/sensor/adt7420`.

The `boards/nrf52/mesh/` samples were updated to pass the Bluetooth
[Profile Tuning
Suite](https://www.bluetooth.com/develop-with-bluetooth/qualification-listing/qualification-test-tools/profile-tuning-suite),
among several other improvements.

The `gptp` networking sample has FRDM-K64F support, following the
addition of PTP protocol support to that board's Ethernet driver.

**Scripts:**

A new `import_mcux_sdk.py` script was added, which automates merging
of new versions of the NXP MCUX HAL.

**Testing:**

The sanitycheck script now supports nsim as an emulation backend,
following addition of this program as a mechanism for running ARC
binaries in emulation.

The saga continues on the large project of adding Doxygen-based
metadata to Zephyr's test infrastructure to support more sophisticated
CI, requirements traceability, etc.

A variety of tests were added or improved for multicore configurations
and power management.

Bug Fixes
---------

**Arches:**

ARM MPU support now follows recommendations for the proper use of data
and instruction synchronization barriers when enabling and disabling
the MPU.

Exception return on ARC no longer ignores updates to the PC register.

**Device Tree:**

The nRF UART0 peripheral with register base address 0x40002000 can be
of two types (UART or UARTE), depending on the SoC. An internal
cleanup fixing the dts.fixup and SoC dtsi files now forces their users
to declare which peripheral is in use.

The NXP device tree binding YAML files saw some cleanups and build
warning resolutions.

**Documentation:**

The documentation covering the gPTP networking protocol saw some fixes
and enhancements.

**Drivers:**

A bug causing overwritten GPIO configurations and unstable firmware on
Nordic devices was fixed.

The nRF serial port driver's dependency on the Zephyr GPIO driver was
replaced with calls into the nrfx GPIO HAL to avoid initialization
order issues (UART is needed early for the console, but the GPIO
driver isn't initialized until later in the boot).

The nRF timer driver saw a bug fix related to the combination of a
tickless kernel, `k_busy_wait()`, and `k_sleep()`.

Improved management support for nRF52, including a bug fix for wake
from sleep, were merged.

**External:**

Some out of tree patches were merged fixing bugs in the NXP MCUX
Ethernet HAL driver.

**Kernel:**

Conversion results between system ticks and milliseconds when the
system clock is set at runtime were fixed.

Use of the 'errno' lvalue from userspace was fixed.

Use of the console from userspace with Zephyr's built-in libc was
fixed.

**Libraries:**

A variety of fixes were merged affecting printf format string parsing
and handling in Zephyr's "minimal" libc.

Similarly, measures were introduced to ease compilation of various
samples and libraries with the Newlib C library.

**Networking:**

The `getaddrinfo()` socket system call now properly allocates memory
for its results, which can be freed with `freeaddrinfo()`. Previously,
the implementation was simply using a global variable for its results,
which precluded concurrent usage.

The LWM2M implementation ignores TLV options it cannot handle, rather
than halting option processing when it receives one.

A potential null dereference in IPv6 address parsing was fixed, as was
a memory leak which occurs when a neighbor solicitation request fails.

A variety of cleanups and fixes were merged affecting IPv4 and ICMPv4
support.

**Samples:**

The `echo_server` sample now uses the correct networking APIs to
handle large IPv6 packets.

The Kconfig fragments used to build the `echo_client` and
`echo_server` applications with TLS support on `qemu_x86` were fixed,
restoring that sample's build in that configuration.

**Testing:**

A variety of incompatibilities between Zephyr's fixed size integer
types and those provided by the standard library were worked around or
fixed.

Individual Changes
==================

Patches by area (391 patches total):

- Arches: 44
- Bluetooth: 18
- Boards: 21
- Build: 15
- Continuous Integration: 12
- Device Tree: 9
- Documentation: 24
- Drivers: 50
- External: 12
- Firmware Update: 1
- Kernel: 12
- Libraries: 11
- Logging: 18
- Maintainers: 2
- Miscellaneous: 1
- Networking: 59
- Samples: 36
- Scripts: 6
- Testing: 40

Arches (44):

- [970c4f9c](https://github.com/zephyrproject-rtos/zephyr/commit/970c4f9cf3a0a6a4a5291700840d18bdd0b41e1c) arch: Add imx7d_m4 i2c definitions
- [f93b3d19](https://github.com/zephyrproject-rtos/zephyr/commit/f93b3d1947396a41365b4a5500be965899ff8e8e) arch: arm: fix linker script title comment
- [b3d34d2e](https://github.com/zephyrproject-rtos/zephyr/commit/b3d34d2e4c4a24684d8ae4df00bb6ccd848fdb77) arch: arm: nrf52: Support UARTE defines in dts.fixup
- [530a7131](https://github.com/zephyrproject-rtos/zephyr/commit/530a71310e716835941bbdcbff590676d7b3f0c2) arm: nxp: mpu: Consolidate k64 mpu regions
- [496b7994](https://github.com/zephyrproject-rtos/zephyr/commit/496b799474ef32ab4c8121e267931e27e02a6785) arm: exx32: Add Silabs EFR32FG1P soc files
- [6d5206e7](https://github.com/zephyrproject-rtos/zephyr/commit/6d5206e7b04171b614d0ca0c724b4a836706939b) arm: exx32: Add additional include to efm32wg soc.h
- [31aaf077](https://github.com/zephyrproject-rtos/zephyr/commit/31aaf077195dc4ea303d12db3afb232b679c714b) arch: atmel_sam0: move clk config options to common Kconfig
- [781a2f02](https://github.com/zephyrproject-rtos/zephyr/commit/781a2f02750bda0066c2c39b70beabb955453b0c) arch: add support SAMD20 used in the SAMD20 Xplained Pro Board
- [d76e39f8](https://github.com/zephyrproject-rtos/zephyr/commit/d76e39f8d31e29ddc0c97485df08a5086759565a) arch: atmel_sam0: Fix Kconfig warnings
- [d27aadf9](https://github.com/zephyrproject-rtos/zephyr/commit/d27aadf941d09e1b6ff8a29505bf8591a9fee9d5) arch: arc: add nsim support in soc
- [747b90c3](https://github.com/zephyrproject-rtos/zephyr/commit/747b90c3da11e115a1c4e52b71e60a097cdaee4f) arch: arm: mpu: remove REGION_USER_RAM_ATTR macro
- [f5b00ff6](https://github.com/zephyrproject-rtos/zephyr/commit/f5b00ff60ef516ba682f9374d14f601bd02eee3f) arch: arm: mpu: fix outer inner WBWA non-shareable macro
- [06bb0553](https://github.com/zephyrproject-rtos/zephyr/commit/06bb05533d4173f0a5d841bbe21170985425b1be) arch: arm: mpu: enable WBWA caching on RAM
- [15d3dfa9](https://github.com/zephyrproject-rtos/zephyr/commit/15d3dfa9b09791f54cf93ce5396b491e77ba1547) arch: arm: mpu: enable WT caching on Flash
- [8d1664c2](https://github.com/zephyrproject-rtos/zephyr/commit/8d1664c2f700dd15e2b9983a8b0ef68f98274212) arch: arm: mpu: enable WBWA caching on per thread user RAM
- [9aa2488e](https://github.com/zephyrproject-rtos/zephyr/commit/9aa2488e7aa55cff5ddbab828257a4d36247eda9) soc: stm32f4: add pinmux defs for usb on pb14 and pb15
- [8bfddb52](https://github.com/zephyrproject-rtos/zephyr/commit/8bfddb52e58a84e89d7a4becb08e4f2c0cdcc68b) arch: arm: mpu: fix _get_region_ap(.) function
- [3cb9018e](https://github.com/zephyrproject-rtos/zephyr/commit/3cb9018e235ff0192ab9f3c68fbb3b34bd8e1bb3) arch: x86: Kconfig: Fix CACHE_LINE_SIZE default for CPU_ATOM
- [a20cc9e7](https://github.com/zephyrproject-rtos/zephyr/commit/a20cc9e78bbbfe94290088bab175a01f28855408) arch: arm: nrf52: Enable interrupts on wake up from sleep
- [942ab7ed](https://github.com/zephyrproject-rtos/zephyr/commit/942ab7ed3571738ca87ed8e953fe41ae52b30dde) esp32: include register headers in soc.h
- [6e41f9e1](https://github.com/zephyrproject-rtos/zephyr/commit/6e41f9e181b57d29bf6e5afba2e99e952240a3a1) arch: arm: enable/disable MPU using API functions
- [26e83aab](https://github.com/zephyrproject-rtos/zephyr/commit/26e83aab3550b7d8ad8fa577cb3555fe7c6ef414) arch/x86/soc: add SoC configuration for Apollo Lake
- [c2454309](https://github.com/zephyrproject-rtos/zephyr/commit/c2454309de76ae440f6db44d20b2b084be323f05) arch: Add i.MX7 PWM get clock frequency function
- [d99f6ada](https://github.com/zephyrproject-rtos/zephyr/commit/d99f6ada84b7a6063ebeadab5ea0c40475bf9e76) arch: Add support for i.MX PWM
- [15d847ad](https://github.com/zephyrproject-rtos/zephyr/commit/15d847add8e9c0db29ef4b938f49b4341bff189d) native: Add NATIVE_EXIT_TASK hooks
- [414c39fc](https://github.com/zephyrproject-rtos/zephyr/commit/414c39fc94ba43d7dadc694ebd902eed0261417c) posix: add pthread_key and pthread_once APIs
- [2e615181](https://github.com/zephyrproject-rtos/zephyr/commit/2e615181f0b3714da0e549a055fbe5f940168e83) arch: x86: Reorder the SoC power states for Quark SE
- [fe48f743](https://github.com/zephyrproject-rtos/zephyr/commit/fe48f743f34daa5ad7dbb981aa2a4965f0d1450e) arch: arc: Fix Deep Sleep hang issue on Quark SE(ARC)
- [7ce9615a](https://github.com/zephyrproject-rtos/zephyr/commit/7ce9615a2b70919bf8e79da47e6f277ab68f3c5d) nsim: add run target
- [36271676](https://github.com/zephyrproject-rtos/zephyr/commit/362716762b7c7e1dc7f038de5b6bbbdc3d4d61b9) arm: arch.h: move extern "C" after includes
- [45f069a4](https://github.com/zephyrproject-rtos/zephyr/commit/45f069a4bb6ccb9f72433de3a5c4f98244c552a3) arc: arch.h: move extern "C" after includes
- [17282578](https://github.com/zephyrproject-rtos/zephyr/commit/17282578a979c9dbbb17e5d85fd71a9d397a92ff) arc: fix update of ERET on exc return
- [f4645561](https://github.com/zephyrproject-rtos/zephyr/commit/f4645561f9145cb7f0e95deb5d9e2a759f8b2b01) arch: arm: improve documentation of _Fault(.)
- [afef6452](https://github.com/zephyrproject-rtos/zephyr/commit/afef645279894fb7e6509c7c3a5d0765084ecc58) arch: arm: Call NanoFatalErrorHandler and split out Secure stack dump
- [f713fa5d](https://github.com/zephyrproject-rtos/zephyr/commit/f713fa5d527d39a73848293cd8f45a4eb9bd0d7d) arch: arm: re-organize arm fault handling
- [90b64489](https://github.com/zephyrproject-rtos/zephyr/commit/90b64489e57dd8dfb1ae2b21d964bf1b1e177851) arch: arm: allow processor to ignore/recover from faults
- [07e913a1](https://github.com/zephyrproject-rtos/zephyr/commit/07e913a1e5865d49a3c07512414a17865dd86384) ioapic: IOREGSEL register needs to be treated as 32 bits
- [50a08d9e](https://github.com/zephyrproject-rtos/zephyr/commit/50a08d9e8b1bc17867d74056ce5b3d50a1d3dfe6) loapic timer: LVTT should be programmed before ICR
- [302494d3](https://github.com/zephyrproject-rtos/zephyr/commit/302494d35a35ad7932897621a140ee4a43d64191) arch: stm32f4/f7: Add OTG HS defines to dts fixup file
- [362e5ddb](https://github.com/zephyrproject-rtos/zephyr/commit/362e5ddb6bc0e32120d50e68cfbc1cdabedb2432) native_posix: Be more precise with stop-at
- [ba45d54b](https://github.com/zephyrproject-rtos/zephyr/commit/ba45d54bf903bc82fbd91aa9f6e73ece8e8b071c) native_posix: command line parsing fix
- [5cc928fb](https://github.com/zephyrproject-rtos/zephyr/commit/5cc928fbd456308efe35299f344023a1d9c9cf47) native_posix: Add realtime control and real time clok model
- [97c06a7a](https://github.com/zephyrproject-rtos/zephyr/commit/97c06a7ab35772ef3cd6de8a39688bbd0a4dcf3c) arm: fix assembler offset errors on Cortex-M0
- [fe321f02](https://github.com/zephyrproject-rtos/zephyr/commit/fe321f02fa679a51e73b0db90450f86e1cb57547) arch: st_stm32: Fix IRQs number of various SoCs

Bluetooth (18):

- [c2862eda](https://github.com/zephyrproject-rtos/zephyr/commit/c2862eda4d1e1ee45ff187399e9aa27c96d6bd93) bluetooth: mesh: shell:  Fix warning when building with newlib
- [f035395e](https://github.com/zephyrproject-rtos/zephyr/commit/f035395ed0888dd7e944e4cc1f3bef599ae9d228) bluetooth: at: Fix warning when building with newlib
- [e29acf00](https://github.com/zephyrproject-rtos/zephyr/commit/e29acf00158d2b17c5c4c3bbe5904b6db5bd42e8) Bluetooth: shell: fix type usage
- [be9966f3](https://github.com/zephyrproject-rtos/zephyr/commit/be9966f3aee49df43f9e738c4ae07f9d9e513c83) Bluetooth: Mesh: Fix missing semicolon for debug log
- [2637c978](https://github.com/zephyrproject-rtos/zephyr/commit/2637c978fe573654fca77d8f181dab52d04eeeb5) Bluetooth: Store device name
- [aa339ed0](https://github.com/zephyrproject-rtos/zephyr/commit/aa339ed0f220ac9438286af7a33334efa425fb06) Bluetooth: GATT: Make GAP name writable
- [acc3e512](https://github.com/zephyrproject-rtos/zephyr/commit/acc3e5129ecf949089a485ed8f5b8a3e6d2568ab) Bluetooth: Add BT_LE_ADV_OPT_USE_NAME
- [18df1164](https://github.com/zephyrproject-rtos/zephyr/commit/18df11646f2767ce97018069a8a6de1c4de084f0) Bluetooth: Allow use of ScanData with BT_LE_ADV_OPT_USE_NAME
- [4052ca6d](https://github.com/zephyrproject-rtos/zephyr/commit/4052ca6d1748c3e78b2be01107ca4156193c61a5) Bluetooth: Use shortened name if complete doesn't fit
- [2e2f122d](https://github.com/zephyrproject-rtos/zephyr/commit/2e2f122d51165a18f8858eb928fc3fc7039a4bc6) Bluetooth: samples: Make use of BT_LE_ADV_OPT_USE_NAME
- [a8688fc5](https://github.com/zephyrproject-rtos/zephyr/commit/a8688fc587518b8eaa566a3de51662a342a3c387) Bluetooth: peripheral: Set CONFIG_BT_DEVICE_NAME_MAX
- [d1c4ce87](https://github.com/zephyrproject-rtos/zephyr/commit/d1c4ce8741d1339875709cea2b5cefedefb34980) Bluetooth: shell: Make use of BT_LE_ADV_OPT_USE_NAME
- [e9e51151](https://github.com/zephyrproject-rtos/zephyr/commit/e9e511511635fa8171a5fef537238cf861395623) Bluetooth: shell: Add name command
- [99a91c94](https://github.com/zephyrproject-rtos/zephyr/commit/99a91c945994224e52a077a641f03951e796689e) Bluetooth: Kconfig: Lower minimum required ACL buffer count
- [e3bf5356](https://github.com/zephyrproject-rtos/zephyr/commit/e3bf53566e2b99973eacf2002158da08de2ec436) Bluetooth: controller: Fix disabling LE Encryption support
- [d26e482d](https://github.com/zephyrproject-rtos/zephyr/commit/d26e482daba79d4d5765714a2ee6227588dbef7a) Bluetooth: Mesh: Use more reasonable advertising buffer counts
- [8c1c1641](https://github.com/zephyrproject-rtos/zephyr/commit/8c1c1641fe4923f0953a2e8a002e7852602d6f4c) Bluetooth: Mesh: Improve outgoing segment count configuration
- [c384631d](https://github.com/zephyrproject-rtos/zephyr/commit/c384631dac1e040bb8ee791ecb83cd2565f4bf35) Bluetooth: Mesh: Kconfig: Tweak RX SDU value

Boards (21):

- [618209af](https://github.com/zephyrproject-rtos/zephyr/commit/618209af0a08694812cefdc40807e16b1c9900e3) board: add i2c support for colibri_imx7d_m4 board
- [ae5105c0](https://github.com/zephyrproject-rtos/zephyr/commit/ae5105c08b701b19b78d83427a55d1b9c8c3fd5c) boards: more boards with xtools support
- [ef154430](https://github.com/zephyrproject-rtos/zephyr/commit/ef1544301fbbb7ed7894e8e1545b88890f587774) boards: arduino_101_mcuboot: Remove Kconfig settings moved to DTS
- [899bdb13](https://github.com/zephyrproject-rtos/zephyr/commit/899bdb137110d8324a030a8c9a14c6c3b8b6b4fe) boards: arm: Add support for Silabs EFR32 SLWSTK6061A board
- [4d3e13d1](https://github.com/zephyrproject-rtos/zephyr/commit/4d3e13d1e0580fe155b9c0cbd99600421abf1f75) boards: add board and DTS definitions for the SAMD20 Xplained Pro Board
- [b6e41e71](https://github.com/zephyrproject-rtos/zephyr/commit/b6e41e715cdd28daca10a0ad69718ba285ca9398) boards: arc: add virtual board based on nsim
- [793c254e](https://github.com/zephyrproject-rtos/zephyr/commit/793c254eccfae30c86d4b4ce893dca3b783b493b) boards: Add support for nRF52 Adafruit Feather
- [a32b6628](https://github.com/zephyrproject-rtos/zephyr/commit/a32b66289a158a240cfc2f305cf15565d74701b8) boards: arm: stm32f723e_disco: enable USB FS OTG
- [26631477](https://github.com/zephyrproject-rtos/zephyr/commit/2663147783a53bdf19950a6ada535b7c43381b63) boards: arm: nrf: enable UARTE on nrf52810_pca10040
- [f5569a9d](https://github.com/zephyrproject-rtos/zephyr/commit/f5569a9dd37ec2d200db8f7d3cdc2a31b0f5cffb) frdm_k64f: dts: Addition of a Flash Partion
- [2bda5cf1](https://github.com/zephyrproject-rtos/zephyr/commit/2bda5cf1a7315e051e32d90c33e51369880ee7eb) boards/x86: scripts: extend build_grub.sh for 64-bit UEFI
- [04d1a38b](https://github.com/zephyrproject-rtos/zephyr/commit/04d1a38b4563ce0dd7e94a38532660ae6a7fb567) boards: x86: add support for UP Squared (Pentium/Celeron)
- [10af6c34](https://github.com/zephyrproject-rtos/zephyr/commit/10af6c34b41683fb17886be01abafa5e9ce8bb64) board: Add PWM support for colibri_imx7d_m4
- [c0563401](https://github.com/zephyrproject-rtos/zephyr/commit/c056340162939ace488cb81274312ed4f8c5a9f1) boards: arc: fix the wrong mpu configuration of nsim board
- [8a86931e](https://github.com/zephyrproject-rtos/zephyr/commit/8a86931e8acd5b223dddfefec662cb710eb0901e) board: quark_se_c1000: Add default setting for cc2520 radio
- [fd62b7a0](https://github.com/zephyrproject-rtos/zephyr/commit/fd62b7a085cb1f9df3ed394f42c0ef64e4016a7b) boards: nsim_sem: fix identifier
- [d44c9001](https://github.com/zephyrproject-rtos/zephyr/commit/d44c900143f01f62b7b48786e98430b94f50872f) boards: nsim_em: mark as simulation platform
- [ef935898](https://github.com/zephyrproject-rtos/zephyr/commit/ef935898d0bb7eb45f464650d79a264b2c3b0e98) boards: arm: add nrf52840_pca10059
- [efb0080d](https://github.com/zephyrproject-rtos/zephyr/commit/efb0080d8b9d9e74ed54b49e18edc480718299ea) boards/x86: up_squared: fix UART interrupt triggers
- [d147cc8d](https://github.com/zephyrproject-rtos/zephyr/commit/d147cc8dd43ad233666a8f3cde013e85662d0823) mimxrt1050_evk: disable sanitycheck on this board [REVERT ME]
- [6b039a2b](https://github.com/zephyrproject-rtos/zephyr/commit/6b039a2b5d59523b6b160712cfc874216e83a162) boards: arm: stm32f723e_disco: enable I2C support

Build (15):

- [7c15934b](https://github.com/zephyrproject-rtos/zephyr/commit/7c15934b53006a643e9872585a7bb9532ee90776) toolchains: add xtools support for ARC
- [458fe446](https://github.com/zephyrproject-rtos/zephyr/commit/458fe446926e0fe6dd569c37fff65d05df5390bc) toolchain: iamcu support with xtools toolchain
- [0009df82](https://github.com/zephyrproject-rtos/zephyr/commit/0009df82124676493c17a2bf9473aac2f50b1360) toolchains: fix multilib libc linking with xtools
- [6f29dac2](https://github.com/zephyrproject-rtos/zephyr/commit/6f29dac25a2ae4688da4f6cfbadab859de29a572) toolchain: require Zephyr SDK 0.9.3
- [ff5452ef](https://github.com/zephyrproject-rtos/zephyr/commit/ff5452ef5ccc4dd6dc3497b424dcbe3846b839c7) cmake: util: Add process.cmake script
- [b8dd6ac7](https://github.com/zephyrproject-rtos/zephyr/commit/b8dd6ac7416b552e204ce88d60bc495b2e85f251) cmake: util: Add fmerge.cmake script
- [6b836d6e](https://github.com/zephyrproject-rtos/zephyr/commit/6b836d6e6de07f974b7e8786b3f1063e7e2a3d82) cmake: Add "gap-fill 0xFF" option for CMAKE_OBJCOPY command.
- [45d58a7b](https://github.com/zephyrproject-rtos/zephyr/commit/45d58a7bb1614f0e2d7b68b16182ef9af4ea05e3) cmake: Rename process.cmake to reflect contents
- [15bc615b](https://github.com/zephyrproject-rtos/zephyr/commit/15bc615b5b5b00d8e4fd6747eaf338659bdfeaa8) cmake: Use _FORTIFY_SOURCE only with optimizations enabled
- [10738829](https://github.com/zephyrproject-rtos/zephyr/commit/10738829981457cc75d1443ae2f5f361c10e87de) subsys: kconfig: Remove 'default n' properties and clean up a bit
- [93ca721c](https://github.com/zephyrproject-rtos/zephyr/commit/93ca721c48f0c2f4dac23ef709d56892aa00a495) xtools: set toolchain vendor to zephyr
- [98775f34](https://github.com/zephyrproject-rtos/zephyr/commit/98775f34c3a2aa63d731aada87db20d8e01fd3e6) kconfig: decouple realmode boot from CONFIG_JAIHOUSE
- [4c60c510](https://github.com/zephyrproject-rtos/zephyr/commit/4c60c510c3350818b675d8ecc99dd1e46843321d) cmake: default to linking 'app' with the interface library 'FS'
- [c9e12493](https://github.com/zephyrproject-rtos/zephyr/commit/c9e12493b2308fd09351a0a0b17e9244de639d35) cmake: Remove duplicate invocations of target_link_libraries on app
- [c68ab81f](https://github.com/zephyrproject-rtos/zephyr/commit/c68ab81f895bc0830b6ea3183ebae21c1953fd18) cmake: settings: Don't add ext nffs include dir to global includes

Continuous Integration (12):

- [eda3e16a](https://github.com/zephyrproject-rtos/zephyr/commit/eda3e16ac7c37551cc97f3cc821bf0db898cb182) coverage: exclude k_call_stacks_analyze from coverage
- [b1045fee](https://github.com/zephyrproject-rtos/zephyr/commit/b1045fee5998fec94ff659de67b2159950cc897d) sanitycheck: Do not calculate size for native builds
- [1377375a](https://github.com/zephyrproject-rtos/zephyr/commit/1377375af2592d9eb912366a0ec516bfc9f0fab8) sanitycheck: refactor add_goal
- [4a9f3e63](https://github.com/zephyrproject-rtos/zephyr/commit/4a9f3e63b8989c40004fb210dc820062fb14dc9f) sanitycheck: do not redefine handler_log
- [df7ee61c](https://github.com/zephyrproject-rtos/zephyr/commit/df7ee61c0948aa0ea01bb9c9b01d22d1dd3eec0b) sanitycheck: merge native and unit handlers
- [685111ac](https://github.com/zephyrproject-rtos/zephyr/commit/685111ac068b6c2551ccb8d2e495e6a390290814) sanitycheck: add nsim as simulation type
- [99f5a6cf](https://github.com/zephyrproject-rtos/zephyr/commit/99f5a6cfed0e0244a857ad1cde6e954566866638) sanitycheck: support additional handlers
- [e24350c7](https://github.com/zephyrproject-rtos/zephyr/commit/e24350c77520e486007e4c7a96441f5150d417ff) sanitycheck: do not run if we do not have nsimdrv
- [d74a56bd](https://github.com/zephyrproject-rtos/zephyr/commit/d74a56bd63440bac02372bc1dea96e40c4491c1e) sanitycheck: set state correctly in case of a crash
- [d2b3c754](https://github.com/zephyrproject-rtos/zephyr/commit/d2b3c754032eea2d1586ee5faf6dfeb3ecbe1534) Revert "sanitycheck: set state correctly in case of a crash"
- [f3d48e1c](https://github.com/zephyrproject-rtos/zephyr/commit/f3d48e1ccec3841956aed1feef631676756c953f) sanitycheck: allow blacklisting boards
- [448cd0c0](https://github.com/zephyrproject-rtos/zephyr/commit/448cd0c0cefb8b559f022b97eda7721f94753480) ci: handle documentation errors in ci

Device Tree (9):

- [f0450fc4](https://github.com/zephyrproject-rtos/zephyr/commit/f0450fc42375f474e7f436f01bb17ac97abbaaab) nrf52: dts: Force user to explicitly set UART0 compatible
- [5a1bcc75](https://github.com/zephyrproject-rtos/zephyr/commit/5a1bcc756c2e7fab99905b09346f9de974c7afbc) dts: arm: sam0: move contents samd21 to samd
- [f76f7585](https://github.com/zephyrproject-rtos/zephyr/commit/f76f7585abe7e932586d721087fc823740deb0c3) dts: yaml: Remove unused nxp,kw41z-sim.yaml
- [bbda4455](https://github.com/zephyrproject-rtos/zephyr/commit/bbda4455e46dfb1529ba27ba60a36bd7a3740e05) dts: yaml: Add missing id property to nxp bindings
- [4433d9d3](https://github.com/zephyrproject-rtos/zephyr/commit/4433d9d3d246107ce1e1a685419b05e6b6f32a1b) dts: yaml: Align serial driver clocks bindings
- [6693537c](https://github.com/zephyrproject-rtos/zephyr/commit/6693537c548413bfc28f61708dad8e649dc34181) dts: yaml: Align spi driver clocks bindings
- [3bda93a3](https://github.com/zephyrproject-rtos/zephyr/commit/3bda93a3aaf16215f4a2c7eee5399e69b2a286b1) dts: arc: fixes the warning msgs during cmake
- [8f338eca](https://github.com/zephyrproject-rtos/zephyr/commit/8f338ecaa07930b6db26232913b22c6302fa5b07) dts/bindings/usb: Add yaml files for STM32 OTG HS
- [cc214b44](https://github.com/zephyrproject-rtos/zephyr/commit/cc214b4426d4673887210598b335e7e9924d2489) dts/arm/st: Add OTG HS node to STM32 F4 and F7 series

Documentation (24):

- [489b27a2](https://github.com/zephyrproject-rtos/zephyr/commit/489b27a22baffceacf2f2f9fe8ee3ae92c3c662d) doc: net: Fix source tree layout documentation
- [5ea5b8d3](https://github.com/zephyrproject-rtos/zephyr/commit/5ea5b8d35fc297bde133c5b47867d3a35bed7b9e) doc: subsys: logging: Add documentation for new logger
- [c7bb8c21](https://github.com/zephyrproject-rtos/zephyr/commit/c7bb8c21acb3d3568d71e8b1a144cdc8c9662906) doc: net: gptp: Fix gptp API function description
- [2dc28b49](https://github.com/zephyrproject-rtos/zephyr/commit/2dc28b495e68788bcb4ed6dc8752da677b878650) doc: net: gptp: Enhance gPTP documentation
- [ae69934c](https://github.com/zephyrproject-rtos/zephyr/commit/ae69934cb9617f6ff26131f294d0f2e0054a10f8) doc: Support building with CMake
- [7480f17d](https://github.com/zephyrproject-rtos/zephyr/commit/7480f17d50de107882ed795c4e92a6d1d96bd9e0) doc: Change Makefile and doc for building docs to CMake
- [5ead0a52](https://github.com/zephyrproject-rtos/zephyr/commit/5ead0a52a5a72498601e24a75e88d25ab21a5764) doc: Remove old Makefile
- [60a9e1a7](https://github.com/zephyrproject-rtos/zephyr/commit/60a9e1a7c769cbd2fc86d4d1d420160bdccd6372) doc: Remove unused filter-doc-log.sh
- [5e5fe0d7](https://github.com/zephyrproject-rtos/zephyr/commit/5e5fe0d74f4be756af268689f6c645884fb70dd3) doc: known issues: Fix regexes for Windows
- [247ca67c](https://github.com/zephyrproject-rtos/zephyr/commit/247ca67ceae7ee8d07983444cf99607df1c03994) doc: sphinx: Reshuffle sphinx cmd-line options
- [b3d2de71](https://github.com/zephyrproject-rtos/zephyr/commit/b3d2de7163dce6401f5ce5addee6f84b97f9d4df) doc: Makefil: Propagate Make options
- [d505ca70](https://github.com/zephyrproject-rtos/zephyr/commit/d505ca70819cbe814d11d56ef0d523914672f86f) doc: cmake: Fix argument parsing
- [2af9a9e6](https://github.com/zephyrproject-rtos/zephyr/commit/2af9a9e62812e48d707f207abbf51d1a20685af2) doc: cmake: Use flexible variables for inclusion
- [2516aa07](https://github.com/zephyrproject-rtos/zephyr/commit/2516aa07e486abccda6aca35f6d950d184814599) doc: Add doxygen to Chocolatey package list
- [46db70ac](https://github.com/zephyrproject-rtos/zephyr/commit/46db70ac4cc088a4780de631dd153f7b4812ff3d) doc: subsys: logging: internal thread and thread wake up
- [62b84896](https://github.com/zephyrproject-rtos/zephyr/commit/62b8489635464d011a6a2e03af77196984ab4204) doc: getting_started: add instructions to build on Clear Linux
- [78964517](https://github.com/zephyrproject-rtos/zephyr/commit/789645171378829376aea0e8f9fd1df5abb4dd5c) doc: cmake: Use proper dependencies
- [60c5540d](https://github.com/zephyrproject-rtos/zephyr/commit/60c5540dbf2ea2f0a013fdb57f5dfbd8fa35888a) doc: cmake: Conditionally add USES_TERMINAL to html targets
- [f789a728](https://github.com/zephyrproject-rtos/zephyr/commit/f789a728bbbf817387b3b6e4cfa982d82e265c55) doc: tests: Add test description and doxygen groups in timer
- [16155ad9](https://github.com/zephyrproject-rtos/zephyr/commit/16155ad93ae0dfb20460bcace396c6ae1812ee87) doc: windows: Clarify Python paths
- [e182dbc2](https://github.com/zephyrproject-rtos/zephyr/commit/e182dbc22e8b7c774e5df7f5e255aad336bd465d) doc: cmake: Enable out-of-tree builds
- [f84caef2](https://github.com/zephyrproject-rtos/zephyr/commit/f84caef220438e53b0a997ce03e76a58d104304a) doc: Makefile: Switch to Ninja as a generator
- [5c086dec](https://github.com/zephyrproject-rtos/zephyr/commit/5c086deccdaa25a2fafbbcfa9b71a650296c29e6) doc: fix doxygen error in ethernet.h
- [9af485ad](https://github.com/zephyrproject-rtos/zephyr/commit/9af485adf8ddbe72160f327cd2f9ca5565e9b028) doc: fix incorrect defgroup comment in Queue tests

Drivers (50):

- [8c2acab5](https://github.com/zephyrproject-rtos/zephyr/commit/8c2acab53a212738e9a5e013fb28aa3fd1a2cdc0) drivers: add i.MX I2C driver shim
- [0aedf8d2](https://github.com/zephyrproject-rtos/zephyr/commit/0aedf8d2c5ee7ed5ee97468291cc11b380e72350) drivers: console: Kconfig: Remove redundant 'default n' properties
- [505a8341](https://github.com/zephyrproject-rtos/zephyr/commit/505a83414e1b0691996800138b62684ccd91d679) drivers: gpio: nrf5: Fix GPIOTE channel use overlap
- [101d4936](https://github.com/zephyrproject-rtos/zephyr/commit/101d4936228714eefc621e307577726f50cd9349) drivers: serial: nrf: Use nrfx GPIO HAL to properly handle pins from P1
- [c8a21317](https://github.com/zephyrproject-rtos/zephyr/commit/c8a2131743e783f4df21fdfd0c70ccbe0ed8000c) drivers: serial: nrf: Adding missing baud rates to UART driver
- [9ac99a28](https://github.com/zephyrproject-rtos/zephyr/commit/9ac99a28c52b77ffa3746024a577e51fef00449a) drivers: gpio_gecko: Adapt driver for Silabs EFR32 MCUs
- [e9e8bce9](https://github.com/zephyrproject-rtos/zephyr/commit/e9e8bce91bb4ed503718459edd49d1289d5c6b43) drivers: serial: Adapt gecko uart driver for Silabs EFR32
- [8a528a79](https://github.com/zephyrproject-rtos/zephyr/commit/8a528a797f8f22673c506b83ced88be43256fb81) drivers: serial: add virtual uart driver for nsim
- [7449657e](https://github.com/zephyrproject-rtos/zephyr/commit/7449657e721dd3c957a93e49f155606743576213) drivers: serial: nrf: Adding UARTE driver for the nRFx family
- [f733da8d](https://github.com/zephyrproject-rtos/zephyr/commit/f733da8ded429768e84b4117ddf4d5c31467683a) drivers: serial: nrf: Adopting define for UART driver.
- [9107e3da](https://github.com/zephyrproject-rtos/zephyr/commit/9107e3dac8ce9434e20dfbdeb59afb7d7ddefcf1) drivers: usb: add support for USB OTG FS on STM32F7
- [5275a731](https://github.com/zephyrproject-rtos/zephyr/commit/5275a73169a1640fb876c22857989366abea717f) drivers: gpio: nrf: remove GPIO register structure definition
- [ac81eb0e](https://github.com/zephyrproject-rtos/zephyr/commit/ac81eb0ecae2c0caf41e1df4d58a3af6772f058b) drivers: gpio: nrf: remove GPIOTE register structure definition
- [21fd91e1](https://github.com/zephyrproject-rtos/zephyr/commit/21fd91e11e1e37e47c48db09c8555c7e852b72cb) drivers: sensors: adt7420: Add driver for ADT7420 Temperature Sensor
- [c90170c5](https://github.com/zephyrproject-rtos/zephyr/commit/c90170c5c5c519752d089ba7e50231c4cbff627b) drivers: wifi: simplelink: move files into a dedicated subdir
- [a3fb48c5](https://github.com/zephyrproject-rtos/zephyr/commit/a3fb48c5fd2071ec8e5f7464cb70043add248ab8) usb: webusb: Use struct string_desc instead of char array
- [44b7076c](https://github.com/zephyrproject-rtos/zephyr/commit/44b7076c22f2d333cf9f7ad6058c2dc2060ec3f3) usb: Correct include path
- [a19b469a](https://github.com/zephyrproject-rtos/zephyr/commit/a19b469ae37c45e1f52314aad29054f48ec7c4cb) usb: Cleanup code style for usb_device
- [59e9cd0f](https://github.com/zephyrproject-rtos/zephyr/commit/59e9cd0f13e6f2c28774c592c86c5eebff6ea820) usb: osdesc: Add MS OS Descriptors version 1 support
- [93dd1b99](https://github.com/zephyrproject-rtos/zephyr/commit/93dd1b99c2e9b513a9d84c4172b3965b8848d1ca) usb: rndis: Add MS OS v1 descriptors to RNDIS
- [d8da50a3](https://github.com/zephyrproject-rtos/zephyr/commit/d8da50a30de02f4c30304fa99c981f17525c26be) usb: rndis: Set subCompatibleID parameter for exact MS driver
- [65cbe9db](https://github.com/zephyrproject-rtos/zephyr/commit/65cbe9db5731e3b2b6131229550d8787d0e9e724) usb: tests: Add unit tests for MS OS Descriptors testing
- [5a9c069c](https://github.com/zephyrproject-rtos/zephyr/commit/5a9c069c838ccd885fb7d2a3bb425abc9e1d2d6f) usb: tests: Add testing os_desc feature
- [7b0e9d7c](https://github.com/zephyrproject-rtos/zephyr/commit/7b0e9d7c536f3e46b9413901e366493547388588) usb: composite: Add handling osdesc feature
- [c2fdfbb8](https://github.com/zephyrproject-rtos/zephyr/commit/c2fdfbb8350b0d60c887ad2db60d869bb141130d) usb: rndis: Use RFC 7042 Doc value for Host MAC
- [25afcc57](https://github.com/zephyrproject-rtos/zephyr/commit/25afcc574fb468e453dbd31ed777cbbe002ae75a) usb: device: Refactor vendor_handler
- [c8af08e5](https://github.com/zephyrproject-rtos/zephyr/commit/c8af08e5d4662207e1da237c9abc74595ca2a174) usb: osdesc: Use definition for string descriptor index
- [f0de6e06](https://github.com/zephyrproject-rtos/zephyr/commit/f0de6e06f8c756eb4916e28d5f81c83e50300fd9) drivers: serial: nrf: Serial driver modification to use DT
- [f8718758](https://github.com/zephyrproject-rtos/zephyr/commit/f8718758e592bcbfe93d2a4edf34a1f3efe9275d) include: drivers: gpio: Turn functions generic - esp32
- [5f443090](https://github.com/zephyrproject-rtos/zephyr/commit/5f44309018da4203af4628f6a0592c8ae671115d) drivers: timer: nrf: Fix expected_sys_ticks issue in case of k_busy_wait
- [32e6d0ca](https://github.com/zephyrproject-rtos/zephyr/commit/32e6d0ca879ddbbd31097c9ef75a257bf6a1f3f3) usb: set SN string descriptor at runtime
- [ecc891b2](https://github.com/zephyrproject-rtos/zephyr/commit/ecc891b296a196259fa39c050a685d42fecb4a56) drivers: Fix asserts in i.MX UART Driver
- [f5b91bad](https://github.com/zephyrproject-rtos/zephyr/commit/f5b91bad175feebfbe794bee3922cb87791b5c16) drivers: usb_dc_kinetis: fix gcc 7.3.1 warning
- [7fd3eb60](https://github.com/zephyrproject-rtos/zephyr/commit/7fd3eb60d97e645b8ae30e744597496885afada9) drivers: uart_ns16550: restore config UART_NS16550_PORT_1_PCI
- [a07d98a6](https://github.com/zephyrproject-rtos/zephyr/commit/a07d98a62fff0330fdb42d24e139c613a20c4905) drivers: flash: w25q: Fix typo
- [08547cbb](https://github.com/zephyrproject-rtos/zephyr/commit/08547cbb108c23403c49491565a0e8725d18484c) drivers: codec: APIs for Audio Codecs
- [51d17086](https://github.com/zephyrproject-rtos/zephyr/commit/51d170864805ca417e936bc9cfdf710df8642e8a) drivers: add i.MX PWM driver
- [d45f90e5](https://github.com/zephyrproject-rtos/zephyr/commit/d45f90e5486c1b639d28a777c12890b96a3746da) drivers: eth: mcux: Enable gPTP support
- [18d327c4](https://github.com/zephyrproject-rtos/zephyr/commit/18d327c4327b5f7ac4201513bd233a4dac394987) drivers: eth: mcux: Allow gPTP over VLAN
- [77e03fc8](https://github.com/zephyrproject-rtos/zephyr/commit/77e03fc8be96102f821b46b12b011930ac5bffbb) drivers: eth: mcux: Prioritize received PTP packets to high
- [42f51ef0](https://github.com/zephyrproject-rtos/zephyr/commit/42f51ef08d89200748054d424e0d4cb2df64d416) drivers: wifi: winc1500: Use offload_context instead of user_data.
- [a2ad4b2d](https://github.com/zephyrproject-rtos/zephyr/commit/a2ad4b2dd1c3a67fc683f110c0029672bb4f8e28) drivers: qmsi: Fix types and u32_t/uint32_t conflicts
- [f9cd4995](https://github.com/zephyrproject-rtos/zephyr/commit/f9cd4995fff6a4059c85b659fd7c38a6c77bbe5d) drivers/serial: ns16550: extend to support 4 ports
- [39db4f48](https://github.com/zephyrproject-rtos/zephyr/commit/39db4f48d794ee3ea37fd5930def06ff9b61ed30) drivers/ieee802154: Fix settings channel/tx power in uart pipe driver
- [48de3ec6](https://github.com/zephyrproject-rtos/zephyr/commit/48de3ec61647a452c42852bfbf6545ef461eef06) drivers: usb_dc_stm32: Add OTG HS full-speed PHY support
- [1f4e8d67](https://github.com/zephyrproject-rtos/zephyr/commit/1f4e8d679b7f8b961a638c6fc3ed64fdefb87e02) usb_dc_stm32: Fix FS mode
- [97bc5abe](https://github.com/zephyrproject-rtos/zephyr/commit/97bc5abedfb8a53006118a9b54229e55ea0c5f5b) drivers: i2c: stm32: add support for STM32F7
- [6c49ce16](https://github.com/zephyrproject-rtos/zephyr/commit/6c49ce16c22ef36032a8c708706c21a3c2967e26) drivers: i2c: stm32: Kconfig: Remove redundant 'default n' properties
- [e189f590](https://github.com/zephyrproject-rtos/zephyr/commit/e189f590316c2fe76571230b1c1f48402e023634) drivers: wifi: simplelink: enable Fast Connect policy
- [18226b11](https://github.com/zephyrproject-rtos/zephyr/commit/18226b1100bea2077f2d42f13152a7395b691aed) drivers: serial: Add power management to nRF UART driver

External (12):

- [e634b25f](https://github.com/zephyrproject-rtos/zephyr/commit/e634b25f20c698baffe33ed67b6183763f490f0b) ext: gecko: Add Silabs Gecko SDK for EFR32FG1P SoCs
- [7689e9dc](https://github.com/zephyrproject-rtos/zephyr/commit/7689e9dc3e499c4c3e5b963a68f035be2c43f777) ext: Integrate Silabs EFR32FG1P Gecko SDK into Zephyr
- [cee31be6](https://github.com/zephyrproject-rtos/zephyr/commit/cee31be6ff36f9a9ab662e1fea261fed4f326fed) ext: Import Atmel SAMD20 header files from ASF library
- [a60af5c1](https://github.com/zephyrproject-rtos/zephyr/commit/a60af5c1ffcaccd8259628f4825d2d263931894b) ext: lib: crypto: Add generic mbedTLS config file
- [f1421b96](https://github.com/zephyrproject-rtos/zephyr/commit/f1421b96dfb78d3d0b5141bfa761ae7c98f68c7a) ext: lib: crypto: Make config-tls-generic.h default config
- [31616178](https://github.com/zephyrproject-rtos/zephyr/commit/31616178403cbdb91bf61c50b8b10411049bfa47) ext: mcux: Add a script to import new versions of mcux
- [57fbc668](https://github.com/zephyrproject-rtos/zephyr/commit/57fbc668820657b242473649490fe4d8a2627079) ext: hal: altera: Add ifdef protection for __LINUX_ERRNO_EXTENSIONS__
- [b7a68fbb](https://github.com/zephyrproject-rtos/zephyr/commit/b7a68fbbe5955b0b8ca56fa3324452bee5a77bdb) ext: hal: nxp: mcux: Fix ethernet timestamping driver
- [77150196](https://github.com/zephyrproject-rtos/zephyr/commit/7715019679ef0a60be9f0bf45d3603d1bc9e3e2e) ext: hal: nxp: mcux: Fix PTP event packet type check
- [8e304696](https://github.com/zephyrproject-rtos/zephyr/commit/8e304696e47d1bc3257dc6311a977e5ed8b0e5a6) ext: hal: nxp: mcux: Enable enhanced buffer desc mode if needed
- [5d5d02b1](https://github.com/zephyrproject-rtos/zephyr/commit/5d5d02b1ecff9b081432438f08bc61b8ab5851bf) ext: hal: nxp: mcux: Update README file
- [5f92b3b7](https://github.com/zephyrproject-rtos/zephyr/commit/5f92b3b740fdea8d63fecb3b6271c34d111d842a) ext: hal: cmsis: Remove headers from old CMSIS import

Firmware Update (1):

- [051c1f5f](https://github.com/zephyrproject-rtos/zephyr/commit/051c1f5fd61c81899d88d106088e2551b3232a77) subsys: mgmt: Fix broken OTA firmware update

Kernel (12):

- [e67720bb](https://github.com/zephyrproject-rtos/zephyr/commit/e67720bbf23fc5b44f69abbd6498a4d458bddea6) syscalls: Scan multiple folders to build complete syscall list
- [1d9bb5d7](https://github.com/zephyrproject-rtos/zephyr/commit/1d9bb5d793b0c00f381f1b74976332930a6df18f) kernel: minor improve in SYS_CLOCK_HW_CYCLES_PER_SEC help description
- [47a9f9a6](https://github.com/zephyrproject-rtos/zephyr/commit/47a9f9a61720a0c9c4985be09bbb208b5cefb4ed) kernel: thread: Exclude deprecated function from lcov
- [e74d85d8](https://github.com/zephyrproject-rtos/zephyr/commit/e74d85d81666068464f180a31875392eb4ba9b9f) kernel: thread: Simplify k_thread_foreach conditional inclusion
- [d9c37d6c](https://github.com/zephyrproject-rtos/zephyr/commit/d9c37d6cfc13b87d6eeef884dbddc2f17262e314) kernel: idle: Define _sys_soc_resume functions conditionally
- [89f87ec5](https://github.com/zephyrproject-rtos/zephyr/commit/89f87ec56e24e68ca1dfad76aac2c66afc892e52) syscalls: pull in arch/cpu.h
- [7f4d0069](https://github.com/zephyrproject-rtos/zephyr/commit/7f4d00695929e7115529aa533b3c4b4ea13d5cf0) kernel: fix errno access for user mode
- [2fe998cd](https://github.com/zephyrproject-rtos/zephyr/commit/2fe998cdef775b58115f6c3e0a44ba4f15e03f45) kernel: Deprecate sys_clock_us_per_tick variable.
- [96aa0d21](https://github.com/zephyrproject-rtos/zephyr/commit/96aa0d21337caec56814c5efb8aa4212378a4d37) kernel: Use accurate tick/ms conversion if clock rate is set at runtime
- [a698e84a](https://github.com/zephyrproject-rtos/zephyr/commit/a698e84a76fd361f52409c6d4237048fe09fb86d) userspace: adjust syscall generation scripts
- [573f32b6](https://github.com/zephyrproject-rtos/zephyr/commit/573f32b6d202be7fed81ded531ed96645e2aae97) userspace: compartmentalized app memory organization
- [8777ff13](https://github.com/zephyrproject-rtos/zephyr/commit/8777ff1304fd7c07f35a7aca655b92d0e98a277b) Fix compile errors related to errno.h

Libraries (11):

- [7bc39646](https://github.com/zephyrproject-rtos/zephyr/commit/7bc396465fa44714bce0fd621daf177cdcac4ce5) lib: json: add helper macro for array of array
- [e6f4f623](https://github.com/zephyrproject-rtos/zephyr/commit/e6f4f623b7d24367705ae622860e1a6cca1e0e19) libc: minimal: Fix handling of floating point exponent
- [96ea7ab7](https://github.com/zephyrproject-rtos/zephyr/commit/96ea7ab7d1ee327bce1bc7d5a5fcee6dc96f7df1) libc: minimal: Fix handling of %f conversion specifiers for inf & nan
- [409c9e75](https://github.com/zephyrproject-rtos/zephyr/commit/409c9e751f1e2c2972d8f7a83e28ea2de7c1b524) libc: minimal: Fix support for -nan
- [e66da3f9](https://github.com/zephyrproject-rtos/zephyr/commit/e66da3f9e0828a5bcabee97c83a89048d05cc522) libc: minimal: Add support for %F conversion specifiers
- [9aebe8b4](https://github.com/zephyrproject-rtos/zephyr/commit/9aebe8b466494805f2b15e6810d9485e3f21180a) lib: json: Fix warning when building with newlib
- [16ff8ca2](https://github.com/zephyrproject-rtos/zephyr/commit/16ff8ca2c2aaade5b7658ccb594b9d52e1263e63) libc: newlib: Enable extended linux errno defines
- [e7ae7334](https://github.com/zephyrproject-rtos/zephyr/commit/e7ae7334dbc8276d7e648762982839361a7da5fc) lib/crc: Add CRC32 support
- [6a8649f8](https://github.com/zephyrproject-rtos/zephyr/commit/6a8649f806d90bc8e6d820316ac4d813600f7122) libc: minimal: add malloc functions
- [bc94cc18](https://github.com/zephyrproject-rtos/zephyr/commit/bc94cc1832702d22726e03e26545b89621d9163e) libc: minimal: add console system calls
- [12e6aadc](https://github.com/zephyrproject-rtos/zephyr/commit/12e6aadcb0a9f87f89e48ac47aa08b8744fbe55a) lib: newlib: add read/write syscalls

Logging (18):

- [4aaeaaaf](https://github.com/zephyrproject-rtos/zephyr/commit/4aaeaaaf2eb84b10b3126236b78d4abbac116b61) logging: Provide 8 and 9 parameter logging macros
- [f10cbe5e](https://github.com/zephyrproject-rtos/zephyr/commit/f10cbe5ee9e22126846cfdac05e3ffc268b7c898) logging: Print 7, 8 or 9 parameter macros properly
- [5cac6238](https://github.com/zephyrproject-rtos/zephyr/commit/5cac62387a8063fdd46584021c3c7e6b501219a3) logging: Avoid compile warning because of wrong type
- [e854dd00](https://github.com/zephyrproject-rtos/zephyr/commit/e854dd00699840431e254afc2db4e47c6f307076) logging: log_output: Data lost because of uninitialized variable
- [67d69873](https://github.com/zephyrproject-rtos/zephyr/commit/67d6987324fe346748929830497b0b759f72b037) logging: Fix fail when log locally disabled
- [d731e539](https://github.com/zephyrproject-rtos/zephyr/commit/d731e539ce83294245d2f65869a0633930583f1d) logging: Handle 0 Hz frequency in log_output
- [77b44df8](https://github.com/zephyrproject-rtos/zephyr/commit/77b44df86a21a4a68923e576c483321243725c17) logging: Ensure constant side effects of log API
- [6b01c899](https://github.com/zephyrproject-rtos/zephyr/commit/6b01c899354f2d7e9211007947567f20263ee4e0) logging: Add log initialization to system startup
- [1ba542c3](https://github.com/zephyrproject-rtos/zephyr/commit/1ba542c352323688a8e4d1511e9f824c94df5fc7) logging: Logger to wake up logs processing thread
- [000aaf96](https://github.com/zephyrproject-rtos/zephyr/commit/000aaf96fb72cff9e9bed4967261f149d480f68e) logging: Add internal thread for log processing
- [86b5edc4](https://github.com/zephyrproject-rtos/zephyr/commit/86b5edc4d09afc60d41ce6d1ed475d8776c888bc) logging: Internal processing thread enabled by default
- [927c1470](https://github.com/zephyrproject-rtos/zephyr/commit/927c1470da0ef640fb05d5325e6d64650571a4ac) logging: Internal logger headers cleanup
- [c12fa740](https://github.com/zephyrproject-rtos/zephyr/commit/c12fa740a254e5515a46e5437c9e1d263dfe99f0) logging: Remove log.h including in headers limitation
- [83db9ad7](https://github.com/zephyrproject-rtos/zephyr/commit/83db9ad7530d759eaff586bb4295079689d3814b) logging: Make prefixes the same length
- [7fe2c3b1](https://github.com/zephyrproject-rtos/zephyr/commit/7fe2c3b14fde28419dbd0e877c98c0ccf576d3da) logging: Fix static log filtering
- [fa90fdc4](https://github.com/zephyrproject-rtos/zephyr/commit/fa90fdc42ce44854da8c2618477506f82fae8614) logging: Macro argument evaluated when enabled
- [1bfcea24](https://github.com/zephyrproject-rtos/zephyr/commit/1bfcea244bcd9eec81f6a37929d5ac6fb6225c7c) subsys: logging: fix trigger threshold corner case
- [12926094](https://github.com/zephyrproject-rtos/zephyr/commit/12926094589aaafaa50a3d4a4b25994519364b86) logging: Use vsnprintk instead of vsnprintf

Maintainers (2):

- [3a988a5e](https://github.com/zephyrproject-rtos/zephyr/commit/3a988a5e22fa460ebdf9cd6e67440861a107c343) CODEOWNERS: Update entry for sensor drivers
- [880f21fb](https://github.com/zephyrproject-rtos/zephyr/commit/880f21fbb3396a4debdef8368f2c507d5660af57) codeowners: Assign doc CMake and scripts to me

Miscellaneous (1):

- [5c3d5660](https://github.com/zephyrproject-rtos/zephyr/commit/5c3d5660eff827b68f64c1df4f6f34343164298e) shell: Fix command completion logic

Networking (59):

- [cb00061c](https://github.com/zephyrproject-rtos/zephyr/commit/cb00061cbef9b2fc0d3c992e2c3285dd07313264) net: dhcpv4: Use less parameters in debug print
- [21d6e302](https://github.com/zephyrproject-rtos/zephyr/commit/21d6e302f670ccff702d6d785b95637555ea9e4d) net: lwm2m: Fix warning when building with newlib
- [00a69bf9](https://github.com/zephyrproject-rtos/zephyr/commit/00a69bf9bb5865eb215920f59631c305ae48a22e) net: socket: Add switch to enable TLS socket option support
- [a7c698d9](https://github.com/zephyrproject-rtos/zephyr/commit/a7c698d936cf593901f6e8cd21223c01ba93780c) net: tls: Add TLS context allocation/deallocation
- [ccdc6a6b](https://github.com/zephyrproject-rtos/zephyr/commit/ccdc6a6bdf203c8e778541d38609cbe16134a56c) net: tls: Add mbedTLS entropy source
- [2d4815dd](https://github.com/zephyrproject-rtos/zephyr/commit/2d4815dd159830992b171e485155bd15faf72f04) net: tls: Add mbedTLS logging
- [d08fd07f](https://github.com/zephyrproject-rtos/zephyr/commit/d08fd07f606227cd2b63d0e57dc3c43d1fee25b7) net: tls: Handle TLS handshake
- [07f1a1fe](https://github.com/zephyrproject-rtos/zephyr/commit/07f1a1fe2cb886b83396986d70f9f63a7eefe257) net: tls: Handle TLS socket send and recv
- [47f90887](https://github.com/zephyrproject-rtos/zephyr/commit/47f908872dde88a2d14225e80575b82ff7b04608) net: tls: Implement poll with support for mbedTLS pending data
- [f25baebf](https://github.com/zephyrproject-rtos/zephyr/commit/f25baebf2726fbc1f0aa5c3df095f1d12fbf7d09) net: samples: Add TLS support to http_get and big_http_download samples
- [53c5058d](https://github.com/zephyrproject-rtos/zephyr/commit/53c5058d6e0129d01e68b6965e2530d2733c8cba) net: ip: kconfig: Simplify NET_RX_STACK_RPL definition
- [eedb8a7b](https://github.com/zephyrproject-rtos/zephyr/commit/eedb8a7bd89b253096ecd245a2a7b5b1cf45d613) net: sockets: Make poll() call threadsafe by avoiding global array
- [56e240e5](https://github.com/zephyrproject-rtos/zephyr/commit/56e240e528ca90a9fd2bf00a6cbd1c40ec8036da) net: lwm2m: make lwm2m_engine_exec_cb_t more generic
- [538d3418](https://github.com/zephyrproject-rtos/zephyr/commit/538d3418fdfba537bc96f5484e52809325d1b27d) net: lwm2m: introduce user-code callbacks for obj create/delete
- [ce48f18d](https://github.com/zephyrproject-rtos/zephyr/commit/ce48f18d10aaf61d4c33de4cdc0138e7237c165a) net: lwm2m: use ARRAY_SIZE to calculate # of options
- [3f53e6d1](https://github.com/zephyrproject-rtos/zephyr/commit/3f53e6d1d8158f83df4509bb9af93b67f0d84d51) net: lwm2m: read past not supported TLV resources
- [a9c684c6](https://github.com/zephyrproject-rtos/zephyr/commit/a9c684c6e657aa33dce00b6782bb10a02416a514) net: openThread: Fix MTD build
- [0e626f5e](https://github.com/zephyrproject-rtos/zephyr/commit/0e626f5ef59ba0250f7dae18a43e846b66d1c497) net: openthread: Add NETWORKNAME and XPANID config
- [0251a9f1](https://github.com/zephyrproject-rtos/zephyr/commit/0251a9f14016d337f37a6be45fa562e538724ff3) net: ipv6: Fix NA debug print
- [40f74366](https://github.com/zephyrproject-rtos/zephyr/commit/40f743669b135005fd6043f9b35d9e398580214b) net: eth: Convert to use callbacks to query stats
- [1b376028](https://github.com/zephyrproject-rtos/zephyr/commit/1b37602859475667c0ccc751d706c904615e14e5) net: getaddrinfo: ai_state no longer global
- [a74137f6](https://github.com/zephyrproject-rtos/zephyr/commit/a74137f665d502e8eab1278315f975133dcbfe59) net: getaddrinfo: use memory allocation for res
- [4670214c](https://github.com/zephyrproject-rtos/zephyr/commit/4670214c268f0d4f1804935c61dad21bf6d91f97) net: gptp: Fix unsigned value comparison
- [27fef49d](https://github.com/zephyrproject-rtos/zephyr/commit/27fef49d17c741b4c98681b0846740d930e46b90) net: gptp: Check overflow of log msg interval
- [dfa3f10b](https://github.com/zephyrproject-rtos/zephyr/commit/dfa3f10b26673a2609c0f28f5fc1e579dc2d027e) net: gptp: Add comment for falling through case
- [7f0432a1](https://github.com/zephyrproject-rtos/zephyr/commit/7f0432a114227da52a6dca456e33e3cbe861c4ff) net: utils: Check null pointer when parsing IPv6 address
- [408a5806](https://github.com/zephyrproject-rtos/zephyr/commit/408a580644e1f15a0d8ff7f5854fbe03651ba57c) net: ethernet: mgmt: Fix Qav deltaBandwith check
- [3fafe4f9](https://github.com/zephyrproject-rtos/zephyr/commit/3fafe4f9adbbfa91fbff1f588391a80b6443707e) net: ipv6: Handle large IPv6 packets properly
- [58cc7532](https://github.com/zephyrproject-rtos/zephyr/commit/58cc75327be5e2ad462579c50f640fbe788e1936) net: getaddrinfo: Make availability depend on CONFIG_DNS_RESOLVER
- [8e8dc1c5](https://github.com/zephyrproject-rtos/zephyr/commit/8e8dc1c528bd63fceb602bba22424239c6979cdb) net: relax net_ip.h check
- [b19cb207](https://github.com/zephyrproject-rtos/zephyr/commit/b19cb207cb2b5d1b54f8af7ce8f8da4c6da231a5) net: if: Add promiscuous mode set / unset functionality
- [bf9bae58](https://github.com/zephyrproject-rtos/zephyr/commit/bf9bae58d1741089a55f2074a94f15a82776be1b) net: eth: Add generic promiscuous mode support
- [3f9c7bd1](https://github.com/zephyrproject-rtos/zephyr/commit/3f9c7bd1598de04b97a072f1c3bd8b8e49da7354) net: Add promiscuous mode support
- [9135b175](https://github.com/zephyrproject-rtos/zephyr/commit/9135b175352717f3c592b0328e20f9b4afbe7350) net: eth: native_posix: Return proper error code from linux
- [af44d7c2](https://github.com/zephyrproject-rtos/zephyr/commit/af44d7c2e879e4e953b566e32ae2b4134a76ef91) net: eth: native_posix: Add promiscuous mode support
- [36ab41df](https://github.com/zephyrproject-rtos/zephyr/commit/36ab41df798e93e0ff273e05eb5219f9ac015970) net: shell: Print information about promiscuous mode
- [fbbef6f4](https://github.com/zephyrproject-rtos/zephyr/commit/fbbef6f43644e2b5346f74e2b6048312b2eb7285) net: stats: Simplify periodic statistics printing
- [df4325a9](https://github.com/zephyrproject-rtos/zephyr/commit/df4325a9b80a606744c08bf7644403c887a1cff2) net/ipv4: Remove useless proto field setting in ipv4 header
- [a38dc091](https://github.com/zephyrproject-rtos/zephyr/commit/a38dc0914f46f10b3580aed409a663e2103f12e7) net/ipv4: Remove ifdefs and use IS_ENABLED instead
- [abf68bc5](https://github.com/zephyrproject-rtos/zephyr/commit/abf68bc5ea5fa7aaccd922acfa17a11a37cd0e5e) net/ipv4: Remove useless return value
- [b89f127f](https://github.com/zephyrproject-rtos/zephyr/commit/b89f127f01900cf8ad09adae2f4a3daef24d5668) net/icmpv4: Use generic IPv4 relevantly
- [be6f59d3](https://github.com/zephyrproject-rtos/zephyr/commit/be6f59d32233f755750cc0f19f132bd4cc932368) net/icmpv4: Checksum is always set to 0 prior to being calculated
- [ea5610af](https://github.com/zephyrproject-rtos/zephyr/commit/ea5610af0a1758bd875aaa84c0c8e8eb711fe3d4) net/icmpv4: src ll address does not need to be set
- [9bb56cc6](https://github.com/zephyrproject-rtos/zephyr/commit/9bb56cc6b911fdb6c8094726b0a1c380175a97b2) net/icmpv4: Rename static function with icmpv4_ prefix
- [9b8c83f4](https://github.com/zephyrproject-rtos/zephyr/commit/9b8c83f44ad940a58392ab2018bc4a4446212a64) net: Avoid holes in structs
- [5ebc86bd](https://github.com/zephyrproject-rtos/zephyr/commit/5ebc86bdc68dbb76092b92e30b90ca2e42c281c6) net/ethernet: A device driver api uses struct device *dev
- [9c5725a6](https://github.com/zephyrproject-rtos/zephyr/commit/9c5725a69d2e49de2e4a17529606a0d52a3676c9) net/ethernet: Pre-assigned declaration always comes first
- [a691cc81](https://github.com/zephyrproject-rtos/zephyr/commit/a691cc8159cb3b27cc8e6b6d850bcb8853145c83) net: ipv6: Fix memory leak caused by NS request failure
- [d09cbcaf](https://github.com/zephyrproject-rtos/zephyr/commit/d09cbcaf6fc9cc23b19067c3e5823e6dde6cd8e1) net: tls: Add credential management subsystem
- [11f7abce](https://github.com/zephyrproject-rtos/zephyr/commit/11f7abcefdf19737478937598e4e279631e9d90e) net: socket: Define getsockopt() and setsockopt()
- [f959b5c1](https://github.com/zephyrproject-rtos/zephyr/commit/f959b5c164b458358cdcc7d84692c56743043a87) net: tls: Add TLS socket options placeholder
- [48e05557](https://github.com/zephyrproject-rtos/zephyr/commit/48e055577b575fbc808cd064328022fa2fa3bf6c) net: tls: Add socket option to select TLS credentials
- [a3edfc25](https://github.com/zephyrproject-rtos/zephyr/commit/a3edfc25632f70bb5eec7db9df15941de24b4c5c) net: tls: Set TLS credentials in mbedTLS
- [91531772](https://github.com/zephyrproject-rtos/zephyr/commit/915317724c7a49a6125230b555150544b2cc63f0) net: tls: Add socket option to set TLS hostname
- [11c24c85](https://github.com/zephyrproject-rtos/zephyr/commit/11c24c855d2b45a0cbad1818136feab0f57f469e) net: tls: Add socket option to select ciphersuites
- [3d560e14](https://github.com/zephyrproject-rtos/zephyr/commit/3d560e14ac4d4cda482f52de26aa390acf0c94dc) net: tls: Add socket option to read chosen ciphersuite
- [7826228d](https://github.com/zephyrproject-rtos/zephyr/commit/7826228deff9d2113a316c72d9c77392cde060c2) net: tls: Add socket option to set peer verification level
- [50631b35](https://github.com/zephyrproject-rtos/zephyr/commit/50631b350131185e3ce9eeec0864d95f6533692f) net: samples: Add CA certificates to http_get and big_http_download
- [29b65859](https://github.com/zephyrproject-rtos/zephyr/commit/29b65859b158fd24122ecf6e7ac077ef9e423406) net: samples: Add TLS support to socket echo_client/echo_server

Samples (36):

- [00681512](https://github.com/zephyrproject-rtos/zephyr/commit/00681512809c929e152bef7ceb53725c47e55a4b) samples: net: gptp: Documentation fixes
- [ff0950a9](https://github.com/zephyrproject-rtos/zephyr/commit/ff0950a940cd5a2267c0a7aaa37193c47951f9b1) samples: net: Fix echo_client/echo_server TLS config files
- [92c1c2a2](https://github.com/zephyrproject-rtos/zephyr/commit/92c1c2a24b0c0591b5396cb292db1a5dd727664a) samples: sensor: adt7420: Add ADT7420 sample application
- [13b160b0](https://github.com/zephyrproject-rtos/zephyr/commit/13b160b0f5add21276eca390ae1d41c1f980aca6) samples: net: Make echo_client/echo_server use generic mbedTLS config
- [170ca38b](https://github.com/zephyrproject-rtos/zephyr/commit/170ca38b75079e743a57d262dfae41af731952ef) samples: mesh: boards: nrf52: upgrade to pass PTS test
- [c58f102c](https://github.com/zephyrproject-rtos/zephyr/commit/c58f102c90c48d0c65627af1981e7cbff548a312) samples: mesh: boards: nrf52: improved vendor model
- [06f69b5c](https://github.com/zephyrproject-rtos/zephyr/commit/06f69b5c64266ad3e4cfd48391368420c08d015f) samples: mesh: improved code readability & remove redudancy
- [2708ce56](https://github.com/zephyrproject-rtos/zephyr/commit/2708ce561d4f1d71a096f8e235a48f2704066762) samples: mesh: boards: nrf52: randomize publishers TID on boot
- [00cd491f](https://github.com/zephyrproject-rtos/zephyr/commit/00cd491ffe4dab2c7d2f4759bfb1ce5100c52f99) samples: mesh: boards: nrf52: modifications as per 3.3.2.2.3
- [460c5854](https://github.com/zephyrproject-rtos/zephyr/commit/460c5854063f3ae217a386fdfd379784b1e1075e) samples: mesh: boards: nrf52: edit struct for gen. level
- [b8b94280](https://github.com/zephyrproject-rtos/zephyr/commit/b8b94280b9e4bf412d435049befa7ee99409d214) samples: mesh: boards: nrf52: avoid responding to wrong messages
- [ed72015d](https://github.com/zephyrproject-rtos/zephyr/commit/ed72015dbe8983627a740021bbfd9ecedacd24c5) samples: console: add print statements for user
- [cfd5c9b4](https://github.com/zephyrproject-rtos/zephyr/commit/cfd5c9b43dd2cf18b026848b4d9ffc612c3456cb) samples: nats: Fix warning when building with newlib
- [afad09db](https://github.com/zephyrproject-rtos/zephyr/commit/afad09dba6e052143eb1aee041e4c0e0585fe047) samples: boards: nrf52: Refactor power_mgr app code
- [8b8198b5](https://github.com/zephyrproject-rtos/zephyr/commit/8b8198b58f6fbe8f93027817991adb22b9762780) samples: mesh_demo: Fix  Fix warning when building with newlib
- [c8b114f2](https://github.com/zephyrproject-rtos/zephyr/commit/c8b114f25d646cf763224bf6190a80c3fb0b7454) samples: exclude socket samples on esp32
- [354e138f](https://github.com/zephyrproject-rtos/zephyr/commit/354e138f019e732e9723392c2cd4c195347df57a) samples: webusb: Reformat README txt to rst
- [3612802b](https://github.com/zephyrproject-rtos/zephyr/commit/3612802b955790aae7e5fc2a6111d838edf3ffe4) samples: webusb: Change webusb app repository name
- [38590a9a](https://github.com/zephyrproject-rtos/zephyr/commit/38590a9a4c62becc39e31d86db74c030bbb4b142) samples: net: wpanusb: split cc2520 settings from prj.conf
- [bfcc1cfb](https://github.com/zephyrproject-rtos/zephyr/commit/bfcc1cfb8793ea1065412987435aa7cf6296d899) samples: net: wpanusb: add TI CC1200 overlay config
- [15d46ddb](https://github.com/zephyrproject-rtos/zephyr/commit/15d46ddb87757e043cad688ae832182b638701c3) samples: usb: wpanusb: add MCR20A overlay config
- [7df65c15](https://github.com/zephyrproject-rtos/zephyr/commit/7df65c15d6c677fc6cac5a14f92202b8efb622a5) samples: usb: wpanusb: update README to rst format
- [8fe9f5b4](https://github.com/zephyrproject-rtos/zephyr/commit/8fe9f5b4f8162dc515f4bad97971c092544b9704) samples: net: wpanusb: fix sanitycheck
- [d370391e](https://github.com/zephyrproject-rtos/zephyr/commit/d370391e2ee46c6871af9bcbe130a591529dec26) samples: Add colibri_imx7d_m4 config in blink_led
- [e30c3096](https://github.com/zephyrproject-rtos/zephyr/commit/e30c3096b2ae708bc8d4a2d4905ee9b206f78ce1) samples: net: gptp: Add support for FRDM-K64F board
- [29a757a8](https://github.com/zephyrproject-rtos/zephyr/commit/29a757a814097ca867276f28f0b806ef322b4278) samples: wpanusb: Remove old dead code
- [4208642a](https://github.com/zephyrproject-rtos/zephyr/commit/4208642a536235477019b802f313b9802d16f2c9) samples: fix u32_t type usage
- [7b8b09bd](https://github.com/zephyrproject-rtos/zephyr/commit/7b8b09bde48110acdd8a43ac12796d9c937ffd30) samples: net: Explicitly ignore socket close return value
- [7479cc2e](https://github.com/zephyrproject-rtos/zephyr/commit/7479cc2ee844abb5e0ea9df9e7cf614fc50ebba3) samples: net: Fix incorrect use of ipv4 in ipv6 branch
- [2807e5c1](https://github.com/zephyrproject-rtos/zephyr/commit/2807e5c1c6cba4de581796f32fc4fcf6247be1e5) samples: net: echo_server: Fix building of echo replies
- [72f75e52](https://github.com/zephyrproject-rtos/zephyr/commit/72f75e52e1e41ada8ebf3da2e35479036ba8d7e4) samples: net: echo-server: Add overlay config support
- [c5095797](https://github.com/zephyrproject-rtos/zephyr/commit/c5095797b9b134cabccbfa1b05e92a46f9967915) samples: net: Add promiscuous mode application
- [af347795](https://github.com/zephyrproject-rtos/zephyr/commit/af34779510e8334cf0bbac92df77c6c73bbe74ae) samples: net: tp: Avoid compiler warning
- [6c30f595](https://github.com/zephyrproject-rtos/zephyr/commit/6c30f5955eba2b47fc9d0b7103a17238ef89316e) samples: net: Fix incorrect error check in echo_server
- [a1594472](https://github.com/zephyrproject-rtos/zephyr/commit/a1594472f20ce9336251adc452041a41133876f5) samples: net: echo-client: Add overlay config support
- [9a68fea9](https://github.com/zephyrproject-rtos/zephyr/commit/9a68fea98ca09d4edf746cf6367cce146450ac0a) samples: boards: quark_se_c1000: Do not enter LPS states on test exit

Scripts (6):

- [1952c56e](https://github.com/zephyrproject-rtos/zephyr/commit/1952c56e7d256d64702d8849c0cce7ad1222b70a) scripts: west: add nsim runner
- [f6bf8977](https://github.com/zephyrproject-rtos/zephyr/commit/f6bf8977808ccd02963fe3f0ceed796922038cb6) kconfiglib: Add preprocessor and two warnings
- [033f10d2](https://github.com/zephyrproject-rtos/zephyr/commit/033f10d272774672420b5c80916379801b629f02) scripts: Print results from filter-known-issues.py
- [9c2f681b](https://github.com/zephyrproject-rtos/zephyr/commit/9c2f681bc0ed498da5782212856343a776f7fe82) scripts: filter-known-issues: Add extra newline
- [953cc124](https://github.com/zephyrproject-rtos/zephyr/commit/953cc12464daedb5703797e241fc75cf55b7e9f5) kconfiglib: Fix paths for gsource'd files in the documentation
- [353acf4a](https://github.com/zephyrproject-rtos/zephyr/commit/353acf4aae63cead7c02e214a39a768dd525bc28) gen_syscalls.py: do not output data to stdout

Testing (40):

- [22ea79db](https://github.com/zephyrproject-rtos/zephyr/commit/22ea79db70ad311a8d0d2fd8cb083d57082efbef) tests: pending: Add description and RTM links
- [3e1c0bd3](https://github.com/zephyrproject-rtos/zephyr/commit/3e1c0bd38649889d7a31ac475fcacac589877a6e) tests: kernel: Add description and doxygen groups for workq
- [c6c81107](https://github.com/zephyrproject-rtos/zephyr/commit/c6c811072f5c70a816f2512cad824296cb9e4c29) tests: kernel: Add description and group tests for doxygen
- [8317e366](https://github.com/zephyrproject-rtos/zephyr/commit/8317e366a8a6182079ae2781a0e9163023f733fe) tests: sprintf: Add inf/nan testing for %{e,E,g,G}
- [70944e83](https://github.com/zephyrproject-rtos/zephyr/commit/70944e8375960394fd0f4b97cdc1606ae1cb67e5) tests: boards: intel_s1000_crb: Fix build error.
- [9ad36e71](https://github.com/zephyrproject-rtos/zephyr/commit/9ad36e7145f5caf7cb8e9e6ba9826ff7cc0d858c) tests: net: arp: Increase network buffer counts
- [02addfff](https://github.com/zephyrproject-rtos/zephyr/commit/02addfff50f936af41dfc71ab2d6140ace86f455) tests: poll: Add description and RTM links
- [25966c84](https://github.com/zephyrproject-rtos/zephyr/commit/25966c840696009e923c338f58124793cf64106c) tests: semaphore: Add description for semaphore tests
- [5b8e4ae4](https://github.com/zephyrproject-rtos/zephyr/commit/5b8e4ae4df378d0da32ce36266246fb530a6309d) tests: kernel: init: Add description and RTM links
- [cf71938a](https://github.com/zephyrproject-rtos/zephyr/commit/cf71938aa1633ff589768ddcb1a0476765e51f0e) tests: net: tcp: Use correct network interface for sending
- [5d1b57ff](https://github.com/zephyrproject-rtos/zephyr/commit/5d1b57ff9d08b47942c750a92c0af413d02c7c5c) tests: Add colibri_imx7d_m4 config in pwm_api
- [bffae854](https://github.com/zephyrproject-rtos/zephyr/commit/bffae85488eba17fe18dcab4b2d2f56a68eacdd2) tests: kernel: Add description for common and interrrupt
- [cf6a8708](https://github.com/zephyrproject-rtos/zephyr/commit/cf6a8708632e537cd24a34ff72628135b2e80ed3) tests: net: udp: Increase network buffer counts
- [934c8eae](https://github.com/zephyrproject-rtos/zephyr/commit/934c8eae459340db6655e31a2955671240dacebb) tests: spinlock: Add description and doxygen groups
- [8cdb5d5d](https://github.com/zephyrproject-rtos/zephyr/commit/8cdb5d5d24b98c3f50d554a51c1e4fc99b946429) tests: nffs: fixed types
- [19666a9b](https://github.com/zephyrproject-rtos/zephyr/commit/19666a9beb1f6ee5741ec1f996cde0361335bb77) tests: fix u32_t type usage
- [34ee20a3](https://github.com/zephyrproject-rtos/zephyr/commit/34ee20a375e11bccdc0ca4c656a46cdb068f9290) tests: sleep: Add description and RTM links
- [d35d8e93](https://github.com/zephyrproject-rtos/zephyr/commit/d35d8e9310fba5757409d3ce6511e995b56a5201) tests: Add test for NATIVE_EXIT_TASK
- [8891beaf](https://github.com/zephyrproject-rtos/zephyr/commit/8891beaf8473008a02cc7f5b2a4cc89af2e92266) tests: posix: add test for pthread_key
- [49f5f5bc](https://github.com/zephyrproject-rtos/zephyr/commit/49f5f5bc23b4edf47247b9eafbb981504418a4b5) tests: power: power_states: Define power states as per architecture
- [05434d1b](https://github.com/zephyrproject-rtos/zephyr/commit/05434d1bb6f91d61ccf053b1aac411b897c049f9) tests: power: multicore: Fix the idle synchronization issue
- [770eba36](https://github.com/zephyrproject-rtos/zephyr/commit/770eba360ff0d020b37025d4029423090646debe) tests: power: multicore: Fix power state entry for LMT
- [81a2c4b8](https://github.com/zephyrproject-rtos/zephyr/commit/81a2c4b8ff58701bb98873a6163ff039cc8e6c5b) tests: sleep: Fix _TICK_ALIGN correction.
- [913507a2](https://github.com/zephyrproject-rtos/zephyr/commit/913507a21fa4c5c47134e2c1f555ebde7b719c1a) tests: crypto: rand32: Add test for z_early_boot_rand32_get
- [09a322ae](https://github.com/zephyrproject-rtos/zephyr/commit/09a322ae2180f765949c3a054381251a75a77bd0) tests: kernel: device: Set device power state
- [4238418e](https://github.com/zephyrproject-rtos/zephyr/commit/4238418eb2ca93211237952e045020e8fdefb97e) tests: kernel: document gen_isr_table tests for RTM
- [faae730a](https://github.com/zephyrproject-rtos/zephyr/commit/faae730a53e47e65542809325e132063f5c00b22) tests: net: Print proper error if we run out of net bufs
- [127220c6](https://github.com/zephyrproject-rtos/zephyr/commit/127220c663928b6cd7dcbffba35aaa85a0f7e7e1) tests: net: Run various tests only in qemu_x86 or native_posix
- [73522606](https://github.com/zephyrproject-rtos/zephyr/commit/735226069621e5b1f969037e6a4ab819002e9434) tests: net: ethernet_mgmt: Add promisc mode tests
- [e18900c5](https://github.com/zephyrproject-rtos/zephyr/commit/e18900c5c597184371246435263119b2116c5cad) tests: net: if: Add promisc mode tests
- [d202834e](https://github.com/zephyrproject-rtos/zephyr/commit/d202834e867659fe2e6d0dcded2c239210625426) tests: net: Add tests for net_promisc API
- [cb499d32](https://github.com/zephyrproject-rtos/zephyr/commit/cb499d3232de0446493472be539e61d05e9e8acd) tests: stack: Add description for test cases
- [4c6b90e3](https://github.com/zephyrproject-rtos/zephyr/commit/4c6b90e3179353e1917ebed4df9ab15e0c0947e2) tests: queue: Add description and doxygen groups
- [cea73067](https://github.com/zephyrproject-rtos/zephyr/commit/cea73067cec3abf7d81ec5671f106ea42557e151) tests: kernel: Add test to validate k_stack_alloc_init, k_stack_cleanup
- [7c8aa526](https://github.com/zephyrproject-rtos/zephyr/commit/7c8aa526cb8618b077686a0437fb83faffce07dc) tests: queue: Enhance tests to improve coverage
- [7b24690e](https://github.com/zephyrproject-rtos/zephyr/commit/7b24690e143a59fe20f3524a65dc1f8863b64ae6) tests: msgq: Enhance tests to improve code coverage
- [8ba0ddf4](https://github.com/zephyrproject-rtos/zephyr/commit/8ba0ddf4baeb967a03ea36bb61b150bf3890adaf) test: Add test for native_posix RTC and real time control
- [d9d3a5ad](https://github.com/zephyrproject-rtos/zephyr/commit/d9d3a5adf84a7171de34820ed91c07d585e8bfea) tests: kernel: timer: Add a test case to cover k_timer_start
- [c27af479](https://github.com/zephyrproject-rtos/zephyr/commit/c27af47999038410af3f5a9d84e0c8f6cd80723e) tests: power: power_states: Do not enter LPS states on test exit
- [00e29c17](https://github.com/zephyrproject-rtos/zephyr/commit/00e29c176d6d0a4b61c65889f7f34ccd27d92766) tests: kernel: Move k_thread_foreach() API test to thread_apis test
