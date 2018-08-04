+++
title = "Zephyr News, 4 May 2018"
date = "2018-05-04"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 4 May 2018 newsletter tracking the latest
[Zephyr](https://www.zephyrproject.org/) development merged into
the [mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

<!--more-->

Contents are broken down like this:

- **Highlights**
  - Important changes: ABI/API breaks and some features
  - New features: non-exhaustive descriptions of new features
  - Bug fixes: non-exhaustive list of fixed bugs
- **Individual changes**: a complete list of patches, sorted
  chronologically and categorized into areas, like:
  - Architectures
  - Kernel
  - Drivers
  - etc.

Highlights
==========

This newsletter covers changes in Zephyr between these two
commits (inclusive):

- [b742b62b](https://github.com/zephyrproject-rtos/zephyr/commit/b742b62b6e2e402fbc0a159d180389dd912539f6) kconfiglib: Update to get split_expr() in
- [dc97fc2a](https://github.com/zephyrproject-rtos/zephyr/commit/dc97fc2a609eb4c1d64b2c963094e18682bfcaea) kconfiglib: Update to default to UTF-8 for Python 3

Important Changes
-----------------

**Retpolines on x86**

x86 CPUs affected by Spectre v2 now support
[retpolines](https://support.google.com/faqs/answer/7625886) when
invoking interrupt and exception handlers, during thread entry, and
when invoking syscall handlers.

These changes also saw the removal of the (unused) _far_jump() and
_far_call() routines.

**LED and Button Definition Moves**

This continues the long-term project to move device configuration from
Kconfig to Device Tree.

LED and button definitions were removed from all STM32 board.h files,
since the corresponding defines now come from device tree. This is a
breaking change, as the old `XXX_GPIO_PORT` is now
`XXX_GPIO_CONTROLLER`. Applications which used the old names will need
updates.

NXP Kinetis SoCs were also converted to generate this information from
Device Tree. This change preserved names, but did not include updates
for the FXOS8700 or FXAS21002 temperature sensors or the MCR20A
802.15.4 radio. Users of those devices on NXP Kinetis boards should be
advised that [support is
broken](https://github.com/zephyrproject-rtos/zephyr/issues/7172) in
this Zephyr tree.

**Deprecated `__stack` macro removed**

The `__stack` macro, which was deprecated in favor of
[K_STACK_DEFINE](http://docs.zephyrproject.org/api/kernel_api.html#c.K_STACK_DEFINE)
before v1.11 was released, has been removed.

**mbedTLS update to fix remote execution holes**

The mbedTLS cryptography library was updated from version 2.7.0 to
version 2.8.0, addressing CVEs
[2018-0488](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-0488)
and
[2018-0487](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-0487). These
are remote execution vulnerabilities that could occur when TLS or DTLS
is in use.

**k_thread_cancel() deprecated**

The k_thread_cancel() API is deprecated. Applications should use
[k_thread_abort()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv214k_thread_abort7k_tid_t).

**Generic storage partition rename**

The NFFS [flash
partition](http://docs.zephyrproject.org/devices/dts/flash_partitions.html)
available on many boards, which was previously aliased to
`nffs_partition`, has been renamed to `storage_partition`, to reflect
its general usefulness for a variety of storage systems. Its existence
is now controlled via a [CONFIG_FS_FLASH_MAP_STORAGE](http://docs.zephyrproject.org/reference/kconfig/CONFIG_FS_FLASH_MAP_STORAGE.html#cmdoption-arg-config-fs-flash-map-storage).

Out of tree applications using the old alias or configuration option
to access this partition will need updates.

Features
--------

**Architectures**:

The ARC architecture now supports
[CONFIG_STACK_SENTINEL](http://docs.zephyrproject.org/reference/kconfig/CONFIG_STACK_SENTINEL.html),
which can help diagnose stack overflow issues.

[SEGGER
RTT](https://www.segger.com/products/debug-probes/j-link/technology/about-real-time-transfer/)
support is now enabled on all NXP MCUs.

Support was added for Cadence's proprietary XCC compiler toolchain for
the XTensa architecture, along with support for the intel_s1000 SoC.
Judging from [these
drivers](https://github.com/intel/rtos-drv-intel-s1000), the SoC is
intended for use in speech and other audio processing. Zephyr
SoC-level support is provided for DMA, I2S, UART, GPIO, USB, and I2C,
with board support via intel_s1000_crb.

**Boards**

I2C driver support was enabled for all the official nRF5 boards
provided by Nordic Semiconductor.

The bbc_microbit now supports flash partitions for mcuboot and on-chip
storage.

**Build system**

A variety of improvements were merged into the build system.

Notably, the build system now caches information obtained from the
toolchain, optimizing subsequent invocations of cmake using the same
toolchain. Factor of two speedups have been observed when the cache is
used. A few problems have been identified and fixed up since the
initial merge, but hopefully the major issues are resolved.

In another significant addition, the build system now contains an
initial Python-based menuconfig alternative. This can currently be
used by running `ninja pymenuconfig` on all supported targets (though
Windows users will need to install an additional wheel). This is a
significant improvement for Windows users, who previously have not had
a configuration system browser. The `pymenuconfig` target is
experimental. When it reaches sufficient feature parity with the
existing `menuconfig` target, it will replace it, and the C-based
Kconfig tools will be removed from Zephyr.

Further improvements include better error feedback when toolchains are
not found, the list of printed boards now respecting `BOARD_ROOT`,
and silencing of verbose compiler check messages.

**Drivers**

There is a new API for LEDs in include/led.h. (Zephyr had an API for
strips of LEDs; this new API is for controlling individual lights.)
The initial API includes support for basic on/off, as well as
brightness and blinking. A driver and sample application for the TI
LP3943 LED controller were also merged.

The ST LSM6DSL inertial module driver saw a cleanup and now supports
sensor hub mode. This allows the LSM6DSL to act as a sensor hub by
connecting additional I2C slave devices through to the driver via the
main communication channel.

STM32L0 and L4 microcontrollers now support the MSI (multi-speed
internal) clock as a system clock source.

The uart_pipe console driver now supports both edge and level
triggering, allowing it to work with CDC ACM.

The MCUX GPIO driver now uses device tree.

A GPIO driver for NXP i.MX SoCs was merged.

**Device Tree**

Bindings were added for the DesignWare CAVS multilevel interrupt
controller.

GPIO nodes are now present on all Kinetis SoCs.

**Documentation**

The search results pages for the online Zephyr documentation now have
much cleaner output.

Zephyr's documentation describing its Kconfig usage was re-worked and
improved as part of the transition towards a Python-based menuconfig
alternative.

**Kernel**

The kernel's scheduler interface was significantly refactored and
cleaned up. The scheduler's system interface was decreased to twelve
functions; notably, usage of _Swap() was removed in various places in
favor of a new _reschedule().

Userspace configurations now support dynamic creation of kernel
objects. Previously, kernel objects (such as mutexes, pipes, and
timers) needed to be declared statically. This is because a special
linker pass is used when building the Zephyr image, which creates a
perfect hash table which was used to validate if a memory address
passed from userspace pointed to a valid kernel object, among other
security checks. In addition to this hash table, Zephyr now supports
maintaining metadata for dynamically created kernel objects using the
new red/black tree implementation that was added in the v1.12
development cycle. Dynamic kernel objects are allocated and freed from
the system heap. The new allocate and free routines are respectively
`k_object_alloc()` and `k_object_free()`. They are currently only
callable from supervisor mode.

**Libraries**

The singly-linked list implementation in include/misc/slist.h is now
implemented in terms of a new macro metaprogramming header,
include/misc/list_gen.h. This new header allows generation of static
inline routines implementing "list-like" behavior (i.e. defining
operations for getting, removing, inserting, etc.) for any compound
data type that implements a base set of operations. The base
operations from which the others are derived are: initialization;
getting the "next" node; setting the next, head, and tail nodes;
and peeking at the head and tail nodes.

The JSON library's internal descriptor type is more tightly packed,
using bitfields to place information formerly found in four integers
into 32 bits worth of bitfields. This results in a net savings of
read-only data at a slight increase in text size.

**Samples**

A sample application demonstrating the BLE broadcaster role by
providing Apple iBeacon functionality was added in
samples/bluetooth/ibeacon.

Samples using LEDs and buttons were updated following the device tree
name change from PORT to CONTROLLER described above.

The LWM2M sample was re-worked to add configuration overlay fragments
for enabling Bluetooth networking and DTLS. The README was updated
with new instructions for building the sample.

**Testing**

The effort to prepare Zephyr's tests for inclusion in a test
management system continues.

Various tests were cleaned up with style, tag, and category fixes,
along with numerous tests receiving Doxygen-based documentation.

The sanitycheck script now parses test cases declared by a test suite
from the source code, using regular expressions.

Sanitycheck also now supports a `--list-tests` flag, which prints
declared test cases. Its output can be further refined by passing the
`-T` option a relative path to a subdirectory of "tests" (e.g. `-T
tests/net/socket`).

The test suite core now includes support for skipping tests when they
are not supported.

**USB**

There was a fair bit of USB-related activity which spanned areas in
the tree.

The USB DFU class driver was heavily re-worked and moved to
subsys/usb/class. The driver now determines the [flash
partition](http://docs.zephyrproject.org/devices/dts/flash_partitions.html)
layout for the currently running image and an area to store an update
image via device tree flash partitions, matching Zephyr's MCUboot area
support mechanism. This allows Zephyr applications to add firmware
update support by enabling the USB DFU driver and booting under
MCUboot. Refer to the README and other documentation in
samples/subsys/usb/dfu for more details.

The hci_usb sample application, which allows a Zephyr device which
supports USB and a Bluetooth controller to act as a Bluetooth dongle,
had its core USB operations generalized and migrated into the core USB
subsystem. The sample application is now much smaller; what remains
essentially just enables the driver.

The wpanusb sample, which allows Zephyr applications to expose
802.15.4 radio functionality to a host via USB, saw a major
cleanup. This sample will be more widely useful upon release of
corresponding Linux drivers.

Bug Fixes
---------

There were several networking-related bug fixes: a fragment
double-free, a build error for HTTP clients, a buffer overflow in the
hostname storage area, an ARP null network packet dereference, and a
miscalculation of ICMPv6 packet payload length and checksum fields.

Calling pthread_cond_signal() from a cooperative thread no longer
yields.

The irq_lock() compatibility layer on SMP configurations was fixed,
avoiding potential deadlocks when swapping away from a thread that
holds the lock.

The kernel scheduler's validation of priority levels was fixed.

A bug which allowed user mode code to force the kernel to execute code
at address 0x0 has been fixed by introducing an extra validation step
at every syscall entry point.

A race condition which could potentially allow user space code to
modify memory containing I2C messages before the kernel-level handler
runs was closed.

Issues preventing successful thread context switch during exception
return on ARC were fixed. The fatal error handler on that architecture
also no longer hangs the system after aborting a non-essential thread.

The BusFault Status Register bits on ARMv8-M MCUs are now properly
cleared when that fault occurs.

The Bluetooth Mesh implementation continues to become more robust,
with three bug fixes affecting initialization vectors and node
identity advertising, and two other cleanups.

The boot banner now correctly prints the Zephyr "git describe" output
when the application is outside the Zephyr tree.

A variety of warnings emitted when using dtc version 1.4.6 are now
fixed. These fixes appear to be backwards-compatible.

A variety of USB-related bug fixes went in, including a fix for the
DesignWare driver's excessive generation of zero-length packets, a
missing byte order conversion computation in the common configuration
descriptor, and other fixes and cleanups.

The ST LSM6DSL inertial module driver was converted to use the new SPI
API, following the removal of the old API.

Individual Changes
==================


Patches by area (241 patches total):

- Arches: 31
- Bluetooth: 5
- Boards: 11
- Build: 19
- Continuous Integration: 6
- Device Tree: 9
- Documentation: 12
- Drivers: 36
- External: 4
- Kernel: 17
- Libraries: 6
- Maintainers: 1
- Miscellaneous: 6
- Networking: 8
- Samples: 26
- Scripts: 9
- Storage: 4
- Testing: 31

Arches (31):

- [3d9ba10b](https://github.com/zephyrproject-rtos/zephyr/commit/3d9ba10b5c903265d870a9f24065340d93e7d465) arch: arc: bug fixes and optimization in exception handling
- [24acf2a4](https://github.com/zephyrproject-rtos/zephyr/commit/24acf2a41435c92b6c192f93ad26e350396b7d35) arch: arc: bug fixes in irq_load
- [8da51ee3](https://github.com/zephyrproject-rtos/zephyr/commit/8da51ee3269a90d99278f4a6ff8fa96bdf41fd09) arch: arc: optimize the _SysFatalErrorHandler
- [adf6f48e](https://github.com/zephyrproject-rtos/zephyr/commit/adf6f48e0d97e4c2d0186c1ac209e9e39e8232e8) arch: arc: add the support of STACK_SENTINEL
- [b4696bd7](https://github.com/zephyrproject-rtos/zephyr/commit/b4696bd7ecce7326949c5a4f1a3273fe8a850b3d) arch: arm: Fix coding style in file irq_relay.S
- [50b69fbb](https://github.com/zephyrproject-rtos/zephyr/commit/50b69fbb553dcd699e24b294fcbf0e83dff0145a) arm: nxp_kinetis: Remove unused defines from soc.h
- [0b7c964f](https://github.com/zephyrproject-rtos/zephyr/commit/0b7c964f5f1eb5992dfb1314111fdebae599c2be) arch: arm: clear BFSR sticky bits in ARMv8-M Mainline MCUs
- [16472caf](https://github.com/zephyrproject-rtos/zephyr/commit/16472cafcf4ef272c9dd69a3efcd3b6913900672) arch: x86: Use retpolines in core assembly routines
- [ae7911cc](https://github.com/zephyrproject-rtos/zephyr/commit/ae7911cce06b7a87865852a13f6a70dd70ef5a0c) arch: x86: segmentation: Remove unused _far_call() and _far_jump()
- [adf5b36a](https://github.com/zephyrproject-rtos/zephyr/commit/adf5b36a7834e4b915cc162c72a00a5ba354e64f) lpc54114: Remove unused include in soc.c
- [3e3d1a1c](https://github.com/zephyrproject-rtos/zephyr/commit/3e3d1a1c8c073831d435ecc0640d017a54f55a47) x86: minnowboard: Add support for enabling MMU
- [960e9783](https://github.com/zephyrproject-rtos/zephyr/commit/960e97834fab1ec9b5c764087f5e5972fb81ba2a) x86: linker: Maintain 4K alignment for application memory.
- [246f03c9](https://github.com/zephyrproject-rtos/zephyr/commit/246f03c9e63578ba523fce5b52b16c0856990d6c) x86: minnowboard: Enable the userspace mode
- [ae5e11be](https://github.com/zephyrproject-rtos/zephyr/commit/ae5e11bebc9cd7649c17ebf8f6dc5c8f6eee96ce) arm: soc: NXP: Enable SEGGER RTT on all NXP SoCs
- [c7d808f9](https://github.com/zephyrproject-rtos/zephyr/commit/c7d808f96501697723245d81e901224668b8eeca) arch: arm: improve help text for PROGRAMMABLE_FAULT_PRIOS option
- [c36e5ac1](https://github.com/zephyrproject-rtos/zephyr/commit/c36e5ac129b26c5ae12b8f39496fcaabc209a049) arm: Fix title for SoC configuration in Kconfig
- [42a7c573](https://github.com/zephyrproject-rtos/zephyr/commit/42a7c5732f73f65f8fe3c57b995ca3accea1a2a6) arm: soc: Elaborate Kconfig strings for MPU selection
- [d9cdf7bf](https://github.com/zephyrproject-rtos/zephyr/commit/d9cdf7bf30f4f6fd584d13ea6613cbdc374560de) arch/arm/soc/st_stm32: Fix typos in soc.h
- [de7f40ac](https://github.com/zephyrproject-rtos/zephyr/commit/de7f40acfb575d9053e5a74d178eb7bf5442892b) kconfig: fix menuconfig
- [f14d1be6](https://github.com/zephyrproject-rtos/zephyr/commit/f14d1be67fe3cd0f872a35bd731fa65d676e0e1e) intel_s1000: Add intel_s1000 SoC
- [1fcd39b6](https://github.com/zephyrproject-rtos/zephyr/commit/1fcd39b62496a9a2900e866d7723bf999e168f21) intel_s1000: define memctl_default.S and memerror-vector.S files
- [c9ace83c](https://github.com/zephyrproject-rtos/zephyr/commit/c9ace83c896c2b8b047995762b8af9a2a9a9bdc2) xtensa: reset-vector.S hack for booting intel_s1000 [REVERTME]
- [47ff9659](https://github.com/zephyrproject-rtos/zephyr/commit/47ff96593f259d4d3e2ef4d36440a14afbfcb195) intel_s1000: uart: configure UART for intel_s1000
- [9ed55af2](https://github.com/zephyrproject-rtos/zephyr/commit/9ed55af2f817a3444cd78e17e986a6674a0a99a8) arch: xtensa: set __start as entry point for Xtensa.
- [63d50e15](https://github.com/zephyrproject-rtos/zephyr/commit/63d50e158e3d5fa1da721263de46ff0e7cea0cd6) intel_s1000: gpio: enable GPIO handling
- [9cc381c0](https://github.com/zephyrproject-rtos/zephyr/commit/9cc381c07af15aafa47b9dddfd4d8e3c743b398e) intel_s1000: i2c: enable I2C for intel_s1000
- [dadf9e7a](https://github.com/zephyrproject-rtos/zephyr/commit/dadf9e7a81de66e2578fe85c2d66cc3d284225f4) xtensa: intel_s1000: implement interrupt mechanism
- [08172cdf](https://github.com/zephyrproject-rtos/zephyr/commit/08172cdf8343999fc9ce10f004620a06e8f59c0e) xtensa: provide XCC compiler support for Xtensa
- [2fd277fc](https://github.com/zephyrproject-rtos/zephyr/commit/2fd277fccf839913d9d7c04a1e10606800048889) arch/arm/soc/st_stm32/stm32f1: Add I2C1 to dts.fixup
- [6c65ac2b](https://github.com/zephyrproject-rtos/zephyr/commit/6c65ac2bb44746921a8ad85cc12ebbc9eefa53c2) arch: arc: fix the typo of label which caused issue #7249
- [e3efbd54](https://github.com/zephyrproject-rtos/zephyr/commit/e3efbd54c6073cbcb131274d27745154fdd05700) POSIX arch: Fix linker -T warning

Bluetooth (5):

- [2a896cc6](https://github.com/zephyrproject-rtos/zephyr/commit/2a896cc6c43043de68deba1030031147e12e7050) Bluetooth: Mesh: Fix IV Update tests when duration is unknown
- [c7c5829b](https://github.com/zephyrproject-rtos/zephyr/commit/c7c5829ba6b8a46a1596344a5bc25b03560a7d00) Bluetooth: Mesh: Fix missing IVU normal mode timer when provisioning
- [aa67a4c5](https://github.com/zephyrproject-rtos/zephyr/commit/aa67a4c55a7843d7cc2b4be031dc7f988d3ed443) Bluetooth: Mesh: Remove redundant branch for IV Update
- [92749e7a](https://github.com/zephyrproject-rtos/zephyr/commit/92749e7a92cf6fa1ea3126d3d1a2be5b2e924609) Bluetooth: Mesh: Remove unnecessary #ifdefs from header file
- [6b111064](https://github.com/zephyrproject-rtos/zephyr/commit/6b1110644095213a654b62c09b9147d7ea463edf) Bluetooth: Mesh: Fix enabling Node Identity advertising

Boards (11):

- [678a6e02](https://github.com/zephyrproject-rtos/zephyr/commit/678a6e02f938e95918507210cf3d1b744b5b68d7) boards: stm32 remove led and button definitions from board.h
- [c627de1f](https://github.com/zephyrproject-rtos/zephyr/commit/c627de1f87414f35e40acca75084ba91f72f5655) boards: Move led and button definitions to dts for kinetis boards
- [597517c7](https://github.com/zephyrproject-rtos/zephyr/commit/597517c79f60a1ef51cefd6b730a7d8a9b22804d) boards: dts: Add i2c to nrf5X_pcaX board dts.
- [513488c9](https://github.com/zephyrproject-rtos/zephyr/commit/513488c9379310988f629e7f3d6a209d6b313c10) boards: disco_l475_iot1: define 2 default clock configurations
- [f496fd2a](https://github.com/zephyrproject-rtos/zephyr/commit/f496fd2a0446a8ebc475b66d3a23862627aaba01) boards/arm/stm32_min_dev: Fix APB2 prescaler value
- [992070f1](https://github.com/zephyrproject-rtos/zephyr/commit/992070f12dbbea7dba650e0482ebcdc12e3ad92b) boards: microbit: Add flash partition definitions to dts
- [034a11b7](https://github.com/zephyrproject-rtos/zephyr/commit/034a11b7cd93ef65718774b784764886914c8117) boards: arm: 96b_neonkey: Fix I2C_3 for LP3943 LED driver
- [0090fd4d](https://github.com/zephyrproject-rtos/zephyr/commit/0090fd4d152c66ea25a877acd2797fa288cd0d92) intel_s1000: create xt-sim_intel_s1000_defconfig
- [02736e59](https://github.com/zephyrproject-rtos/zephyr/commit/02736e59351bf191491eed58228e91aa9d54156f) intel_s1000: add intel_s1000_crb board
- [cea1c75e](https://github.com/zephyrproject-rtos/zephyr/commit/cea1c75e2b1b57ca9d48407bc7ce68e1b4ccdc6d) boards: intel_s1000_crb: enable DMA
- [46d6ba46](https://github.com/zephyrproject-rtos/zephyr/commit/46d6ba46747557bdc19bd49e57280ffb2373843f) boards: intel_s1000: enable I2S

Build (19):

- [f10fddeb](https://github.com/zephyrproject-rtos/zephyr/commit/f10fddeb565574978c89e264004ce178676f1cd8) cmake: toolchain: Improve error feedback when toolchain is not found
- [d9ac1d4b](https://github.com/zephyrproject-rtos/zephyr/commit/d9ac1d4b4a131b354f3600d6a0f14fc4fc01be1a) warnings: Disable "unused-local-typedefs" compiler warning
- [6779d3f3](https://github.com/zephyrproject-rtos/zephyr/commit/6779d3f356049e479d09b624b48aa730934ba11c) cmake: Fix printed list of supported boards.
- [6c3a94c0](https://github.com/zephyrproject-rtos/zephyr/commit/6c3a94c01f84eccacb0a6e060e698cfa20b79ff9) cmake: Add function for checking if a directory is write-able
- [709daa20](https://github.com/zephyrproject-rtos/zephyr/commit/709daa20e917a4620a600b03f5b6204addf2558c) cmake: Find a directory that could be used to cache files
- [c95c6bef](https://github.com/zephyrproject-rtos/zephyr/commit/c95c6bef04b953c478268e25c15d2d74618c06c1) cmake: check_compiler_flag: Support empty-string options
- [a7c3f4ed](https://github.com/zephyrproject-rtos/zephyr/commit/a7c3f4ed25915ef5353866f33690c3c8468f6b60) cmake: toolchain: Checksum the toolchain to uniquely identify it
- [84475810](https://github.com/zephyrproject-rtos/zephyr/commit/84475810ecad1c71fad93d2a05511e652e6e6440) cmake: Introduce zephyr_check_compiler_flag()
- [71b849f1](https://github.com/zephyrproject-rtos/zephyr/commit/71b849f18c6af931a004754b3ebf76a5c1dfa715) cmake: Port Zephyr to use zephyr_check_compiler_flag
- [8bcf30e2](https://github.com/zephyrproject-rtos/zephyr/commit/8bcf30e21a16b3c5e2baf208eabda7d582335882) cmake: posix: Use absolute paths for toolchain paths
- [33d87efd](https://github.com/zephyrproject-rtos/zephyr/commit/33d87efda5ab282f84ac98707d0f72df58bd62fd) build: simplify git describe call
- [f9b2da37](https://github.com/zephyrproject-rtos/zephyr/commit/f9b2da37b041fe2fbbdc9cd1924fe2b29bc25fb0) kconfig: Move CPLUSPLUS from root to "Compiler Options"
- [7db4d569](https://github.com/zephyrproject-rtos/zephyr/commit/7db4d5699e2c51010ca22531ed310e603d10232c) Revert "warnings: Disable "unused-local-typedefs" compiler warning"
- [a4381d9e](https://github.com/zephyrproject-rtos/zephyr/commit/a4381d9ea6bd93b6cdd90e663243a73ef53f9a92) kconfig.cmake: Consistently use ZEPHYR_BASE
- [9fbdab52](https://github.com/zephyrproject-rtos/zephyr/commit/9fbdab528ed25c95a3cd12e51d933939fc9e3000) build: fix git describe call on older Git versions
- [632fe1d4](https://github.com/zephyrproject-rtos/zephyr/commit/632fe1d411a5a9024cba76d174c528db289cc3e0) cmake: check_compiler_flag: Fix bug where checks were aliased
- [5f08b106](https://github.com/zephyrproject-rtos/zephyr/commit/5f08b106a8365e8132df722194d79c6166e2a2ff) cmake: Suppress messages about compiler checks
- [aa90d721](https://github.com/zephyrproject-rtos/zephyr/commit/aa90d721168a52817d038050f6c1571a963738a3) cmake: Introduce a key version to invalidate corrupted caches
- [878f39c1](https://github.com/zephyrproject-rtos/zephyr/commit/878f39c18e84727f4bc3d9073ae6d54d918da156) makefile: Fix dependencies for privileged stacks

Continuous Integration (6):

- [140daa2f](https://github.com/zephyrproject-rtos/zephyr/commit/140daa2f275e1842f38c9445ee0da68684a729ee) sanitycheck: add min_flash option for 32K devices
- [aae71d74](https://github.com/zephyrproject-rtos/zephyr/commit/aae71d74dd2f26f970f8dc0479ea706fde36dbdc) sanitycheck: parse test cases from source files
- [c0149cc0](https://github.com/zephyrproject-rtos/zephyr/commit/c0149cc01d134c3064c44b25e8f8fa7050dd239d) sanitycheck: support listing test cases
- [de223cce](https://github.com/zephyrproject-rtos/zephyr/commit/de223cce8a9a3ecf20e7b8a46e712f0e713caa9d) sanitycheck: Updated helptext to -O/--outdir argument.
- [75e2d901](https://github.com/zephyrproject-rtos/zephyr/commit/75e2d901e7ab653ce37dbb9506a55d60160faaaa) sanitycheck: refinements to --list-tests
- [770178b7](https://github.com/zephyrproject-rtos/zephyr/commit/770178b76e9f1dc2d78352477faa09bd9454e2f7) sanitycheck: Stop on linker warnings also in native_posix

Device Tree (9):

- [a43ad6d5](https://github.com/zephyrproject-rtos/zephyr/commit/a43ad6d5f0bb8e20e2971fe1ab0a73d20ff01740) dts: arc: quark_se_c1000_ss: Fix worng interrupt number in i2c 0/1
- [22955b83](https://github.com/zephyrproject-rtos/zephyr/commit/22955b83fda5ba44435948aef967800278b858a1) dts: Add gpio labels to all kinetis socs
- [a27c0ede](https://github.com/zephyrproject-rtos/zephyr/commit/a27c0ede12f02037ebbc5bb7ea829c54f08fc2cd) dts/st: dtc v1.4.6 warnings: #address-cells/#size-cells without "ranges"
- [acc20e24](https://github.com/zephyrproject-rtos/zephyr/commit/acc20e24d660f7b16088ed5fc8e977b4e49b0103) dts/st: dtc v1.4.6 warnings: Missing property '#clock-cells' in node
- [986f249f](https://github.com/zephyrproject-rtos/zephyr/commit/986f249f0310cd3f625984b7286e952bd630a7e7) dts/st: dtc v1.4.6 warnings: pin-c... node has a reg ... no unit name
- [398a5a4f](https://github.com/zephyrproject-rtos/zephyr/commit/398a5a4fc2976d98d751c86f32d1155fcb0dad10) dts: dtc v1.4.6 warnings: Fix warning for leading 0s
- [97f721d9](https://github.com/zephyrproject-rtos/zephyr/commit/97f721d928aa65582c7a454d5048672490f1166e) dts: xtensa: Add device tree support for xtensa
- [9ee4929d](https://github.com/zephyrproject-rtos/zephyr/commit/9ee4929d568722a2f3d7c6ea4fd4f69d740b226b) dts: i2c: Add dts support for i2c
- [7be3236c](https://github.com/zephyrproject-rtos/zephyr/commit/7be3236ca4a4aa6a5f037d8a91640a4d7d52cb43) dts: interrupt_controller: Add dts support for DesignWare controller

Documentation (12):

- [3a72cc98](https://github.com/zephyrproject-rtos/zephyr/commit/3a72cc988902b968555306eeccdd63f2c5bb0788) doc: genrest: Simplify select logic with split_expr()
- [28724732](https://github.com/zephyrproject-rtos/zephyr/commit/28724732e7dc9b9aa595ac4f4c772f35f310724e) doc: fix mgmt sample path
- [55840693](https://github.com/zephyrproject-rtos/zephyr/commit/558406932b187d743b2c46d3790c0e33eb00e330) doc: win: Invoke pip3 instead of pip to be safe
- [b57ac8a2](https://github.com/zephyrproject-rtos/zephyr/commit/b57ac8a2ff59472596392aa14b3438ef74b92875) doc: improve Sphinx search results output
- [a380dce0](https://github.com/zephyrproject-rtos/zephyr/commit/a380dce01859812fef5b19622043c7e1c48f3a6e) doc: fix links to mailing lists
- [e618608f](https://github.com/zephyrproject-rtos/zephyr/commit/e618608fca5e7fd748be65336c253d5c07fa271a) doc: Expand info about troubleshooting ModemManager
- [1ae99f02](https://github.com/zephyrproject-rtos/zephyr/commit/1ae99f02f17713c7256c04b706ec0e7fa7949cf9) doc: Improve Kconfig interface description
- [303484aa](https://github.com/zephyrproject-rtos/zephyr/commit/303484aa2fdef2aa5ab97afd88b6b088653fff39) doc: Clarify application configuration
- [64eb789f](https://github.com/zephyrproject-rtos/zephyr/commit/64eb789ff5b450eeaa79b2004db95182d98e94a2) doc: Clarify format for CONF_FILE
- [b4d67dcc](https://github.com/zephyrproject-rtos/zephyr/commit/b4d67dcc46b40c0d1d7b76ee4d17217ae435714a) doc: update doc generation instructions
- [63cb2334](https://github.com/zephyrproject-rtos/zephyr/commit/63cb2334f07006f6b89fbdeadebbff2445b3df90) doc: Document Zephyr's Kconfig configuration scheme
- [699759a0](https://github.com/zephyrproject-rtos/zephyr/commit/699759a0d604bdcacad1c537853e66fc99201343) doc: brief description on intel_s1000 usage

Drivers (36):

- [4e8f29f3](https://github.com/zephyrproject-rtos/zephyr/commit/4e8f29f3195464616d465f337622c2a1233c77a6) gpio: Refactor the mcux gpio driver to use dts
- [8d3b2fa8](https://github.com/zephyrproject-rtos/zephyr/commit/8d3b2fa8a9bbad9d9fd45897092c595f461319a4) usb: usb_dc_dw: Fix incorrect MPS return
- [4f84cf78](https://github.com/zephyrproject-rtos/zephyr/commit/4f84cf782df8118b58c87b17ad149a461846fe22) usb: Add BOS Descriptors
- [773f3e18](https://github.com/zephyrproject-rtos/zephyr/commit/773f3e18bbdc7a96548b6d2c347545d7d46c773a) usb: Add sys_cpu_to_le16() conversion for USB field
- [6239341a](https://github.com/zephyrproject-rtos/zephyr/commit/6239341addfec56ebf11663e3ad3027b4df63554) usb: Add subsys/usb for device descriptor header
- [16532549](https://github.com/zephyrproject-rtos/zephyr/commit/1653254924b870d7b7821eb55bfb9682048d9618) usb: mass_storage: Use simpler header include
- [4d703b1e](https://github.com/zephyrproject-rtos/zephyr/commit/4d703b1e14fc41f117e2f98e80bb54cbc9cb1a44) usb: Add Bluetooth USB Device configuration options
- [0322af58](https://github.com/zephyrproject-rtos/zephyr/commit/0322af5896ccc4c3e343b515ef193b3efd0c1dcf) usb: Add Bluetooth device decriptors
- [53410af9](https://github.com/zephyrproject-rtos/zephyr/commit/53410af994527519e6f9bdfe4a70222435774e60) usb: Add Bluetooth device class core functionality
- [a09a0b2c](https://github.com/zephyrproject-rtos/zephyr/commit/a09a0b2c49758e5baa3b921d9093fa24567fc7b6) sensors/lsm5dsl: Fix SPI API usage
- [b7862eb8](https://github.com/zephyrproject-rtos/zephyr/commit/b7862eb8322daceaf3c9ee0a0f7e6b5d75324253) hid: core: truncated wLength if it doesn't match report descriptor size
- [8f7e5bd0](https://github.com/zephyrproject-rtos/zephyr/commit/8f7e5bd0a573201a5b019643ea7318e6f3524d0d) uart_pipe: re-work the RX function to match the API and work with USB.
- [c26fdc1b](https://github.com/zephyrproject-rtos/zephyr/commit/c26fdc1b55d7166d182875a2b5b9d8ee7eae4b26) drivers/spi: Fixed incorrect prompt.
- [d8ba007a](https://github.com/zephyrproject-rtos/zephyr/commit/d8ba007a8b1bb340efb6219653b358e857ab60fc) drivers: clock_control: Add MSI as possible clock source for stm32
- [25fb83c6](https://github.com/zephyrproject-rtos/zephyr/commit/25fb83c6e0a4ff0a357d97539c3b795e951280d0) drivers: i2c: Fix TOCTOU while transferring I2C messages
- [7e067414](https://github.com/zephyrproject-rtos/zephyr/commit/7e067414cd4b4fde955c52704992f64972a15d5f) usb: Remove unneeded header include
- [c200367b](https://github.com/zephyrproject-rtos/zephyr/commit/c200367b6893e4cd85001bf10eac6fc55da89339) drivers: Perform a runtime check if a driver is capable of an operation
- [185f2be6](https://github.com/zephyrproject-rtos/zephyr/commit/185f2be6814dbdfb23487317b6043c355aef412f) netusb: rndis: Add more debugs
- [222aa600](https://github.com/zephyrproject-rtos/zephyr/commit/222aa6009c158e6ce1ef05eec262fda64ce10491) netusb: rndis: Fix RNDIS always disabled state
- [94bba071](https://github.com/zephyrproject-rtos/zephyr/commit/94bba071d6fab217c5a89e4de93d89b6aca9e2e5) drivers: led: Add public API for LED drivers
- [bb394bba](https://github.com/zephyrproject-rtos/zephyr/commit/bb394bbafb903868f552ac9bdcefb5a216ef9395) drivers: led: Add LED driver support for TI LP3943
- [f4ad6988](https://github.com/zephyrproject-rtos/zephyr/commit/f4ad69884737799bb201058e01b10fcdfdfca592) drivers/spi: Remove DW spi slave test left over
- [180b1397](https://github.com/zephyrproject-rtos/zephyr/commit/180b139786aceb4fb76cd6903862728b727a24be) drivers: sensor: lsm6dsl: Adding sensorhub support
- [580a9b3f](https://github.com/zephyrproject-rtos/zephyr/commit/580a9b3f2f68856390fbdaa9f1277dfe9dc7a0fc) drivers: sensor: lsm6dsl: Fix typos
- [f7f56ccd](https://github.com/zephyrproject-rtos/zephyr/commit/f7f56ccda5b5a0b17097cc1cdfe89f15dd5eb1d9) drivers: sensor: lsm6dsl: add .attr_set callback
- [46700eaa](https://github.com/zephyrproject-rtos/zephyr/commit/46700eaa656ecae1c2fa0a234697e0087f9d864a) include: usb: add USB DFU class header
- [b2ca5ee5](https://github.com/zephyrproject-rtos/zephyr/commit/b2ca5ee5bcb3a9221b6f917ea8485cec4dec08d5) subsys: usb: rework USB DFU class driver
- [74016bb6](https://github.com/zephyrproject-rtos/zephyr/commit/74016bb64c839f85b46f0180f49400d035b6a088) drivers: interrupts: introduce CAVS interrupt logic
- [e3f2fa4f](https://github.com/zephyrproject-rtos/zephyr/commit/e3f2fa4f8966dcbd6a57b37d340592d6e2614bd3) drivers: interrupts: introduce Designware interrupt controller
- [bd0d5133](https://github.com/zephyrproject-rtos/zephyr/commit/bd0d5133e4b7a1909fcb8e1587e1cedf79836a05) drivers: dma: introduce Intel CAVS DMA
- [5b6f0244](https://github.com/zephyrproject-rtos/zephyr/commit/5b6f02442bf1e148a578d2f354962f85fe7179af) drivers: i2s: introduce CAVS I2S
- [5060f4bd](https://github.com/zephyrproject-rtos/zephyr/commit/5060f4bd140824e9503aca56ebf5e99e1610af1e) driver: usb: enable usb2.0 on intel_s1000
- [f618af75](https://github.com/zephyrproject-rtos/zephyr/commit/f618af75a85e207190b424e04fbb0d8fc80fe892) driver: ieee802154: cc1200: fix context handling
- [943ca29d](https://github.com/zephyrproject-rtos/zephyr/commit/943ca29d4b43c163609b768a0f899cda688aac5a) usb: dw: Fix Coverity issue with get_mps()
- [c6f2b4cc](https://github.com/zephyrproject-rtos/zephyr/commit/c6f2b4ccb8289bedfa9af2a70c9fd9f7b49ceba5) spi: Fix mcux dspi driver to parse lsb transfer mode correctly
- [67ba7d8a](https://github.com/zephyrproject-rtos/zephyr/commit/67ba7d8a36f6bfdb9b4680866bcfd864e7f38773) gpio: Add imx gpio driver shim

External (4):

- [2c58de57](https://github.com/zephyrproject-rtos/zephyr/commit/2c58de5735c858ce04e1d47942dc9a00806e21c8) ext: lib: crypto: Update mbedTLS to 2.8.0
- [9791597e](https://github.com/zephyrproject-rtos/zephyr/commit/9791597ef9de1c92b0da05dcb256aeb265b2698c) ext: mcux: Update README to follow template format
- [57e80e53](https://github.com/zephyrproject-rtos/zephyr/commit/57e80e53451adcb5bcea568781665bb1cf151256) ext: mcux: Reorganize imported drivers into soc family subfolders
- [4624f132](https://github.com/zephyrproject-rtos/zephyr/commit/4624f132901a22600607a7ae165a52ccb11d7521) ext: mcux: Remove clock_config.c/h

Kernel (17):

- [56c2bc96](https://github.com/zephyrproject-rtos/zephyr/commit/56c2bc96a6e7609c2fbd2dcca954b8780f524154) kernel: add CODE_UNREACHABLE in _StackCheckHandler
- [541c3cb1](https://github.com/zephyrproject-rtos/zephyr/commit/541c3cb18bc6a50abde29aab9c0aebdf5d768077) kernel: sched: Fix validation of priority levels
- [b481d0a0](https://github.com/zephyrproject-rtos/zephyr/commit/b481d0a045900cd45cfc24100266d9ed58ce827e) kernel: Allow pending w/o wait_q for scheduler API cleanup
- [8606fabf](https://github.com/zephyrproject-rtos/zephyr/commit/8606fabf74c0082057b0caf6526907f660523cac) kernel: Scheduler refactoring: use _reschedule_*() always
- [e0a572be](https://github.com/zephyrproject-rtos/zephyr/commit/e0a572beebed584ef61f8c2377686e243bc3b0f5) kernel: Refactor, unifying _pend_current_thread() + _Swap() idiom
- [0447a73f](https://github.com/zephyrproject-rtos/zephyr/commit/0447a73f6ce39263b16a4685ad7ae0fe30265106) kernel: include cleanup
- [15cb5d72](https://github.com/zephyrproject-rtos/zephyr/commit/15cb5d7293d593b4eb9fba937267f6228b6f2f5c) kernel: Further unify _reschedule APIs
- [3f55dafe](https://github.com/zephyrproject-rtos/zephyr/commit/3f55dafebc0d026e81fa17e7d50dcf47c6823a40) kernel: Deprecate k_thread_cancel() API
- [5792ee6d](https://github.com/zephyrproject-rtos/zephyr/commit/5792ee6da28216d7725d63eda3c9e8a98e5b8d6d) kernel/mutex: Clean up k_mutex_unlock()
- [22642cf3](https://github.com/zephyrproject-rtos/zephyr/commit/22642cf3099882732f6279f3e6fc92d80efcfef4) kernel: Clean up _unpend_thread() API
- [8a4b2e8c](https://github.com/zephyrproject-rtos/zephyr/commit/8a4b2e8cf2f5675b09f0cb1e1961e58e5582f34a) kernel, posix: Move ready_one_thread() to scheduler
- [f5f95ee3](https://github.com/zephyrproject-rtos/zephyr/commit/f5f95ee3a909e522acb1a8ee534635d45803441c) kernel: sem: Ensure that initial count is lesser or equal than limit
- [31bdfc01](https://github.com/zephyrproject-rtos/zephyr/commit/31bdfc014e786d94608b4405694520f41c5066bf) userspace: add support for dynamic kernel objects
- [e7ded11a](https://github.com/zephyrproject-rtos/zephyr/commit/e7ded11a2eb36deba9bda359b510e52cdcd5fb4c) kernel: Prune ksched.h of dead code
- [68040c8d](https://github.com/zephyrproject-rtos/zephyr/commit/68040c8d78d0253fc1e81401b47016f4bd110408) kernel: sem: Modify the way BUILD_ASSERT is used
- [eb258706](https://github.com/zephyrproject-rtos/zephyr/commit/eb258706e0ac13d79e21f957f9ff6ba4c9d644fd) kernel: Move SMP initialization to start of main thread
- [15c40077](https://github.com/zephyrproject-rtos/zephyr/commit/15c400774ece52247942a1aede645d4abf2517d5) kernel: Rework SMP irq_lock() compatibility layer

Libraries (6):

- [2a5fb57e](https://github.com/zephyrproject-rtos/zephyr/commit/2a5fb57e956d3c4d29f9cf8e996891eafcb1b23b) lib: posix: mqueue: Do not dereference mqd pointer before null check
- [3af88642](https://github.com/zephyrproject-rtos/zephyr/commit/3af88642d2921255979bef6703607ef2ee2897a3) lib: posix: mqueue: Minor formatting cleanups
- [d89249db](https://github.com/zephyrproject-rtos/zephyr/commit/d89249dbc58c070055e4b21d3ebc6130948d42b9) pthread: Respect cooperative thread schedulign in condition variable
- [e7648ba3](https://github.com/zephyrproject-rtos/zephyr/commit/e7648ba320fc8e5b7a99e12a503cca2f079f3479) lib: posix: pthread_common: Fix potential integer overflow issue
- [9faa42f5](https://github.com/zephyrproject-rtos/zephyr/commit/9faa42f5225d7a416f61652c5c482301afd6aa6c) slist: abstract node and list implementation
- [0ec79d68](https://github.com/zephyrproject-rtos/zephyr/commit/0ec79d6853b7fcc77c83ad5128b8170dda044032) lib: json: Efficiently pack field name, offset, alignment, type

Maintainers (1):

- [517a08ee](https://github.com/zephyrproject-rtos/zephyr/commit/517a08ee1370cf3ae42557347d1f6a4e386a2261) CODEOWNERS: Add myself as the Codeowner for LED API and drivers

Miscellaneous (6):

- [81f4b111](https://github.com/zephyrproject-rtos/zephyr/commit/81f4b111266e0d7cb3cfca26d487c76f5974b5ea) include: toolchain: common: Remove deprecated __stack macro
- [666274fa](https://github.com/zephyrproject-rtos/zephyr/commit/666274fa60aed69e694c0e5257a3522f03be17c7) toolchain: gcc: Only use _Static_assert if building with C11
- [05169a02](https://github.com/zephyrproject-rtos/zephyr/commit/05169a02ceaba0af31ecd7e33fcff8216d145a31) toolchain: common: Allow multiple uses of BUILD_ASSERT() in same scope
- [83ac3e24](https://github.com/zephyrproject-rtos/zephyr/commit/83ac3e24d82967eafef3f50da9eee6108a5cc593) shell: kernel: Add reboot command
- [f8c1cc17](https://github.com/zephyrproject-rtos/zephyr/commit/f8c1cc175a384d7e92360fae95738fc9352cf94d) toolchain: update xtools config
- [b3153d24](https://github.com/zephyrproject-rtos/zephyr/commit/b3153d2405210604583030aecffd5b047fdaa885) intel_s1000: scripts: debug, debugserver and flash scripts

Networking (8):

- [c0d0a61b](https://github.com/zephyrproject-rtos/zephyr/commit/c0d0a61bcc4f594df6e72fc39acd019b827d07c8) net: ipv6: Remove irrelevant error log
- [460a6c77](https://github.com/zephyrproject-rtos/zephyr/commit/460a6c77c5269f08bbe6fdfe5a08ec36188c8249) net: tcp: send_syn_segment: Log packet before it's sent
- [bf185f58](https://github.com/zephyrproject-rtos/zephyr/commit/bf185f58eb317599ba6684123e327a2d43e8b4da) net: ipv6: Fix crash from double free of fragment
- [8c561994](https://github.com/zephyrproject-rtos/zephyr/commit/8c561994f275e9ed176c4d1f6e0f3840a422e2bf) net: http: Fix client compilation if HTTPS is enabled
- [a12138d4](https://github.com/zephyrproject-rtos/zephyr/commit/a12138d45c866db4dad6b3999755cbc94f63452d) net: hostname: Fix hostname buffer length
- [2002a4e2](https://github.com/zephyrproject-rtos/zephyr/commit/2002a4e2450ee594ff1be41f31c5b809bc3ec9a5) net: arp: Do not access NULL network packet
- [3da4d370](https://github.com/zephyrproject-rtos/zephyr/commit/3da4d3700326e02d0998784a275d98d7a8c8d7e8) net: Implement VLAN priority to packet priority conversion
- [d1715685](https://github.com/zephyrproject-rtos/zephyr/commit/d1715685829f90f89e2e2715c960b709ba6dda99) net: icmpv6: Fix payload length and checksum

Samples (26):

- [162b6e4b](https://github.com/zephyrproject-rtos/zephyr/commit/162b6e4b35fa8473ccab21d99269ad2104141ee8) samples: Allow use of "CONTROLLER" postfix for LED and GPIO
- [d38116cb](https://github.com/zephyrproject-rtos/zephyr/commit/d38116cb03a840aa10b71c8b456c4c1fbe6aa110) usb: Use new USB Device interface for Bluetooth over USB sample
- [fc5134b0](https://github.com/zephyrproject-rtos/zephyr/commit/fc5134b03fc2a459d06c18b83df93c0207951ded) usb: hci_usb: Fix test name
- [d665e128](https://github.com/zephyrproject-rtos/zephyr/commit/d665e1283348d9033129ea70d5b3b086e9c9c5b9) usb: hci_usb: Correct README
- [b35274a4](https://github.com/zephyrproject-rtos/zephyr/commit/b35274a4e9aebb93660f99c6a0b7231cb3ea49ba) samples: usb: webusb: Prettify binary object store descriptor
- [a9d377e0](https://github.com/zephyrproject-rtos/zephyr/commit/a9d377e08d5227a4e75b44d1ee8e1eae7a706870) usb: wpanusb: Replace char array with structs for descriptor table
- [10ec019a](https://github.com/zephyrproject-rtos/zephyr/commit/10ec019a30d329011588cca9eab9ba8ad59af177) usb: wpanusb: Replace local hexdump() with net_hexdump()
- [9e753f0c](https://github.com/zephyrproject-rtos/zephyr/commit/9e753f0c20e162b9b4ce3b8d7b08374010f65c59) usb: wpanusb: Clean up code
- [c8e23874](https://github.com/zephyrproject-rtos/zephyr/commit/c8e238740201ea959c8dfbee0838a4a3be0178c6) usb: wpanusb: Remove unused headers
- [a5e7a8de](https://github.com/zephyrproject-rtos/zephyr/commit/a5e7a8deec102c1133d939bdab1f2621709ff918) usb: wpanusb: Remove unused packet handlers
- [74d08efb](https://github.com/zephyrproject-rtos/zephyr/commit/74d08efbf274009c83b6d4970a7be49eff15e8e5) usb: wpanusb: Correct protocol description
- [7337f4a0](https://github.com/zephyrproject-rtos/zephyr/commit/7337f4a06939ffa4c2ae1234f243019ac16d57a4) usb: wpanusb: Code cleanup
- [acb0f099](https://github.com/zephyrproject-rtos/zephyr/commit/acb0f0990eb5e89bebc0722c2aa27573c9d4e713) samples: echo_server: Update prj_cc2520 configuration
- [2b47d358](https://github.com/zephyrproject-rtos/zephyr/commit/2b47d3583927181bccffe5d165fc11fd6eea48e4) usb: wpanusb: Fix regression with putting LQI to wrong place
- [24cc5cc4](https://github.com/zephyrproject-rtos/zephyr/commit/24cc5cc4abb9c7fa5ee9beaa84d6705b9755af6a) usb: wpanusb: Make generic interface to raw 802.15.4 channel
- [190e8d96](https://github.com/zephyrproject-rtos/zephyr/commit/190e8d961c32eca2053f93c66f3ae47b54997062) usb: wpanusb: Fix setting wrong length
- [30c3461e](https://github.com/zephyrproject-rtos/zephyr/commit/30c3461e9ba3a9a50fb0aea9a81f0c0c10e7aa04) samples: lwm2m: replace prj_dtls.conf with overlay fragment
- [5df33d67](https://github.com/zephyrproject-rtos/zephyr/commit/5df33d67fd5c626e11657b345e96f0dd0d5357aa) samples: lwm2m: add overlay conf to support BT networking
- [970b0a99](https://github.com/zephyrproject-rtos/zephyr/commit/970b0a991615991122d02f2a13fe53afc16de8d4) samples: lwm2m: update README with use of overlay files
- [f59a68b6](https://github.com/zephyrproject-rtos/zephyr/commit/f59a68b6d8ec87ea8ec5623304aa4ff33194a9ee) samples: net: http: Add TLS compilation test
- [6c70aa28](https://github.com/zephyrproject-rtos/zephyr/commit/6c70aa28d2bf06f449533bca4c068af7287409c2) samples: net: Fix CoAP server payload dump function
- [1572594b](https://github.com/zephyrproject-rtos/zephyr/commit/1572594b532ea36f81661bab76231d3d3cf91cbb) samples: drivers: Add sample application for LP3943
- [b27d9685](https://github.com/zephyrproject-rtos/zephyr/commit/b27d96850fae9b731a5579e50040fe55af0b090b) samples: bluetooth: Add Apple iBeacon demo application
- [2d1c5241](https://github.com/zephyrproject-rtos/zephyr/commit/2d1c5241bf28ba9250815a0031b34da2f1d0bf93) samples: flash_shell: Use correct flash write block size
- [a6eee02c](https://github.com/zephyrproject-rtos/zephyr/commit/a6eee02c00d6bc391ca64c7ae75f0c48c6cc8038) samples: enhance integration sample and document it
- [00c26d24](https://github.com/zephyrproject-rtos/zephyr/commit/00c26d24b262c16d22a4544cbc3f86e08b0e9099) samples: remove stray config

Scripts (9):

- [b742b62b](https://github.com/zephyrproject-rtos/zephyr/commit/b742b62b6e2e402fbc0a159d180389dd912539f6) kconfiglib: Update to get split_expr() in
- [f3caef8e](https://github.com/zephyrproject-rtos/zephyr/commit/f3caef8eac6158e6f4a59ba810364753ee998a45) scripts: extract_dts_inlcudes: look up compatible field in parents
- [69beec87](https://github.com/zephyrproject-rtos/zephyr/commit/69beec87b18d4e8a8b768dad5fbeef68b1878191) scripts: extract_dts_includes: generate controller #define's
- [39dc7d03](https://github.com/zephyrproject-rtos/zephyr/commit/39dc7d03f706d9983ac7583047712457f4c54b05) scripts: gen_kobject_list: Generate enums and case statements
- [d3bfbfeb](https://github.com/zephyrproject-rtos/zephyr/commit/d3bfbfeb17755aa20dba77eee1342b82acb11d1d) kconfiglib: Update to get choice.direct_dep in
- [73549ad8](https://github.com/zephyrproject-rtos/zephyr/commit/73549ad85275359626117a3f3d62d3f8086f7069) scripts: kconfig: Add a Python menuconfig implementation
- [cfb3c925](https://github.com/zephyrproject-rtos/zephyr/commit/cfb3c9251c8780c90d2064393a5f4a21569af7de) kconfiglib: Update to add warning for malformed .config lines
- [1799cfdb](https://github.com/zephyrproject-rtos/zephyr/commit/1799cfdb2f199a3f8a40327de73d14c90db98c63) scripts: kconfig: Turn malformed .config lines into errors
- [dc97fc2a](https://github.com/zephyrproject-rtos/zephyr/commit/dc97fc2a609eb4c1d64b2c963094e18682bfcaea) kconfiglib: Update to default to UTF-8 for Python 3

Storage (4):

- [9fe30535](https://github.com/zephyrproject-rtos/zephyr/commit/9fe30535d781790d2864686e2595f2d1a29d718e) susbsys: settings: fix coverity issues
- [341b4273](https://github.com/zephyrproject-rtos/zephyr/commit/341b42736609fce4d2c4a3f33656567c1d95f009) subsys: settings: fix fcb back-end initialization
- [9968cda4](https://github.com/zephyrproject-rtos/zephyr/commit/9968cda453ac7a91d513b6a50817c926c3fe5cc6) fs: Convert NFFS partition to a generic one
- [d67009da](https://github.com/zephyrproject-rtos/zephyr/commit/d67009da082ff2e77ab35a47e1428632a83b414b) subsys: settings: Fix Kconfig dependencies

Testing (31):

- [1931f124](https://github.com/zephyrproject-rtos/zephyr/commit/1931f1242ba2e34108ba3a0e1a29a1b879e7122d) tests: fix arc related codes
- [edc048e0](https://github.com/zephyrproject-rtos/zephyr/commit/edc048e06f21fa4bb4cf81cd117d24b4acdf5166) tests: socket: udp: Make sure client sockaddr fully initialized
- [e8bcc6f1](https://github.com/zephyrproject-rtos/zephyr/commit/e8bcc6f1f0065dfc4a614f55c7d100a6ec2d49e1) tests: socket: Free resources with freeaddrinfo
- [1d1db121](https://github.com/zephyrproject-rtos/zephyr/commit/1d1db121d351b91ea1023f2c3188a938a841372c) tests: socket: udp: Tighten up error checking
- [e564d58b](https://github.com/zephyrproject-rtos/zephyr/commit/e564d58b7d08d7b7577d4c8d83272a756c0ba076) tests: socket: udp: Close test sockets
- [1609f251](https://github.com/zephyrproject-rtos/zephyr/commit/1609f251eedf9322dc4ee7f661a27fcfe1c9b7f9) tests: kernel: style, tag, and category fixes
- [63f21391](https://github.com/zephyrproject-rtos/zephyr/commit/63f21391b94716e8431309ecd9f1e05db8d63f29) tests: use consistent test function names
- [1f2627a6](https://github.com/zephyrproject-rtos/zephyr/commit/1f2627a638db741f31024e175850f377c1c5fb15) tests: net: style, tag, and category fixes
- [9312de00](https://github.com/zephyrproject-rtos/zephyr/commit/9312de00770854b73188e5eef87068209e01dca8) tests: crypto: style, tag, and category fixes
- [89a50932](https://github.com/zephyrproject-rtos/zephyr/commit/89a50932d311d92ff18b91398ec2bc676c338147) tests: posix: style, tag, and category fixes
- [fa6cce43](https://github.com/zephyrproject-rtos/zephyr/commit/fa6cce430cef1fce94f20527f12feddd0bec74a1) tests: ztest: style, tag and category fixes
- [0f5a88b0](https://github.com/zephyrproject-rtos/zephyr/commit/0f5a88b0ef354aeee919e755b298b39469d041b2) tests: posix: mqueue remove extra printk
- [910a569e](https://github.com/zephyrproject-rtos/zephyr/commit/910a569ea7b7f2a93582996ce220fb65dafd85aa) tests: stackprot: move to ztest
- [20495e89](https://github.com/zephyrproject-rtos/zephyr/commit/20495e897bfc78c5ec6e7c7792ee496c73e79c49) ztest: support skipping tests
- [7a5ff137](https://github.com/zephyrproject-rtos/zephyr/commit/7a5ff13703a0139f917afd58151934b5fcf19bb9) tests: allow unsupported tests to be skipped
- [eb6f2031](https://github.com/zephyrproject-rtos/zephyr/commit/eb6f20318e618a3ddf3b0b930fe211e50a37832c) tests: fix meta data of peripheral tests
- [7753bc50](https://github.com/zephyrproject-rtos/zephyr/commit/7753bc5065eb6750980228daa7f9993ae11a9cb7) tests: kernel: mem_protect: tests for userspace mode.
- [b4cb1014](https://github.com/zephyrproject-rtos/zephyr/commit/b4cb10142774cfb1724f766ae93c2baf1ff19f97) tests: mem_prot: skip unsupported tests
- [9a2b5357](https://github.com/zephyrproject-rtos/zephyr/commit/9a2b5357ea48b37732e2bc28f0697c1881577fb8) tests: settings: Remove references to non-existent Kconfig variable
- [6f1cff73](https://github.com/zephyrproject-rtos/zephyr/commit/6f1cff733e90fce3554b6aac66cc4f83b60da3d8) ztest: fix result checking
- [3298d60f](https://github.com/zephyrproject-rtos/zephyr/commit/3298d60ff94d2f90d1dbb0f6c3cd28bc056b7ad8) tests: subsys: settings: Add FCB-beckend initialization test
- [ff0857df](https://github.com/zephyrproject-rtos/zephyr/commit/ff0857df25c298d94ca3e9e0d6d7b45a547b13ea) tests: threads: Add test to verify delayed thread abort
- [2182a53f](https://github.com/zephyrproject-rtos/zephyr/commit/2182a53fecc23a4fa3626bdcf915dc5d0405b991) tests: irq_offload: document test functions
- [25e7b27b](https://github.com/zephyrproject-rtos/zephyr/commit/25e7b27be5eaf54ededf0d3d10da46af5bb27866) tests: critical: document test functions
- [67194a40](https://github.com/zephyrproject-rtos/zephyr/commit/67194a40ef5026e8d86bd5dccff6bc395359ac55) tests: errno: document test functions
- [2b62f1ab](https://github.com/zephyrproject-rtos/zephyr/commit/2b62f1ab0234a84b7e7afac493e0f94e381b25c5) tests: fixed doxygen comments
- [18cc28a9](https://github.com/zephyrproject-rtos/zephyr/commit/18cc28a9e7f16d03068b18cd2481b37b00209f8c) tests: Fix malformed CONFIG_TEST=y prj.conf entry
- [567482ff](https://github.com/zephyrproject-rtos/zephyr/commit/567482ff357bf96907dec5ba86034a7ad158d00d) intel_s1000: tests: introduce tests to check features enabled
- [a2afa6cf](https://github.com/zephyrproject-rtos/zephyr/commit/a2afa6cf8ce64f3f25bfc577c29738f6a0da168a) test: board: intel_S1000: Add test application for HID
- [e57df9a3](https://github.com/zephyrproject-rtos/zephyr/commit/e57df9a3ed8b39cd0f3dbb54e586861311a416e2) tests: boards: intel_s1000_crb: select application based on config
- [b3275d65](https://github.com/zephyrproject-rtos/zephyr/commit/b3275d651ca2d45c3f95665bfc5751424f57e6a6) tests/samples: add hw dependencies

