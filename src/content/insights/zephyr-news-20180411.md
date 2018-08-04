+++
title = "Zephyr Newsletter 11 April 2018"
date = "2018-04-11"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

Zephyr News
===========

This is the first of a periodic (weekly-ish) newsletter tracking the
latest [Zephyr](https://www.zephyrproject.org/) development merged
into the [mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

The goals are to give a human-readable summary of what's been merged
into master, breaking it down as follows:

- **Highlights**
  - Important changes
  - New features
  - Bug fixes
- **Individual changes**: a complete list of patches, sorted chronologically
  and categorized into areas, like:
  - Architectures
  - Kernel
  - Drivers
  - etc.

<!--more-->

The "Important changes" section will include things like API breaks
and some significant features. The focus is on changes in Zephyr that
are likely to require changes in your Zephyr applications.

The new features and bug fixes sections aren't meant to be exhaustive; the
idea is to cover what happened from a high level. You can check the individual
changes section for a complete list of commits in areas you're interested in.

Highlights
==========

This newsletter covers changes in Zephyr between these two
commits:

- [4291fb67](https://github.com/zephyrproject-rtos/zephyr/commit/4291fb67a35bcc2c2f7a3ccd1d785c42dc9d96e4)
  ("usb: Remove duplicated CDC_ECM_SUBCLASS definition"), Apr 4 2018
- [9bde3c06e](https://github.com/zephyrproject-rtos/zephyr/commit/9bde3c06e1a679985ab8779248ce76c445531426)
  ("tests: build_all: Add LPS22HB and LSM6DSL sensors build test"),
  Apr 10 2018

The most significant of these changes are due to a large re-work
of the SPI APIs, which affected both the peripheral drivers
themselves as well as their users.

Important Changes
-----------------

**SPI API:**

The SPI API (in include/spi.h) has been re-worked and
finalized. All in-tree users were upgraded to the new API. The
old SPI API, and all of its implementations, have been
removed. Out of tree uses of the old SPI API will need updates. A
summary of the API changes follows.

The I/O APIs now use a new struct spi_buf_set, which contains a
pointer to a struct spi_buf array, and its length:

```
    struct spi_buf_set {
           const struct spi_buf *buffers;
           size_t count;
    };
```

This structure is used in the I/O APIs so that the TX and RX
arguments can be specified in two formal parameters, which allows
using registers instead of the stack in some API calls.

All SPI API calls also now take a pointer to the SPI device
itself as their first parameter, instead of storing that device
in struct spi_config. This makes the SPI API consistent with
other Zephyr device APIs.

The "EEPROM mode" support was removed from the master controller
operations bit mask.  It was replaced with a new flag,
SPI_CS_ACTIVE_HIGH, which inverts the usual polarity of the chip
select pin.

The spi_config parameter passed to the SPI API is now constant,
allowing it to be stored in flash memory.

The asynchronous SPI API no longer uses CONFIG_POLL
directly. Instead, a layer of indirection through
CONFIG_SPI_ASYNC was introduced, which selects CONFIG_POLL.

In addition to these changes in the SPI master mode API,
experimental support for SPI slave implementations was added to
the new API.

**Board Porting Guidelines:**

Official board porting guidelines were merged, which have
consistent rules for how to structure a board's Kconfig. For
details, refer here:

http://docs.zephyrproject.org/porting/board_porting.html#default-board-configuration

Features
--------

**VLAN support**:

VLAN support was added for Ethernet network
interfaces. Initial support is provided for for mcux, native
POSIX, and Atmel E70. The SLIP driver also has VLAN support.

New net shell commands "net vlan", "net vlan add", and "net
vlan del" were added to query and manipulate the VLAN
configuration.

A new sample application, samples/net/vlan, was added, which
can be used to set VLAN tags for ethernet interfaces.

As part of these and other network changes, the ethernet
files now live in their own directory, net/ip/l2/ethernet.

**Red/black trees**:

A new red/black balanced binary tree implementation was
added; the API is available in include/misc/rb.h. Like the
linked list types, the structure is *intrusive*: red-black
tree nodes are meant to be embedded in another structure,
which contains the user data associated with that node. Code
size compared to a doubly linked list on most architectures
is approximately an additional 2-2.5 KB.

**Completion of DTS support for I2C and SPI on STM32**:

All STM32-based boards now use device tree for I2C and SPI
peripherals.

**Bluetooth generalizations**:

Continuing the effort to generalize the core Bluetooth
subsystem across SoCs, the Bluetooth "ticker" timing API now
includes a generic hal/ticker.h file, which abstracts out SoC
specific definitions.

**Drivers**:

Ethernet is now enabled by default on the sam_e70_xplained
board.

New driver support includes SPI on nRF52, an interrupt in
transfer callback on USB HID, USB CDC EEM support for
encapsulating Ethernet packets over a USB transport, and GPIO
triggering for the ST LSM6DSL accelerometer and IMU.

**Boards**:

New boards include the SiFive HiFive1 and Nordic nRF52
Thingy:52 (PCA20020).

**Speeding up CI**:

An effort is underway to reduce the amount of time spent in
CI. To that end, an additional CI build slave was added, some
duplicative test coverage on qemu_x86 and qemu_cortex_m32 was
eliminated, and other optimizations were performed.

**Boot banner changes**:

The boot banner now prints the git version (based on git
describe) and hash, but timestamps were removed from it by
default to increase the reproducibility of Zephyr builds.

**User mode memory pools**:

A new memory pool implementation which is compatible with use
from user mode threads was merged; the API is available in
include/misc/mempool.h. This implementation shares code with
the in-kernel k_mem_pool API, but avoids constraints that are
incompatible with user mode. Memory pools are defined at
compile time with SYS_MEM_POOL_DEFINE(), and initialized by
sys_mem_pool_init(). Memory may be allocated and freed from
an initialized memory pool with sys_mem_pool_alloc() and
sys_mem_pool_free(), respectively.

**Network interface management**:

Statistics collection is now per-interface.

The network shell command "net iface" can now enable or
disable network interfaces by index.

Initial support for ethernet interface configuration has been
merged. This includes a link speed capabilities query. An API
was also merged for changing hardware configuration; this
includes link speed, but is not limited to it.

Bug Fixes
---------

Support for enabling GPIO port H on STM32L0 was fixed.

Support accessing sub-region attributes on ARM MPUs was fixed.

A pair of Bluetooth mesh fixes were merged, including a null
dereference and an issue related to enabling node identity
advertising.

The behavior of the CONFIG_FP_SOFTABI option was fixed. It now
generates floating point instructions, rather than turning them
off, which it was doing previously.

The temperature sensor channel for the nRF TEMP IP block was
fixed; it is now SENSOR_CHAN_DIE_TEMP.

A fix was merged for k_thread_create(), which now properly checks
the provided stack size on systems which enforce power of two
sizes.

POSIX fixes for pthread_cancel and timer_gettime were merged.

Dozens of commits cleaning up and fixing the test cases were
merged.

Individual Changes
==================

**Patches by area (197 patches total)**

- Arches: 10
- Bluetooth: 3
- Boards: 10
- Build: 3
- Continuous Integration: 6
- Documentation: 12
- Drivers: 60
- External: 2
- Kernel: 5
- Libraries: 5
- Miscellaneous: 3
- Networking: 18
- Samples: 10
- Scripts: 6

**Arches (10):**

- [6d870ae2](https://github.com/zephyrproject-rtos/zephyr/commit/6d870ae25c5e722dfd7e9c9990ae82fa327c177f) arch/quark_se: Switch to native SPI DW driver
- [4652f59d](https://github.com/zephyrproject-rtos/zephyr/commit/4652f59d640b477782d1edcbe92dd2e3befa41fc) arch/quark_se_c1000_ss: Switch to SPI DW driver
- [1ac6f4bd](https://github.com/zephyrproject-rtos/zephyr/commit/1ac6f4bd5665152d171db9795d16199e78fe7f9c) arch/quark_d2000: Switch to SPI DW driver
- [a8685613](https://github.com/zephyrproject-rtos/zephyr/commit/a868561339c23a69a20a2162393467e8fc3eaab0) arch/quark_se: Enable SPI port 2 as a slave only
- [2d926f35](https://github.com/zephyrproject-rtos/zephyr/commit/2d926f3594cfc2c5faba56fa7a01025c31ba5e03) native: doc eth TAP: can only be compiled in Unix
- [700e4bd2](https://github.com/zephyrproject-rtos/zephyr/commit/700e4bd2e89f2565bbd340b1354ef727168398db) ARM: -march compile option is not set
- [6dae38cb](https://github.com/zephyrproject-rtos/zephyr/commit/6dae38cb98b38ea2ae5ea06996065477f0fcbb86) arch: riscv32: fe310: Always-On domain adress definition
- [77bbc42e](https://github.com/zephyrproject-rtos/zephyr/commit/77bbc42eafed9f2ff492f02cab20c4b80f794072) arch: arm: soc: stm32l0: fix port H EXTI
- [54842182](https://github.com/zephyrproject-rtos/zephyr/commit/548421828e402c9d7a06186c5d274a4a721fbf58) arm_mpu: fix _get_region_attr()
- [6c2047fc](https://github.com/zephyrproject-rtos/zephyr/commit/6c2047fcd011d2f3386edd7bd65e98d948449731) arch/arm: stm32: All SoCs have dts for I2C and SPI

**Bluetooth (3):**

- [b8042ea9](https://github.com/zephyrproject-rtos/zephyr/commit/b8042ea9ce1494e5dd30008c6c2d0d5069ae4434) Bluetooth: Mesh: Fix possible NULL dereferences in client models
- [d6a549ce](https://github.com/zephyrproject-rtos/zephyr/commit/d6a549ceba735c294d0dfae56edd9f7e1c9d7fe6) Bluetooth: Mesh: Fix Node Identity advertising with PB-ADV
- [6c6d98bc](https://github.com/zephyrproject-rtos/zephyr/commit/6c6d98bc4ed940d7fd8f36b3bbad44a622d569cc) Bluetooth: controller: Use hal/ticker.h to abstract SoC specifics

**Boards (10):**

- [1f0bfb85](https://github.com/zephyrproject-rtos/zephyr/commit/1f0bfb8529fd8d2e1de0b1dd2184eb47c676adea) boards/x86: Pinmux SPI port 2 relevantly on quark_se_c1000_devboard
- [3e54d391](https://github.com/zephyrproject-rtos/zephyr/commit/3e54d3914c2744a15c0231ae9e97a347fc4a6f07) boards: sam_e70_xplained: Enable L2 ethernet layer
- [938a9699](https://github.com/zephyrproject-rtos/zephyr/commit/938a969926da4b082ac94f38b70bef66987bfb6b) boards: SiFive HiFive1 board
- [9287a9bf](https://github.com/zephyrproject-rtos/zephyr/commit/9287a9bf68710f38e5ea7744d6e7eeb9a53b1efd) boards/arm/olimexino_stm32: Don't enable I2C and SPI
- [439a63da](https://github.com/zephyrproject-rtos/zephyr/commit/439a63daacec35af8349928baf0bc94a5ca61a12) boards: Add support for nRF52 Thingy:52 (PCA20020)
- [a068f29d](https://github.com/zephyrproject-rtos/zephyr/commit/a068f29dcc7f15686ce14102840ae963ea3414ae) boards: arm: nrf52_pca20020: Add board documentation
- [ea9a3451](https://github.com/zephyrproject-rtos/zephyr/commit/ea9a34518211f66a1c33759508874bf48cc06ffb) boards: native_posix: mark netif as supported
- [2ee6dff7](https://github.com/zephyrproject-rtos/zephyr/commit/2ee6dff77b8726b5f1191c0084c114410ae14494) boards: fix yaml syntax and reduce indentation
- [973ec4ea](https://github.com/zephyrproject-rtos/zephyr/commit/973ec4ea62b31e2c8970636c1773111d5b43567c) boards: reduce testing on the same platform with variations
- [de8d755c](https://github.com/zephyrproject-rtos/zephyr/commit/de8d755c5403d7ac43bfd8c4c5860abb33c1a3a4) boards: test networking only in one qemu type

**Build (3):**

- [7d301cbb](https://github.com/zephyrproject-rtos/zephyr/commit/7d301cbb6c208ce3fc48ee577105f9f48e13b115) cmake: qemu_x86: remove useless options
- [9be27f73](https://github.com/zephyrproject-rtos/zephyr/commit/9be27f73dbf57fc0834799a2ae2045c41be63509) kconfig: Make CONIG_FP_SOFTABI generate floating point instructions
- [daf7716d](https://github.com/zephyrproject-rtos/zephyr/commit/daf7716ddd44e367a414b9da89e1de846d699c04) build: use git version and hash for boot banner

**Continuous Integration (6):**

- [0df7e1c1](https://github.com/zephyrproject-rtos/zephyr/commit/0df7e1c1098761e4531b1981aca5b4fc22ed473e) ci: Increase number of build slaves to 5
- [424a3db7](https://github.com/zephyrproject-rtos/zephyr/commit/424a3db775d63a897d1098a04df6ea39a2451606) sanitycheck: do not always dump footprint statistics
- [20f553fe](https://github.com/zephyrproject-rtos/zephyr/commit/20f553fe8d3071b4ab32e587ef61f8871ad598f6) sanitycheck: do not call cmake twice on run
- [ab351f40](https://github.com/zephyrproject-rtos/zephyr/commit/ab351f407ad76e3395f3053c5165e37d50fc3784) sanitycheck: do not create overlays for filtered platforms
- [5df8cff0](https://github.com/zephyrproject-rtos/zephyr/commit/5df8cff046b0388362c750b72116c3bb2ea658e2) sanitycheck: simplify logic of build_only/enable_slow checking
- [75547e2b](https://github.com/zephyrproject-rtos/zephyr/commit/75547e2b401d3335555618f05d9d9d928b6d9d04) sanitycheck: add option to list all available tags

**Documentation (12):**

- [9782755a](https://github.com/zephyrproject-rtos/zephyr/commit/9782755a55e14f6db03b6a7fd3a6f109d972936b) native doc: minor improvement in ethernet driver
- [51658761](https://github.com/zephyrproject-rtos/zephyr/commit/5165876164e18dc7b5c10dd7b85c7ac7c418f56d) doc: Add a comment describing the algorithm used by entropy_nrf5.c
- [6fd8a0b3](https://github.com/zephyrproject-rtos/zephyr/commit/6fd8a0b3ca8865a47f78029ef216b56a349d380c) doc: dts: Add reference to mcuboot flash partitions
- [8a8d9818](https://github.com/zephyrproject-rtos/zephyr/commit/8a8d981822aea9ed377daef0a80334eddf6a40ee) doc: subsys: Add dfu and mgmt subsytem doc
- [cd05a630](https://github.com/zephyrproject-rtos/zephyr/commit/cd05a630c80767ff47dba66384dc3773485bb861) doc: getting_started: Modernize macOS instructions
- [4b782253](https://github.com/zephyrproject-rtos/zephyr/commit/4b782253930e7c749c6b433180020a0bb1807977) doc: usb: Update API doc
- [3314c367](https://github.com/zephyrproject-rtos/zephyr/commit/3314c3675f7bf36b8bacff500c1f89a9b6057a44) doc: misspellings in public API doxygen comments
- [e48b64d1](https://github.com/zephyrproject-rtos/zephyr/commit/e48b64d1be21823f4fa702bece1c8950bc40dfcc) doc: fix doc misspellings in doc, boards, samples
- [9abc31e3](https://github.com/zephyrproject-rtos/zephyr/commit/9abc31e315a5f7e2bd9485fc8824430a60ef2ea1) doc: clean up QEMU networking doc
- [f1275a78](https://github.com/zephyrproject-rtos/zephyr/commit/f1275a78f25eb01a6b0028f7d98b177112ba1a4a) doc: subsystem: settings subsystem doc
- [361ef340](https://github.com/zephyrproject-rtos/zephyr/commit/361ef3404390c2c485c85c16ac4d0e77a3ce7617) doc: subsys: Remove unnecessary subsystem from titles
- [97083720](https://github.com/zephyrproject-rtos/zephyr/commit/9708372080ce054d6978eef6fdc66116b4c53bd2) doc: provide board porting guidelines

**Drivers (60):**

- [4291fb67](https://github.com/zephyrproject-rtos/zephyr/commit/4291fb67a35bcc2c2f7a3ccd1d785c42dc9d96e4) usb: Remove duplicated CDC_ECM_SUBCLASS definition
- [efa3a137](https://github.com/zephyrproject-rtos/zephyr/commit/efa3a137cfaaa2c25bd1f2c48c2c20257da33753) usb: Remove duplicated ACM_SUBCLASS definition
- [d89e8e6a](https://github.com/zephyrproject-rtos/zephyr/commit/d89e8e6a79d670d506cfe22386154fde25e3c5b5) drivers/spi: Cleanup the Kconfig files
- [32426542](https://github.com/zephyrproject-rtos/zephyr/commit/324265420b75303cc52ea1b157fb8098a12637a6) api/spi: Disable legacy API by default
- [f3f9fab2](https://github.com/zephyrproject-rtos/zephyr/commit/f3f9fab20e97789118325da79783a1c5b479da26) api/spi: Make spi_config parameter constant
- [ea2431f3](https://github.com/zephyrproject-rtos/zephyr/commit/ea2431f32f79c79c7750149e699e2df05e3f2435) api/spi: Reduce parameter number on transceive function
- [da42c007](https://github.com/zephyrproject-rtos/zephyr/commit/da42c0077c80e71a34f45323428a1e5dc8aeccac) api/spi: Add a dedicated Kconfig option for asynchronous mode enablement
- [7b185831](https://github.com/zephyrproject-rtos/zephyr/commit/7b185831b858f33e0267561ecaaacaf81997405e) api/spi: Removing eeprom mode in configuration
- [9b27f29c](https://github.com/zephyrproject-rtos/zephyr/commit/9b27f29c99c22f2f74810e999d7d0ba2e08ce264) api/spi: Add octal MISO lines mode
- [f44ba8e7](https://github.com/zephyrproject-rtos/zephyr/commit/f44ba8e7d4849d8f141a427a154f0f2783a35128) api/spi: Make cs attribute in struct spi_config constant
- [d4065ae7](https://github.com/zephyrproject-rtos/zephyr/commit/d4065ae73e8d2dcbeae640223bc15f906ee610a8) drivers/ieee802154: Switch CC2520 to new SPI API
- [16cb7ab8](https://github.com/zephyrproject-rtos/zephyr/commit/16cb7ab883332fce0b6075c0e840c1919db23862) drivers/flash: Switch W25QXXDV driver to new SPI API
- [244c2af1](https://github.com/zephyrproject-rtos/zephyr/commit/244c2af154cedcdfe3377cd7c76d0793ccdad969) drivers/sensors: Switch bme280 driver to new SPI API
- [eb7af552](https://github.com/zephyrproject-rtos/zephyr/commit/eb7af5527d5e58ca60baa88193dd53c57cfb3224) drivers/sensors: Switch bmi160 driver to new SPI API
- [94d7c9f2](https://github.com/zephyrproject-rtos/zephyr/commit/94d7c9f23e84e5eadb86527617a4035b4f62e372) drivers/sensors: Switch adxl362 driver to new SPI API
- [2f7e6b6d](https://github.com/zephyrproject-rtos/zephyr/commit/2f7e6b6d42af8f652b63ce58381fbf2232991681) drivers/sensors: Switch lis2dh driver to new SPI API
- [d620c16a](https://github.com/zephyrproject-rtos/zephyr/commit/d620c16a0d72881cdafa5b171d836659656f6c17) drivers/adc: Switch ti_adc108s102 driver to new SPI API
- [595340ab](https://github.com/zephyrproject-rtos/zephyr/commit/595340ab8a7b31333ee6ab40a5e238447e6bcb55) drivers/bluetooth: Switch SPI based HCI driver to new SPI API
- [3219817d](https://github.com/zephyrproject-rtos/zephyr/commit/3219817d4a8bd940ebb1408484bdd1a0be086438) drivers/bluetooth: Get rid completely of legacy SPI API in SPI HCI
- [29a68cd7](https://github.com/zephyrproject-rtos/zephyr/commit/29a68cd7a547c96acca08142fa53c15661b4c260) drivers/spi: Adapt Kconfig and generic context to enable slave support
- [659f0f2d](https://github.com/zephyrproject-rtos/zephyr/commit/659f0f2d209df271729b7e21fad46220794ac9c5) api/spi: Add the possibility to request CS active high logic
- [2a14d289](https://github.com/zephyrproject-rtos/zephyr/commit/2a14d289e585dede245608f5a2acb0824bed74a6) drivers/ethernet: Switch enc28j60 to new SPI API
- [7f4378e2](https://github.com/zephyrproject-rtos/zephyr/commit/7f4378e232a60045014ff77fcc9dda752cd17305) api/spi: Precise a bit the documentation
- [57a1f7b4](https://github.com/zephyrproject-rtos/zephyr/commit/57a1f7b4f1048612db50615023644622607f0622) drivers/spi: Add support for TX or RX only modes on DW driver
- [44d4de51](https://github.com/zephyrproject-rtos/zephyr/commit/44d4de5105eda14f42012241ffd4e9c16056c4db) drivers/spi: Remove legacy DesignWare SPI driver
- [423f0095](https://github.com/zephyrproject-rtos/zephyr/commit/423f0095c7b83f29f74a8d7563b35a4f72ad2902) drivers/spi: Specify options per-port on DW driver
- [29f8b23b](https://github.com/zephyrproject-rtos/zephyr/commit/29f8b23bfd7d1306c87d9675e8687c0ead96e5ea) drivers/clock_control: Enable ARC core support on quark_se driver
- [a8634944](https://github.com/zephyrproject-rtos/zephyr/commit/a863494463362cecb7ca047a20d16e4c1738bede) drivers/spi: Enable port 3 and 4 on DW driver
- [dc49d0f3](https://github.com/zephyrproject-rtos/zephyr/commit/dc49d0f3619d8fb7d72549a4d0df3345f2305955) drivers/spi: Fix typo on parameters type in DW arc regs definitions
- [0a43cac3](https://github.com/zephyrproject-rtos/zephyr/commit/0a43cac3bb5e75f0b0d22a321aa635a5c7285191) drivers/spi: Removing QMSI driver as it does not support new API
- [65f6c967](https://github.com/zephyrproject-rtos/zephyr/commit/65f6c9673666791fce802f5ff0f9591ffb820004) drivers/spi: Switch Intel driver to new SPI API
- [ef5152ab](https://github.com/zephyrproject-rtos/zephyr/commit/ef5152ab2297b3a103a5e987df305c2aaad05ded) spi: Implement new spi api in the mcux dspi driver
- [b62b12ee](https://github.com/zephyrproject-rtos/zephyr/commit/b62b12eef818582c6e26ec950751218a226a3e9f) drivers/ieee802154: Switch MCR20A driver to new SPI API
- [09dd5e9b](https://github.com/zephyrproject-rtos/zephyr/commit/09dd5e9b2207c0ffabc16f0308ab0036b18bd3a6) drivers/spi: Remove legacy API support from mcux dspi driver
- [00397c65](https://github.com/zephyrproject-rtos/zephyr/commit/00397c65bc91bf3bc54a4f28fd31b5a43a05bcb3) drivers: spi: Add shim for nrfx SPI driver
- [841a4207](https://github.com/zephyrproject-rtos/zephyr/commit/841a4207094c617648a8e34c20dd35c672d35751) drivers/spi: Add slave mode support to the DesignWare driver
- [79308dd1](https://github.com/zephyrproject-rtos/zephyr/commit/79308dd1a82fd054b33b190d10fe26cdb2cae6d7) drivers/spi: Simplify how error is forwarded from ISR handler in DW
- [1086fdf1](https://github.com/zephyrproject-rtos/zephyr/commit/1086fdf1f489e267d6d0c28e17a220dacac00a2a) drivers/spi: spi_context lock makes transceive function reentrant in DW
- [b702236d](https://github.com/zephyrproject-rtos/zephyr/commit/b702236d1a49cd517baf35c1cd3328bb136fbfee) drivers/ethernet: No need of semaphore for spi in enc28j60
- [d5e6874d](https://github.com/zephyrproject-rtos/zephyr/commit/d5e6874d64de4848dbee0a7c626054693a07197c) drivers/ieee802154: No need of semaphore for spi in mcr20a
- [13dba12b](https://github.com/zephyrproject-rtos/zephyr/commit/13dba12b9a2d1794058ef7f9fb79622aaff4a726) drivers/spi: Remove legacy NRF5 master and slave drivers
- [3f4cffc3](https://github.com/zephyrproject-rtos/zephyr/commit/3f4cffc3027ec2ea1103a3db4651074173020c50) spi: Remove SPI legacy API
- [f1ae9402](https://github.com/zephyrproject-rtos/zephyr/commit/f1ae94027adfe866acd5ab12ccff5c5462ee3ea6) api/spi: Slave transactions will return received frames on success
- [bdd03f38](https://github.com/zephyrproject-rtos/zephyr/commit/bdd03f388b4c357b11ae9c694b4a9c9c5945a8a9) drivers: sensor: temp_nrf5: fix sensor type
- [42a96c56](https://github.com/zephyrproject-rtos/zephyr/commit/42a96c56677029407a8781f3275d9ce0aabc0193) drivers: clock_control: quark_se: Fix "make menuconfig"
- [011ad6f7](https://github.com/zephyrproject-rtos/zephyr/commit/011ad6f7dbe0a5bcd4d0bb1be98907a990c3ab8b) drivers/spi: Fix tmod update on DW driver
- [aaa9cf2e](https://github.com/zephyrproject-rtos/zephyr/commit/aaa9cf2edd648bd06cd45ae72096369bb5b5ba27) drivers: entropy: nrf5: Clarify Kconfig options
- [7385e388](https://github.com/zephyrproject-rtos/zephyr/commit/7385e3880262012a3538d9f7d48bc1f2480bb97e) drivers: eth: mcux: Enabling VLAN
- [02ee3651](https://github.com/zephyrproject-rtos/zephyr/commit/02ee3651ed1a3cf339253ae43c4796d58a381d08) drivers: eth: gmac: Adding VLAN support to Atmel E70 board
- [73b43e00](https://github.com/zephyrproject-rtos/zephyr/commit/73b43e002408e08cd34d55a941836c7ed2bb7590) drivers: eth: native_posix: Add VLAN support
- [2c343d2b](https://github.com/zephyrproject-rtos/zephyr/commit/2c343d2b255220ad6d5a2d877c223aabc20a8b97) drivers: net: slip: Add VLAN support
- [ed923da4](https://github.com/zephyrproject-rtos/zephyr/commit/ed923da4355ae8b895113687bbe78e8e4b5fff83) drivers: net: mcux: Use VLAN priority to set RX packet priority
- [992e3284](https://github.com/zephyrproject-rtos/zephyr/commit/992e32842bf28dcaebe51a9020859c225b1fed3a) usb: netusb: Rework netusb media connect/disconnect
- [d80ae8ae](https://github.com/zephyrproject-rtos/zephyr/commit/d80ae8aeeb48abc5562998ba270a1bba12046f54) usb: netusb: Add CDC EEM network usb function
- [0d04aef6](https://github.com/zephyrproject-rtos/zephyr/commit/0d04aef6fe8389b649fe1a8c17ea1cc022c7264c) usb: hid: add a INT IN transfer complete callback.
- [dbb22644](https://github.com/zephyrproject-rtos/zephyr/commit/dbb22644540fb531c339efffe9d8ef83cdf49beb) usb: hid: implement set_report()
- [8d2b22cd](https://github.com/zephyrproject-rtos/zephyr/commit/8d2b22cd05cb91ae519a8d7c1aaeef2a22623722) drivers: timer: expose RTC1 ISR handler function
- [fbd3c2f4](https://github.com/zephyrproject-rtos/zephyr/commit/fbd3c2f4e2c0ad81272e7b39d966905b697561c2) sensors: ccs811: Deassert the reset pin with GPIO
- [8e1cf7b6](https://github.com/zephyrproject-rtos/zephyr/commit/8e1cf7b6196c0bd3668ff536de01a226e7519d3d) gpio: nrf5: Make the init priority configurable
- [6fb326ce](https://github.com/zephyrproject-rtos/zephyr/commit/6fb326ce06633eb6661e4b1b388ca46eed3d8e2a) drivers: sensor: lsm6dsl: add trigger support

**External (2):**

- [ca1cb054](https://github.com/zephyrproject-rtos/zephyr/commit/ca1cb0543820b2d57b1afce1493e3e0e0624f267) ext: lib: tinycbor: fix Zephyr specific settings
- [00f6fc96](https://github.com/zephyrproject-rtos/zephyr/commit/00f6fc96435ebf01db5920c784c04e70f6bbee19) ext: lib: tinycbor: fix half-FP feature compilation

**Kernel (5):**

- [f762fdf4](https://github.com/zephyrproject-rtos/zephyr/commit/f762fdf4828f1c530cc0aac352405d93521fb79c) kernel: posix: move sleep and usleep functions into c file.
- [95f14322](https://github.com/zephyrproject-rtos/zephyr/commit/95f14322759ca82d406c197ef51950e8381c6817) sys_mem_pool: add test case
- [bf44bacd](https://github.com/zephyrproject-rtos/zephyr/commit/bf44bacd24f77509c3bc950ec770f96333345a38) kernel: mutex: Copy assertions to assertions to syscall handler
- [18cb8326](https://github.com/zephyrproject-rtos/zephyr/commit/18cb832646e0a331d7bdf86e47067437daa713a2) kernel: Disable build timestamps by default for reproducibility
- [ec7ecf79](https://github.com/zephyrproject-rtos/zephyr/commit/ec7ecf7900289fda94d29b469cd6452755017a60) kernel: restore stack size check

**Libraries (5):**

- [aa6de29c](https://github.com/zephyrproject-rtos/zephyr/commit/aa6de29c4b00f5ad8e165f0b9dab8b3e16007cd3) lib: user mode compatible mempools
- [f603e603](https://github.com/zephyrproject-rtos/zephyr/commit/f603e603bbe60e78f070292b93d56fd98f6f9ab6) lib: posix: Move posix layer from 'kernel' to 'lib'
- [4226c6d8](https://github.com/zephyrproject-rtos/zephyr/commit/4226c6d8b2c765848661bdb228befbcde4b1a215) lib: posix: Fix mutex locking in pthread_cancel
- [fe46c75d](https://github.com/zephyrproject-rtos/zephyr/commit/fe46c75d259f95b11f917e71906dd47aa5d74f8e) lib: posix: Fix integer overflow in timer_gettime
- [193f4feb](https://github.com/zephyrproject-rtos/zephyr/commit/193f4feb841c48b1b2e436d341c66ff79d4bf684) lib: Red/Black balanced tree data structure

**Miscellaneous (3):**

- [5f67a611](https://github.com/zephyrproject-rtos/zephyr/commit/5f67a6119dfb1a83c039df81cb4884a3fd18c1dc) include: improve compatibility with C++ apps.
- [7383814d](https://github.com/zephyrproject-rtos/zephyr/commit/7383814d8bec56964bcf9f4171ab20b8ea16c681) cpp: mark __dso_handle as weak.
- [2ef57f0a](https://github.com/zephyrproject-rtos/zephyr/commit/2ef57f0a1b2f4c82e4bb0d84f704ab02aa235b4c) lib/rbtree: Add a rb_contains() predicate

**Networking (18):**

- [de13e979](https://github.com/zephyrproject-rtos/zephyr/commit/de13e979fc9efc7e6b6d1a1540ea93259a8b6146) net: if: vlan: Add virtual lan support
- [487e8104](https://github.com/zephyrproject-rtos/zephyr/commit/487e8104ba85c534b6dcb1454b16a3752f172cb8) net: shell: Add VLAN support
- [6643bb08](https://github.com/zephyrproject-rtos/zephyr/commit/6643bb0898b6ee969337bf9decdb09b0b356ee29) net: l2: ethernet: Add priority to sent ethernet VLAN header
- [ad5bbefd](https://github.com/zephyrproject-rtos/zephyr/commit/ad5bbefda32e74e97690b4d9e1177685eb34538e) net: Add function to convert VLAN priority to packet priority
- [687c3339](https://github.com/zephyrproject-rtos/zephyr/commit/687c3339b7e3176d556aa19ab0cd0a976ab003a6) net: if: Use DEVICE_NAME_GET() instead of fixed string
- [b70b4bca](https://github.com/zephyrproject-rtos/zephyr/commit/b70b4bcad64c79a62ec3953a9a0d67be22ad8652) net: shell: Add network interface up/down command
- [ffd0a1f5](https://github.com/zephyrproject-rtos/zephyr/commit/ffd0a1f5d0beac61c84596f6537484ab9621a655) net: core: Check interface when receiving a packet
- [444dfa74](https://github.com/zephyrproject-rtos/zephyr/commit/444dfa742f59860e6a8122a6196669ed623eb660) net: l2: Remove l2_data section start and end pointers
- [e56a9f0e](https://github.com/zephyrproject-rtos/zephyr/commit/e56a9f0ec44ff91c4798a4babb3d7d2acd506791) net: ethernet: Return correct non VLAN interface
- [85d65b20](https://github.com/zephyrproject-rtos/zephyr/commit/85d65b20c9c5ba2e5ab2d6360e5d87a49590cd71) net: stats: Fix the net_mgmt statistics collection
- [1443ff0f](https://github.com/zephyrproject-rtos/zephyr/commit/1443ff0f5e0c5ac48419fa0d9c24fb7241a53cfc) net: stats: Make statistics collection per network interface
- [e996b37c](https://github.com/zephyrproject-rtos/zephyr/commit/e996b37c0a8b9d0bf87b49c63ed354c4da9bd243) net/ethernet: Add capabilities exposed by device drivers
- [e9d77b60](https://github.com/zephyrproject-rtos/zephyr/commit/e9d77b60de0344c39369ab00c6285c62f60e3203) net/ethernet: No need to expose vlan_setup if vlan is not enabled
- [4bf1a9bd](https://github.com/zephyrproject-rtos/zephyr/commit/4bf1a9bd60b74035133f4f2f1d65b2776724d400) net/ethernet: All types are prefixed with ethernet_
- [af0c5869](https://github.com/zephyrproject-rtos/zephyr/commit/af0c5869883c33971cf2b33de11d9a06fba46d88) net/ethernet: Moving ethernet code to dedicated directory
- [f3d80126](https://github.com/zephyrproject-rtos/zephyr/commit/f3d8012655fa215fc75771a39fd355351a67558c) net/ethernet: Add function driver API to change some hw configuration
- [8d558fb5](https://github.com/zephyrproject-rtos/zephyr/commit/8d558fb5eae4c2c138dce5b52828b2442261502a) net/ethernet: Add a management interface
- [757c5d18](https://github.com/zephyrproject-rtos/zephyr/commit/757c5d18571753212d1515cc8ee298059db27a23) net/ethernet: Fix uninitialized attributes in ethernet mgmt parameters

**Samples (10):**

- [308f4df9](https://github.com/zephyrproject-rtos/zephyr/commit/308f4df91d0c813acf028f592e02b43b1694152c) samples/drivers: Switch Fujistu FRAM sample to new SPI API
- [e7de85b5](https://github.com/zephyrproject-rtos/zephyr/commit/e7de85b5343f2ed118a5c4a043ab7bbae9eec608) samples/bluetooth: Move hci_spi to new SPI API
- [a0df4f66](https://github.com/zephyrproject-rtos/zephyr/commit/a0df4f66984b3cc52c07da52e74fdadf7c79b728) samples: net: Fix sanitycheck for sam_e70_xplained board
- [5fbd4807](https://github.com/zephyrproject-rtos/zephyr/commit/5fbd48077b272d246011de5c51d059c08e375699) samples: net: vlan: Simple app for setting virtual lan settings
- [81d211f3](https://github.com/zephyrproject-rtos/zephyr/commit/81d211f3c8301e94603a9c1cf06384651dc7e47b) samples: hci_uart: Add references to sections
- [bd583ed9](https://github.com/zephyrproject-rtos/zephyr/commit/bd583ed92da724fe74ed6b5db87e0cc53f250df5) samples: mgmt: Expand smp_svr sample documentation
- [7c5c222c](https://github.com/zephyrproject-rtos/zephyr/commit/7c5c222ca0fbcc1a2e5de042ab082ccdf5ab9106) samples: net: Add test cases for USB EEM
- [156091fb](https://github.com/zephyrproject-rtos/zephyr/commit/156091fba66ac46a4d6e35b30792302cad0156b3) samples: sample.yaml cleanup
- [65600d47](https://github.com/zephyrproject-rtos/zephyr/commit/65600d4723baed909ff7a424613d87945240a482) samples: power_mgr: add harnesss configuration
- [15ccd9cc](https://github.com/zephyrproject-rtos/zephyr/commit/15ccd9cc0d0ea048ca1ffb460a572758fe60bf3f) sample: net: stats: Example how to use net_mgmt for statistics

**Scripts (6):**

- [46a172ae](https://github.com/zephyrproject-rtos/zephyr/commit/46a172ae3c1e8605b9e9d74f7f8ded2541d27cf2) kconfiglib: Update to 2259d353426f1
- [db28a5d8](https://github.com/zephyrproject-rtos/zephyr/commit/db28a5d8b70eb7d274d7c200e4b1455c3fac98c3) kconfiglib: Update to 981d24aff7654
- [8fc44f29](https://github.com/zephyrproject-rtos/zephyr/commit/8fc44f298877f98ce24c0276f3305cfcb6d6ab77) kconfiglib: Update to e8408a06c68d8
- [e32ed180](https://github.com/zephyrproject-rtos/zephyr/commit/e32ed180762adfe9d5cea3613f6064a36c6f8802) jlink: fix flashing behavior on Windows
- [ba2ce2e9](https://github.com/zephyrproject-rtos/zephyr/commit/ba2ce2e9f0dcccef8b14c0aea2bf5e483ee07f82) script/extract_dts_includes: factorize call to upper()
- [074c90c5](https://github.com/zephyrproject-rtos/zephyr/commit/074c90c5c467eae95b3021b99268134231bb8f09) scripts: dts_extract_include: generate aliases defs

**Testing (44):**

- [a5efadf2](https://github.com/zephyrproject-rtos/zephyr/commit/a5efadf219ed6ba3ece7d2f8ca4c8731eee94fff) tests/drivers: Removing old SPI test
- [b4247fde](https://github.com/zephyrproject-rtos/zephyr/commit/b4247fde4d555c3b5a5ac15390b99ec88f2f3dc3) tests/spi: Remove excluded boards
- [9116cc7a](https://github.com/zephyrproject-rtos/zephyr/commit/9116cc7aee11747037fac2ce20fc1c6909da6e59) tests: spi_loopback: Add frdm_k64f configuration
- [18d354c4](https://github.com/zephyrproject-rtos/zephyr/commit/18d354c491be8e01530d5434155877b5259aee8e) tests: spi_loopback: Add configurations for a few nRF5 boards
- [92be4112](https://github.com/zephyrproject-rtos/zephyr/commit/92be41126db9e789467581258400eeaa6a91abb9) tests: drivers: build_all: add TEMP_NRF5 to sensor test
- [d155e886](https://github.com/zephyrproject-rtos/zephyr/commit/d155e88624e8c8ef0ede9f185f94c129f00c6a4c) tests: stack_random: Add Ztest support
- [fab8c278](https://github.com/zephyrproject-rtos/zephyr/commit/fab8c27880d60261cbd544411131a72d10cd2a0e) tests: lifo: Add lifo test with scenario
- [14e356c7](https://github.com/zephyrproject-rtos/zephyr/commit/14e356c79a558f4b33352fb0122ca8ee58e330a3) tests: net: vlan: Add VLAN tests
- [e3076a47](https://github.com/zephyrproject-rtos/zephyr/commit/e3076a47177a458b0684845fd82c79d1de05ee8b) tests: add tag for memory pool tests
- [46931c9a](https://github.com/zephyrproject-rtos/zephyr/commit/46931c9a4467e68402d1c5147c5772e22f7c6bc5) tests: posix: Resolve header file dependencies
- [9e4bbcc9](https://github.com/zephyrproject-rtos/zephyr/commit/9e4bbcc937aa60687505fa332ef5e0ca3e316ddd) tests: kernel: add Cortex-M33/M7 in list of MCUs
- [316ffff6](https://github.com/zephyrproject-rtos/zephyr/commit/316ffff6f22d69871d1f888eecbfb3b790bc507f) tests: kernel: fix irq_vector_table test for nRF52X platforms
- [4fc2ccbd](https://github.com/zephyrproject-rtos/zephyr/commit/4fc2ccbdabf6182cf93dd89d3f4e162bd93afaaa) test: mbox_usage: add legacy test case for mailbox
- [bdda3695](https://github.com/zephyrproject-rtos/zephyr/commit/bdda3695803bcbb61b5947805d5151bdb4299d35) tests: net: vlan: Fix VLAN disable test
- [f8502690](https://github.com/zephyrproject-rtos/zephyr/commit/f8502690e1f404b195a57e4a04559220a7ee1dce) tests: context: rename main test
- [88c16923](https://github.com/zephyrproject-rtos/zephyr/commit/88c16923e766d449a0c1dce5e211fc2ac1c36355) tests: context: use ztest macros
- [86bb19ac](https://github.com/zephyrproject-rtos/zephyr/commit/86bb19ac7db9acac32e2927eabb751d4f99ee751) tests: mutex: rename main test function
- [5d569eac](https://github.com/zephyrproject-rtos/zephyr/commit/5d569eac7f4ca730bace61e7d76d243175e7ce3f) tests: rename test -> main.c
- [e73a95bd](https://github.com/zephyrproject-rtos/zephyr/commit/e73a95bd640faae758279457546cdecdaa790a36) tests: kernel: use a consistent test suite name
- [5c72f40c](https://github.com/zephyrproject-rtos/zephyr/commit/5c72f40c1d252b0debd74a3a9f4e67c5190d06ed) tests: tags should not be required
- [f3e8cb7e](https://github.com/zephyrproject-rtos/zephyr/commit/f3e8cb7e61a7a60b617f8774682cc1a85bd906a9) tests: add missing harness support
- [016b21a4](https://github.com/zephyrproject-rtos/zephyr/commit/016b21a46366a2e314d1e21fecfe35a331735bcd) tests: mbedtls_sslclient: fix filtering and default conf
- [1934d3bd](https://github.com/zephyrproject-rtos/zephyr/commit/1934d3bd5a104c40cf1dc31ac2d2e522479666b4) tests: enhance test filtering for net tests
- [4f4f135b](https://github.com/zephyrproject-rtos/zephyr/commit/4f4f135b9e85bab37f07e56150c119b72ee37076) tests: mqtt: fix dependencies
- [fca15b49](https://github.com/zephyrproject-rtos/zephyr/commit/fca15b49de6c66b857a94a1f42ac02d8318ee462) tests: xip: cleanup test
- [390a2c4c](https://github.com/zephyrproject-rtos/zephyr/commit/390a2c4c4e694a182d795166716dea60c4677c6c) tests: classify tests
- [8e8d6de6](https://github.com/zephyrproject-rtos/zephyr/commit/8e8d6de6f790877a911cd41a6b6198713d16af11) tests: posix: fix tags and sections
- [49bb8313](https://github.com/zephyrproject-rtos/zephyr/commit/49bb83138c10349f07762f2d5e9423deada123b1) tests: classify periphera tests
- [9e9784fc](https://github.com/zephyrproject-rtos/zephyr/commit/9e9784fc1deb50637166acdc1560003bfc51f66e) qemu_xtensa: ignore net and bluetooth tests
- [848c1054](https://github.com/zephyrproject-rtos/zephyr/commit/848c105485c324e6330976ecce6d1fb3c9db21e7) tests: classify net tests and cleanup
- [5c89a4ce](https://github.com/zephyrproject-rtos/zephyr/commit/5c89a4ce2fa2706589f31c103d56f38e7a79b5fa) tests: ipv6: cleanup tests
- [3e086c68](https://github.com/zephyrproject-rtos/zephyr/commit/3e086c687d8f136a5de28a53fadfaca81645c635) tests: base64: do not exclude newlib
- [31e201b5](https://github.com/zephyrproject-rtos/zephyr/commit/31e201b5dc53bde6cdd7c277f641abac0b21ae6f) tests: net: context: simplify filtering
- [d7e7b08c](https://github.com/zephyrproject-rtos/zephyr/commit/d7e7b08cdc766763d54a0723f70586454e969d17) tests: cleanup meta-data of various tests
- [55ce5510](https://github.com/zephyrproject-rtos/zephyr/commit/55ce5510f5fca2cd7cb166ecbc065615d6b4424f) tests: cleanup subsystem tests meta-data
- [835ee3ff](https://github.com/zephyrproject-rtos/zephyr/commit/835ee3fff04b7c1bdff65fb661a5d4d521e6e64c) tests: net: checksum_offload: exclude native [REVERTME]
- [d2807576](https://github.com/zephyrproject-rtos/zephyr/commit/d2807576ec1f17b4a003abdf76a28ccb2cc7493d) ztest: define test_main in the header file.
- [fe067eb3](https://github.com/zephyrproject-rtos/zephyr/commit/fe067eb37076376d3d0ff5912753527349466442) tests: add a C++ compile test.
- [b71d6bab](https://github.com/zephyrproject-rtos/zephyr/commit/b71d6babfbfca875187be6fddc7f14e44f82c672) tests/net: Add a test for Ethernet net mgmt interface
- [3c856028](https://github.com/zephyrproject-rtos/zephyr/commit/3c8560289cd993ba13b22d5c387d54fe82a20b81) tests: net: checksum_offload: Adjust number of interfaces
- [e2924ab4](https://github.com/zephyrproject-rtos/zephyr/commit/e2924ab42b1dd7815cd27719eed8b5f19016bdfb) tests: add min_flash option for some tests
- [c625ab85](https://github.com/zephyrproject-rtos/zephyr/commit/c625ab85d41c1464615d72a50b10b1ec07829cb3) tests: rbtree test
- [d7b7f511](https://github.com/zephyrproject-rtos/zephyr/commit/d7b7f5115714928c2b1d94eb19f3ae28469083ff) tests: rbtree: Fix test so its actually runs
- [9bde3c06](https://github.com/zephyrproject-rtos/zephyr/commit/9bde3c06e1a679985ab8779248ce76c445531426) tests: build_all: Add LPS22HB and LSM6DSL sensors build test
