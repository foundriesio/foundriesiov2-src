+++
title = "Zephyr News, 14 May 2018"
date = "2018-05-14"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 14 May 2018 newsletter tracking the latest
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

- [c5615aad](https://github.com/zephyrproject-rtos/zephyr/commit/c5615aada4b902bec5e1ca65df2ee742d4dcfc17) ("doc: change https://zephyrproject.org/doc refs"), merged 2 May 2018
- [1b038f29](https://github.com/zephyrproject-rtos/zephyr/commit/1b038f294114797a2aecdfdae76198520efbb7f6) ("Bluetooth: GATT: Make BT_GATT_CHARACTERISTIC declare its value"), merged 14 May 2018

Important Changes
-----------------

**New Watchdog API:**

Continuing the Zephyr Long Term Support (LTS) goal of having stable driver
APIs, the watchdog.h interface was overhauled and re-worked. The
`wdt_enable()`, `wdt_get_config()`, `wdt_set_config()` and
`wdt_api_reload()` routines are still around for now, but have been
deprecated. Users of the watchdog API will want to switch to the new
routines documented in include/watchdog.h instead.

A driver using the new API was merged for the nRF SoC family's watchdog
peripheral. This driver uses device tree.

**Menuconfig is now in Python:**

The previously experimental Python menuconfig implementation has replaced
the C tools, following the addition of symbol search and jump-to-definition
features.

Users who were building the C tools in order to run `menuconfig` must use
the new Python tools instead. Windows users need to install a new
dependency via pip (by re-running `pip3 install -r
scripts/requirements.txt`) before using this program. Mac and Linux users
do not require any additional dependencies.

Zephyr's use of Kconfig includes additional features not present in the
language implemented by the C tools. Somewhat confusingly, documentation
for these features was added to the [board porting
guide](http://docs.zephyrproject.org/porting/board_porting.html#kconfig-extensions).

This is a significant change, in that it now makes Zephyr development
possible on Windows in the native cmd.exe or Powershell shells, without any
additional Unix-specific toolchains or environments.

**Storage API changes:**

A variety of storage-related API changes were merged. These mostly are used
to enable new features.

The Kconfig knob which enables the [storage_partition flash
partition](http://docs.zephyrproject.org/devices/dts/flash_partitions.html)
was renamed from CONFIG_FS_FLASH_MAP_STORAGE to
CONFIG_FS_FLASH_STORAGE_PARTITION. This rename was done because use of the
storage partition does not require the flash_map module.

The filesystem API's `struct fs_mount_t` can now store references to
storage devices of arbitrary type in its `storage_dev` field; it was
previously restricted to a `struct device*`, but is now a `void *`. This
change was made to enable additional layers of indirection between this
field and the backing device.

The disk_access.h API was modified to support simultaneous use of multiple
disk interfaces. The old disk_access_ram.c and disk_access_flash.c have
seen a corresponding refactor; their globally available functions are now
hidden behind instances of the new `struct disk_info` and `struct
disk_operations` structures introduced in this change. The external FAT
file system library now supports multiple volumes.

The filesystem subsystem now supports multiple mounted instances of a
filesystem. As a result of these changes, the fs/fs_interface.h API no
longer assumes that either FAT or NFFS file systems are being used.

**Bluetooth bt_storage removed in favor of settings API:**

The bt_storage API was removed, as it provided features now enabled by the
settings subsystem using `CONFIG_BT_SETTINGS`. Users of this API will need
updates.

The Bluetooth shell and mesh and mesh_demo samples now have settings
support, as demonstrations of using the API.

Bluetooth Mesh support for the settings API required some refactoring to
expose previously hidden symbols to the storage API. There are some
tradeoffs, particularly related to managing flash wear when storing the
local sequence number and replay protection list; refer to the help for the
new `CONFIG_BT_MESH_SEQ_STORE_RATE` and `BT_MESH_RPL_STORE_TIMEOUT` options
for details.

Using this API requires a larger system workqueue stack size; the present
recommended size when using this API is now 2 KB, double its default value.

One additional alternative to using the settings API is the new
`bt_set_id_addr()` routine, which allows applications to set their identity
addresses in a manner similar to the bt_settings API.

Features
--------

**Arches:**

ARMv8-M MCUs with the Main Extension now have support for hardware-based
main stack overflow protection. The relevant Kconfig option to enable the
feature is `CONFIG_BUILTIN_STACK_GUARD`.

x86 CPUs can now grant user space access to the heap when using the newlib
C library.

**Documentation:**

In something of a "meta" development, documentation was added for [how to
write Zephyr
documentation](http://docs.zephyrproject.org/contribute/doc-guidelines.html).

**Drivers and Device Tree:**

The YAML device tree bindings for SPI now include an optional `cs-gpios`
property, which can be used to generate GPIO chip select definitions.

The bindings for ST's SPI-based BTLE nodes now require `irq-gpios` and
`reset-gpios` properties. The names of such devices are now only present in
Kconfig if a new `CONFIG_HAS_DTS_SPI_PINS` selector is unset.

There are two new Kconfig symbols, `CONFIG_HAS_DTS_GPIO` and
`CONFIG_HAS_DTS_GPIO_DEVICE`, which respectively allow declaring that the
GPIO driver supports device tree, and that drivers which need GPIOs do as
well. Currently, only the STM32 and MCUX GPIO drivers select
`CONFIG_HAS_DTS_GPIO`.

DT-based GPIO support for the NXP i.MX7 M4 SoC was added.

The mcux DSPI driver now uses device tree; SPI bindings were added to the
SoC files appropriately to enable this change. This driver also now
supports KW40/41Z SoCs.

The LED driver subsystem now has system call handlers for user mode
configurations.

The USB device controller driver for STM32 devices now supports all STM32
families, among a variety of other improvements to enable USB support on
STM32 MCUs in a variety of families. Board support was also added for
olimexino_stm32 and stm32f3_disco.

The pinmux subsystem no longer supports user mode access. This subsystem's
drivers lack sufficient input validation to prevent a malicious userspace
from accessing unauthorized memory through API calls. A proper fix will
require developing a specification for the subsystem, and updating existing
drivers to do appropriate input validation.

Altera HAL drivers can now be run on Zephyr. Such a driver for the Nios-II
modular scatter-gather DMA (mSGDMA) peripheral was merged, from the Altera
SDK v17. This was used to add a shim driver using Zephyr's dma.h API.

**Networking:**

The LWM2M implementation was significantly refactored and cleaned up.  Once
nice benefit of this work is a 3KB RAM savings when running an LWM2M
client.

The network interface core now supports `net_if_ipv4_select_src_addr()` and
`net_if_ipv4_get_ll()` routines for accessing IPv4 source addresses.

Each `struct net_pkt` now uses one less byte of space, thanks to an
optimization in the size of its `_unused` field.

**Testing:**

The test case documentation now describes best practices for developing a
test suite, and how to list and skip test cases; see
http://docs.zephyrproject.org/subsystems/test/ztest.html for details.

Various tests were converted to use the ztest API, along with other
cleanups, renames, and Doxygen fixups added to the test suite.

Bug Fixes
---------

A build issue on sam_e70 was fixed.

An off-by-one error in the ARM MPU buffer validation routine was fixed.

A dedicated routine for incrementing the sequence number in the Bluetooth
Mesh implementation was added; in addition to fixing race conditions, this
is used by Mesh's settings subsystem integration in order to persist
sequence numbers to flash.

A Bluetooth Mesh bug affecting sequence number calculation in the Friend
queue was fixed.

Fixes to the TI ADC108S102 driver; VL53L0X, LSM6DSL, and HTS221 sensor
drivers; and QMSI UART driver were merged.

Fixes for using the FXOS8700, FXAS21002, and MCR20A drivers on NXP SoCs
were merged.

User mode heap access was fixed for applications which use the newlib C
library. User mode applications also no longer allow the stack sentinel
debugging feature to be enabled. This change was made because
CONFIG_USERSPACE implies separate and more robust stack protection
mechanisms.

The networking traffic class map from packet priorities to traffic classes
was fixed to comply with the IEEE 802.1Q specification.

The websocket implementation was refactored to avoid unnecessary tricky
calculations, resolving Coverity warnings.

The http_client sample was fixed in cases when TLS is enabled; previously,
this application overflowed a stack in this use case.

The mcumgr `smp_svr` sample's build was fixed.

The echo_client and echo_server sample applications saw a few fixes;
echo_server works again to test OpenThread on frdm_kw41z, and
echo_client was fixed on cc2520.

Various fixes and refactoring patches were merged to the
extract_dts_includes.py script, which generates code used by Zephyr from
the final device tree produced during an application build.

Individual Changes
==================

Patches by area (232 patches total):

- Arches: 20
- Bluetooth: 38
- Boards: 18
- Build: 5
- Continuous Integration: 8
- Device Tree: 9
- Documentation: 13
- Drivers: 29
- External: 4
- Kernel: 1
- Libraries: 2
- Maintainers: 3
- Miscellaneous: 1
- Networking: 22
- Samples: 5
- Scripts: 13
- Storage: 6
- Testing: 35

Arches (20):

- [4073db79](https://github.com/zephyrproject-rtos/zephyr/commit/4073db79d709585d6ac853a18d276ada5ad2eac7) arch: nios2: Add _nios2_dcache_flush_no_writeback() routine
- [4a41f42e](https://github.com/zephyrproject-rtos/zephyr/commit/4a41f42e73af6811e13cb68909fb5b601f1157d2) arch: arm: set interrupt stack protection with MSPLIM
- [91dc3bd0](https://github.com/zephyrproject-rtos/zephyr/commit/91dc3bd0f9315bae67934247ac8aa28ab4641ab1) arch: arm: ignore stack pointer limit checks during HF and NMI
- [8d1b013f](https://github.com/zephyrproject-rtos/zephyr/commit/8d1b013f3c70e588f5f5793e32ac528e5fd2821c) arch: arm: thread built-in stack guard implementation
- [e8e76ae4](https://github.com/zephyrproject-rtos/zephyr/commit/e8e76ae43329aa775782c0dc25a3da958e5906e4) arch: Add imx7d_m4 gpio definitions
- [3d691988](https://github.com/zephyrproject-rtos/zephyr/commit/3d691988435661608613081860d8528f1479d72c) arm_mpu: fix off-by-one in mpu_buffer_validate
- [7f271b86](https://github.com/zephyrproject-rtos/zephyr/commit/7f271b8689e0319a3310be2154b7935a378fec42) cc3220sf: soc: Update PRCM call to allow use of ROM API
- [55979aa3](https://github.com/zephyrproject-rtos/zephyr/commit/55979aa3a5c6557fa4923294fe775eed4c265efc) arm: Add more flash and ram size options to i.MX RT MPU config
- [dd26f285](https://github.com/zephyrproject-rtos/zephyr/commit/dd26f285e5551efbb3862799422b80d59770d4da) arch: arm: add synchronization point after Stack Pointer switch
- [fc76839b](https://github.com/zephyrproject-rtos/zephyr/commit/fc76839b6b7bb0380ca89b0fbb25bf63a8c62e1b) x86: grant user mode access to newlib heap
- [197e2773](https://github.com/zephyrproject-rtos/zephyr/commit/197e27730091c99b2f61781aa593640f65d43cf5) arch: arm: improve description of ARMV7_M_ARMV8_M_MAINLINE option
- [47564a09](https://github.com/zephyrproject-rtos/zephyr/commit/47564a09714fc5a27dcb390205d89046970621d6) arch: arm: feature consistency checks for Cortex M regs
- [816e3d87](https://github.com/zephyrproject-rtos/zephyr/commit/816e3d876755f027f016042fd9e7c7461b92ad89) arch: stm32l4: add HAL_Delay for hal library hooks
- [e81d9b98](https://github.com/zephyrproject-rtos/zephyr/commit/e81d9b98fed139eccbf01099d5c67d93ef76fe7e) arch: nxp dts bindings: Set IP clock name to matching clock controller
- [c136a107](https://github.com/zephyrproject-rtos/zephyr/commit/c136a107aa2536cad50bee9753b978eea03ae28a) soc: sam_e70: Mpu regions should include SRAM regions.
- [b493f484](https://github.com/zephyrproject-rtos/zephyr/commit/b493f484df99b689a042537f03688c82fb0f0f0d) arch: arm: soc: Cleanup Kconfig inclusion per SoC
- [071212be](https://github.com/zephyrproject-rtos/zephyr/commit/071212bec911e88fbe9c48d8f322be24825e6d4c) arch: arm: atmel_sam: Fixup build issue on sam_e70
- [c7dd4f55](https://github.com/zephyrproject-rtos/zephyr/commit/c7dd4f55f036bfaf89bc5681dd766bdda0a60dd2) nxp_kinetis: Enable mcux dspi driver on kw40/41z socs
- [a88e31d2](https://github.com/zephyrproject-rtos/zephyr/commit/a88e31d2ca7255d061e4f2cf4fb1b3f968efb8cd) nxp_kinetis: Remove unused dspi irq defines from soc.h
- [329c00dc](https://github.com/zephyrproject-rtos/zephyr/commit/329c00dc6b19bb8388688fe0ccc4c06ecc94815b) arch/soc/st_stm32: Move STM32Cube HAL core funtions

Bluetooth (38):

- [6a71a69f](https://github.com/zephyrproject-rtos/zephyr/commit/6a71a69f8d4990cefdd6fd8679ba139972a1a96a) Bluetooth: GATT: Fix CCC handling
- [8dd37fa7](https://github.com/zephyrproject-rtos/zephyr/commit/8dd37fa79ac6c5b391f453e20856291c4df3d75d) Bluetooth: Mesh: Fix sequence number in Friend queue
- [b997a283](https://github.com/zephyrproject-rtos/zephyr/commit/b997a283f7ec3d13728b7ca9c92258cd3bcac3e0) Bluetooth: Introduce skeleton for settings-based storage
- [d22b7c9f](https://github.com/zephyrproject-rtos/zephyr/commit/d22b7c9f2d771bf9a2a1b8e0378795d4c507f558) Bluetooth: Remove bt_storage API
- [470349c2](https://github.com/zephyrproject-rtos/zephyr/commit/470349c25a7c0604de02cf0585bb3d8cc5b6463f) Bluetooth: settings: Add support for per-submodule handlers
- [f36ea836](https://github.com/zephyrproject-rtos/zephyr/commit/f36ea83628086a649d49f83d0b4e131941c7045b) Bluetooth: Add support for persistent pairing keys storage
- [6af5d1cd](https://github.com/zephyrproject-rtos/zephyr/commit/6af5d1cd1f81e4e195a94dbc6f2ab513bb5400fc) Bluetooth: Compress bt_keys struct
- [a2955436](https://github.com/zephyrproject-rtos/zephyr/commit/a29554360a5331702c4cc3fd3f5cfe480b65e1d5) Bluetooth: shell: Add settings support
- [10fabcd0](https://github.com/zephyrproject-rtos/zephyr/commit/10fabcd04f45fd0a0e857cd4bbbac033d718cd6d) Bluetooth: Mesh: Move IV Update defines to net.h
- [f7e780a7](https://github.com/zephyrproject-rtos/zephyr/commit/f7e780a71943c60eb07e5c8d01e75bbd649fceac) Bluetooth: Mesh: Increase visibility of net & app key helpers
- [ca10b6bc](https://github.com/zephyrproject-rtos/zephyr/commit/ca10b6bc94253c921da1d1c0a3dff8c82608beb3) Bluetooth: Mesh: Remove redundant initialization
- [2be496a0](https://github.com/zephyrproject-rtos/zephyr/commit/2be496a03bd0f26e588b3d8cdac22d7bfeaa87fb) Bluetooth: Mesh: Create dedicated helper for incrementing seq
- [9540f7d5](https://github.com/zephyrproject-rtos/zephyr/commit/9540f7d52d24d7ae796b6c1902906cc82aaa4753) Bluetooth: Mesh: Add skeleton for persistent storage
- [1c846651](https://github.com/zephyrproject-rtos/zephyr/commit/1c846651dbecdd205b926ab7c578c9ca59f24808) Bluetooth: Mesh: Add storage APIs for core network values
- [3f30d12c](https://github.com/zephyrproject-rtos/zephyr/commit/3f30d12ce5428cb0a384ea49d50296aece5ac08d) Bluetooth: Mesh: Remove redundant 'provisioned' variable
- [43c7ef39](https://github.com/zephyrproject-rtos/zephyr/commit/43c7ef39596993a5aa3a46807aa95f98be480108) Bluetooth: Mesh: Move network startup operations to common function
- [be7fe55b](https://github.com/zephyrproject-rtos/zephyr/commit/be7fe55b82a92ed5c4375063430e8fb42046696a) Bluetooth: Mesh: Introduce measures to avoid too frequent flash writes
- [cc3830f8](https://github.com/zephyrproject-rtos/zephyr/commit/cc3830f8ed857bce1ab07abeb3dd2ea1151d0878) Bluetooth: Mesh: Fix resetting configuration model state
- [31afd189](https://github.com/zephyrproject-rtos/zephyr/commit/31afd189779b66c4880bc41b59a3f2eeb5446b98) Bluetooth: Mesh: Add support for clearing persistent network storage
- [5b01cb1a](https://github.com/zephyrproject-rtos/zephyr/commit/5b01cb1a460775e4532834f33a36eaef376813fd) Bluetooth: Introduce new bt_set_id_addr() API
- [c1c5f3d9](https://github.com/zephyrproject-rtos/zephyr/commit/c1c5f3d9a3eec02cd8494af11ab22de45c351c88) Bluetooth: Mesh: Expose destination address in bt_mesh_msg_ctx
- [f6a687c0](https://github.com/zephyrproject-rtos/zephyr/commit/f6a687c0ce9faaf2e12c68699e7cf45d1d89d15a) Bluetooth: GATT: Add support to persistent CCC config
- [ace19814](https://github.com/zephyrproject-rtos/zephyr/commit/ace198142e5bec3ebca9093a25723ca42819f588) Bluetooth: Mesh: Convert RPL storage timer into a generic one
- [9e2189c4](https://github.com/zephyrproject-rtos/zephyr/commit/9e2189c4c1096c0dd88dc40f3eba5907a54ba986) Bluetooth: Mesh: Introduce generic storage timer
- [b7078e14](https://github.com/zephyrproject-rtos/zephyr/commit/b7078e14872cfb42715c9b5278d98ad4ce529309) Bluetooth: Mesh: Perform storage clearing also through delayed work
- [8703ffad](https://github.com/zephyrproject-rtos/zephyr/commit/8703ffad23b12b2b84d6081c0e8229ebe5927781) Bluetooth: Mesh: Redesign element and storage info for models
- [c3d5a0da](https://github.com/zephyrproject-rtos/zephyr/commit/c3d5a0da62201bec26860f701b74ca322e8fd09f) Bluetooth: Mesh: Support for storing model bindings persistently
- [dde2db56](https://github.com/zephyrproject-rtos/zephyr/commit/dde2db562687f7558f72298174dffa659fd53671) Bluetooth: Mesh: Support for storing model subscriptions persistently
- [efb68ca2](https://github.com/zephyrproject-rtos/zephyr/commit/efb68ca2da855edb330384e45f429f00b56a0d70) Bluetooth: Mesh: Support for storing model publication persistently
- [44bd5687](https://github.com/zephyrproject-rtos/zephyr/commit/44bd56877bc817fd07a28c8f18211cda89be3a93) Bluetooth: Mesh: Support for storing heartbeat publication persistently
- [59239032](https://github.com/zephyrproject-rtos/zephyr/commit/59239032f6b78f267291ea8acde5ee96895032d2) Bluetooth: Mesh: Support for storing common configuration states
- [53c85cf8](https://github.com/zephyrproject-rtos/zephyr/commit/53c85cf8bfe55788f20d8e196de592897b9742e0) Bluetooth: Mesh: Fix updating RPL for locally originated messages
- [e2404214](https://github.com/zephyrproject-rtos/zephyr/commit/e24042149659e6bd51b1db3779b77683c4a21dba) Bluetooth: Mesh: Fix sequence number restoring
- [da82976e](https://github.com/zephyrproject-rtos/zephyr/commit/da82976eb641383af60983a841227267eb35684f) Bluetooth: samples/mesh_demo: Add support for settings-based storage
- [88dfd399](https://github.com/zephyrproject-rtos/zephyr/commit/88dfd399f480b1593a8e13f5a68d512921a55502) Bluetooth: Mesh: Remove sequence number from bt_mesh_provision()
- [4f4afce5](https://github.com/zephyrproject-rtos/zephyr/commit/4f4afce5b0df6e94cbd581254b973e11b1017074) Bluetooth: Remove unused rx_prio_queue
- [318a1758](https://github.com/zephyrproject-rtos/zephyr/commit/318a17586792a3d86d9941b3941d61eefb1d613b) Bluetooth: GATT: Introduce BT_GATT_ATTRIBUTE
- [1b038f29](https://github.com/zephyrproject-rtos/zephyr/commit/1b038f294114797a2aecdfdae76198520efbb7f6) Bluetooth: GATT: Make BT_GATT_CHARACTERISTIC declare its value

Boards (18):

- [cdd108f6](https://github.com/zephyrproject-rtos/zephyr/commit/cdd108f66c7d844a85a7b5bf2f2dd1ff417c360e) boards: intel_s1000_crb: Assign Intel VID and PID for S1000 CRB
- [4388f6f3](https://github.com/zephyrproject-rtos/zephyr/commit/4388f6f31440cf755bd80bc8a7f03395fde4ea80) boards/arm/nrf52_blenano2: add storage flash partition
- [31a2ac87](https://github.com/zephyrproject-rtos/zephyr/commit/31a2ac8764b88e7e130b3c2d16556f17056a884a) board: add gpio support for colibri_imx7d_m4 board
- [f64657e8](https://github.com/zephyrproject-rtos/zephyr/commit/f64657e88139969c1fb3ae48ed7c7cabcd56735e) frdm_k64f: Fix pin name typos in the board doc
- [6be824d0](https://github.com/zephyrproject-rtos/zephyr/commit/6be824d036359d287c6795278fc7b09e76b75164) cc3220sf: Fix linker map and dtsi to ensure full 256K SRAM size
- [77e9e27d](https://github.com/zephyrproject-rtos/zephyr/commit/77e9e27d76236bc056fa35465e0c61b55ef842b8) mimxrt1050_evk: Add config to select code linking location
- [65e96eef](https://github.com/zephyrproject-rtos/zephyr/commit/65e96eefea64966237627b5eb3cb1b21eee03024) boards: disco_l475_iot1: enable XSHUT master control
- [38d2567e](https://github.com/zephyrproject-rtos/zephyr/commit/38d2567e088fd49eaf7a1037eeb6df6aaf029000) boards: olimexino_stm32: Add USB support
- [80d69ea4](https://github.com/zephyrproject-rtos/zephyr/commit/80d69ea47f4964d645d260d6bbd76e1824b8c84d) boards: stm32f3_disco: Add USB support
- [2acb1287](https://github.com/zephyrproject-rtos/zephyr/commit/2acb128791027668a69000bccae70f09362d5d98) boards: disco_l475_iot1/dts: add gpios in bt controller node
- [90ac25f7](https://github.com/zephyrproject-rtos/zephyr/commit/90ac25f736c2c4e54306dd96efa962da545f838d) boards: dts: Add fxos8700 interrupt bindings and fix sensor sample
- [9cd36c7b](https://github.com/zephyrproject-rtos/zephyr/commit/9cd36c7bd2402a05482ac7cc67a8abcde1d7a7df) boards: dts: Add fxas21002 interrupt bindings and fix sensor sample
- [87b95184](https://github.com/zephyrproject-rtos/zephyr/commit/87b9518496f736af53ddb25fe39ca003a6bc1b93) hexiwear_k64: Fix whitespace in dts.fixup
- [ed1ab61e](https://github.com/zephyrproject-rtos/zephyr/commit/ed1ab61e18b13b4a7fa824a149b8b69b2d292f76) frdm_kw41z: Configure spi0 pinmuxes and update board doc accordingly
- [ae2a9b0f](https://github.com/zephyrproject-rtos/zephyr/commit/ae2a9b0f3e42622c5a0e6ea92e3973cac03ef482) boards: Select HAS_DTS_SPI_DEVICE on kinetis boards
- [0d1beb2f](https://github.com/zephyrproject-rtos/zephyr/commit/0d1beb2f9e430279d6922bad58fd33904b1f868d) boards: dts: Add mcr20a bindings and fix networking samples
- [4edae077](https://github.com/zephyrproject-rtos/zephyr/commit/4edae077578ee037307c51c07cd0f14fcf88f7e1) boards/arm/olimexino_stm32: Add disconnect gpio in usb node
- [5ce10f1d](https://github.com/zephyrproject-rtos/zephyr/commit/5ce10f1d1cd3bdd9e68307aa3bfb50015b764e76) boards: arm: nrf52_blenano2: Add I2C default config

Build (5):

- [60b01f3f](https://github.com/zephyrproject-rtos/zephyr/commit/60b01f3f5489975098657caa514133c89a472d19) kconfig: Refactor kconfig.py to use __main__ and argparse
- [890a5a5a](https://github.com/zephyrproject-rtos/zephyr/commit/890a5a5aa1f641edc924426f89b195f7de460d0b) kconfig: Remove targets specific to the C implementation
- [11952a60](https://github.com/zephyrproject-rtos/zephyr/commit/11952a60bf2c6b0b1eb68e778665e222ac200f72) kconfig: Remove the C Kconfig implementation
- [ac7f2239](https://github.com/zephyrproject-rtos/zephyr/commit/ac7f2239565aaffee6e1fd359ca5df09d5b8f476) kconfig: Mention that checkconfig.py lacks Kconfiglib 2 support
- [547ed9b5](https://github.com/zephyrproject-rtos/zephyr/commit/547ed9b563729b9622d3641e250cda9f54307437) kconfig: Make 'source' non-globbing and use 'gsource'

Continuous Integration (8):

- [73440ead](https://github.com/zephyrproject-rtos/zephyr/commit/73440ead7de1d7c3caff9b07958adaa98da06413) sanitycheck: device handler, allow running tests on real hw
- [e0a6a0b6](https://github.com/zephyrproject-rtos/zephyr/commit/e0a6a0b692516cc8fb3b62400c9c7bbbd38e8358) sanitycheck: parse test results and create detailed report
- [d3384fb7](https://github.com/zephyrproject-rtos/zephyr/commit/d3384fb71c78add4aa416c62b33c8194a6eb78dc) sanitycheck: cleanup handler class
- [37f9dc5c](https://github.com/zephyrproject-rtos/zephyr/commit/37f9dc5c2d65e814b38c1982ec6b8ca1a322f582) sanitycheck: simplify argument passing and use global options
- [a3abe967](https://github.com/zephyrproject-rtos/zephyr/commit/a3abe967d69a90e112ad5dca0ee932463ac5bbec) sanitycheck: do not count duplicate tests
- [61e2163e](https://github.com/zephyrproject-rtos/zephyr/commit/61e2163ec92e410505279938a2502c1446d9be08) sanitycheck: support skipped tests, enhance device handler
- [10776c44](https://github.com/zephyrproject-rtos/zephyr/commit/10776c446764890d81f194c7db1473fdc633ca0f) ci: remove pyserial install
- [de7fc9de](https://github.com/zephyrproject-rtos/zephyr/commit/de7fc9dec97af9a46b220a8a474313d387d853ca) sanitycheck: we need pyserial for sanitycheck

Device Tree (9):

- [16399a64](https://github.com/zephyrproject-rtos/zephyr/commit/16399a64797c76651d70edbaf54c185e84c022ae) dts: mimxrt1050_evk: Add external memory nodes
- [47fe4ee7](https://github.com/zephyrproject-rtos/zephyr/commit/47fe4ee78b0a0becb4963e773f17070f3cdc1dba) dts/arm/st: Add USB support for stm32f070/72
- [3bbe87e1](https://github.com/zephyrproject-rtos/zephyr/commit/3bbe87e171c8c31eab1084c1c13f806273483369) dts/arm/st: Add usbotg_fs node to stm32l4 DT
- [11a70647](https://github.com/zephyrproject-rtos/zephyr/commit/11a70647cf9b2ffd1558c645d719b309c871ab24) dts: spi: Add optional cs-gpios to the spi bus controller binding
- [00376f08](https://github.com/zephyrproject-rtos/zephyr/commit/00376f08caf70203681b3236e5bce551c88acf4f) dts/bindings: Add reset and irq gpios to "st,spbtle-rf" yaml
- [d2d4cea0](https://github.com/zephyrproject-rtos/zephyr/commit/d2d4cea02d5d63d77041f9cffe62c26cf872f629) dts: nxp_kinetis: Add spi bindings for kinetis dspi and update soc nodes
- [b3107fd1](https://github.com/zephyrproject-rtos/zephyr/commit/b3107fd1209acbd66952bc273ceb47de91194a47) dts/bindings/usb: Add disconnect gpio in st,stm32-usb.yaml
- [c0b47213](https://github.com/zephyrproject-rtos/zephyr/commit/c0b472132c25891d957310faf33bda52f234c255) dts/arm/st: Add USB support for stm32l072/73
- [83e4947c](https://github.com/zephyrproject-rtos/zephyr/commit/83e4947cf14f4d86a5cd16a4d59676f7cc2b0fad) dts: nrf: Expand nRF DTS to support watchdog

Documentation (13):

- [c5615aad](https://github.com/zephyrproject-rtos/zephyr/commit/c5615aada4b902bec5e1ca65df2ee742d4dcfc17) doc: change https://zephyrproject.org/doc refs
- [2c8a3835](https://github.com/zephyrproject-rtos/zephyr/commit/2c8a3835d94ebc93b67cd93e1c86176aaa35778a) doc: DRAFT start for 1.12 release notes
- [7a6f7136](https://github.com/zephyrproject-rtos/zephyr/commit/7a6f7136bb82316bbfcd6d1f3dd40d1cf32fec12) doc: process test documentation
- [418cc0ea](https://github.com/zephyrproject-rtos/zephyr/commit/418cc0eafe63d1253ac64bde7f81fbfd5a2543d5) doc: Update for menuconfig.py
- [5443d065](https://github.com/zephyrproject-rtos/zephyr/commit/5443d065ca092dd5724f88ee71991096186316a6) doc: fix colibri_imx7d_m4 board documentation
- [18859171](https://github.com/zephyrproject-rtos/zephyr/commit/18859171a3c4badf52f65b22e956c338f728114a) doc: flatten doxygen-generated HTML structure
- [850b218e](https://github.com/zephyrproject-rtos/zephyr/commit/850b218e73cc20f585b5584479dc64d5b3c5747e) doc: document best practices for main.c suite declaration
- [3e136b4d](https://github.com/zephyrproject-rtos/zephyr/commit/3e136b4d23085ba16bbc81b9032ffcb4eabe8c7a) doc: fix misspellings in doc and Kconfig files
- [0d12b74a](https://github.com/zephyrproject-rtos/zephyr/commit/0d12b74a29a41f351fc1aeff00150fc4e4b44d2e) doc: fix references to mailing lists
- [930dbd5d](https://github.com/zephyrproject-rtos/zephyr/commit/930dbd5d80c8243551e0f87f900a25391f5a2b7c) doc: Document Kconfig extensions and Zephyr-specific behavior
- [486c5a54](https://github.com/zephyrproject-rtos/zephyr/commit/486c5a54e50a545309d5ff16009437328dc43fa1) doc: add doc writing guides w/common usages
- [7ac624e7](https://github.com/zephyrproject-rtos/zephyr/commit/7ac624e7741774cac69a05ff9fddd9974b026dfb) doc/subsystem/settings: fix wrong settings_handler field names
- [a869f875](https://github.com/zephyrproject-rtos/zephyr/commit/a869f875ec9ccdba6e6b9a951b885d9bb1c7b7c0) doc: Mention that dependencies can be checked in menuconfig

Drivers (29):

- [15447fa1](https://github.com/zephyrproject-rtos/zephyr/commit/15447fa1d86487f3164cc89447d2cde1fce3d3c0) drivers: dma: Add dma driver for Nios-II MSGDMA core
- [26babfc6](https://github.com/zephyrproject-rtos/zephyr/commit/26babfc622e6044e03ca82f2b398356b94166ff0) drivers: led: Add system call handler support
- [d1bd3a6f](https://github.com/zephyrproject-rtos/zephyr/commit/d1bd3a6fe72d66112d95890d8f0963267b242ddd) dma: define and document the source and dest adjust enum.
- [a4208365](https://github.com/zephyrproject-rtos/zephyr/commit/a4208365f200390a521a696fcd6aa18445d40c6e) pinmux: remove user mode access
- [a0c3aadd](https://github.com/zephyrproject-rtos/zephyr/commit/a0c3aadde49c6491135e297092c6d7aeb29a9fdd) uart_qmsi: fix possible divide-by-zero
- [97ccf99b](https://github.com/zephyrproject-rtos/zephyr/commit/97ccf99b9b21e92fe59b1af1b25e4cbebbf7df5e) ti_adc108s102: fix verification off-by-one
- [5dc2ab4f](https://github.com/zephyrproject-rtos/zephyr/commit/5dc2ab4f47c4ca536c36f9974ed6f90d30ba4306) ti_adc108s102: validate num_entries
- [b83d0782](https://github.com/zephyrproject-rtos/zephyr/commit/b83d0782c98c90f608abc301eccb6623a6aa44b0) sensor: vl53l0x: make xshut pin control optional
- [77c0456d](https://github.com/zephyrproject-rtos/zephyr/commit/77c0456d002e7e06eab32838d4f7ec574681527c) sensors: hts221: Fix a crash due to bad device init
- [921bfeb0](https://github.com/zephyrproject-rtos/zephyr/commit/921bfeb05a1729b600403bd4c928afc6eaf7fdac) drivers: usb_dc_stm32: Add support for all STM32 families
- [55dada25](https://github.com/zephyrproject-rtos/zephyr/commit/55dada259271947d9902c80d35d3043d9304c535) drivers: usb_dc_stm32: Add usb disconnect pin support
- [ad530033](https://github.com/zephyrproject-rtos/zephyr/commit/ad530033c1dc710c94374a0cabbcede8c70e9e08) drivers: pinmux_stm32l4x: add usb otg pinmux
- [b1478518](https://github.com/zephyrproject-rtos/zephyr/commit/b1478518c08418e2e01c62ac0ad30c8782e55b18) drivers: usb_dc_stm32: use HSI48 if available
- [e2b27d82](https://github.com/zephyrproject-rtos/zephyr/commit/e2b27d820db130c2d19c9756e01839db2a451cf1) drivers: usb_dc_stm32: enable VDDUSB if needed
- [57904102](https://github.com/zephyrproject-rtos/zephyr/commit/57904102fdb0932f54c0403c4a013e794304bab5) gpio: dts: Introduce Kconfig symbols to convey GPIO dts support
- [3fbc7c58](https://github.com/zephyrproject-rtos/zephyr/commit/3fbc7c5853d7a576d4aac38d839e4f451df81b8a) spi: Wrap instance configs consistently with ifdefs
- [d749feb6](https://github.com/zephyrproject-rtos/zephyr/commit/d749feb698d65387ed38d34c80ec50476e8d666f) spi: Fix missing "depends on !HAS_DTS_SPI"
- [cae90744](https://github.com/zephyrproject-rtos/zephyr/commit/cae9074492ce3749f192c904e54a8d5e84ee0f90) spi: Refactor mcux dspi driver to use dts
- [2fbb4d35](https://github.com/zephyrproject-rtos/zephyr/commit/2fbb4d35d2d19198bb8df28e9726faf7a79766ff) spi: Refactor mcux dspi shim driver to use clock control interface
- [4e324e21](https://github.com/zephyrproject-rtos/zephyr/commit/4e324e21711153ffff9681e45b8fa238ebb3e39b) usb: dfu: fix 'this area can not be overwritten'
- [f47b9c2f](https://github.com/zephyrproject-rtos/zephyr/commit/f47b9c2fca00801ce8cb55b20937fca5d5c29c2a) drivers/usb/device: Remove USB DISCONNECT gpio options
- [3ff4065c](https://github.com/zephyrproject-rtos/zephyr/commit/3ff4065cb3ad2490183bc0d60cb985c7e4c3b9e0) drivers: sensors: lsm6dsl: Fix array overrun
- [2a55fcf6](https://github.com/zephyrproject-rtos/zephyr/commit/2a55fcf607508b1cd46a2b789a2fda15569791e5) drivers/usb/usb_dc_stm32: Provide EP_TYPE_* defines for L0
- [c9d5b561](https://github.com/zephyrproject-rtos/zephyr/commit/c9d5b56140684b5b9b142bdc6485b7d75e1bdce2) drivers/usb_dc_stm32: HSI48 requires VREFINT in L0
- [f6a96979](https://github.com/zephyrproject-rtos/zephyr/commit/f6a9697923ee4a06771309d631a441e45b2f6b3f) drivers/stm32l0x_ll_clock: Enable SYSCFG in clock_control
- [87d62441](https://github.com/zephyrproject-rtos/zephyr/commit/87d624419dda940173b95ded45c23b591302a29d) drivers/stm32f0x_ll_clock: Enable SYSCFG in clock_control
- [aec46596](https://github.com/zephyrproject-rtos/zephyr/commit/aec465968ce028ff8ed4440e4407859fbe9f2b4e) drivers/usb_dc_stm32: Check if SYSCFG is enabled
- [0c2ef4ea](https://github.com/zephyrproject-rtos/zephyr/commit/0c2ef4ea3dbff2a7746dddd49df6fb0842209382) drivers: watchdog: Watchdog API redesign
- [30a24e8a](https://github.com/zephyrproject-rtos/zephyr/commit/30a24e8ad0f4f90648d4d5cdbd15b89dbdf5aab8) drivers: watchdog: Add shim for nrfx WDT driver

External (4):

- [4f68b4dc](https://github.com/zephyrproject-rtos/zephyr/commit/4f68b4dc75cb448a35ed06e82c462d1933dfb5e6) ext: hal: altera: Add modular Scatter-Gather DMA HAL driver
- [9b5fa895](https://github.com/zephyrproject-rtos/zephyr/commit/9b5fa89547bc31f163c920ec0125da0f2c2a39d4) ext: hal: altera: Add wrapper function for Altera HAL runtime API
- [e2024171](https://github.com/zephyrproject-rtos/zephyr/commit/e2024171b0d090be0becd96532a99eb2f03f4630) ext: hal: ti: simplelink: ensure ROM APIs used in board port file
- [c5f1b0b8](https://github.com/zephyrproject-rtos/zephyr/commit/c5f1b0b862fca19b57f7322a32a9cdde54d99d4e) ext: hal: ti: simplelink: Add comments to CMakeLists.txt

Kernel (1):

- [abf77ef7](https://github.com/zephyrproject-rtos/zephyr/commit/abf77ef75337b85968b9270da3b0953844955b74) subsys: debug: Fix stack sentinel dependencies

Libraries (2):

- [a8532122](https://github.com/zephyrproject-rtos/zephyr/commit/a85321229ae15b031007cf66adce603bcefd7d25) newlib: libc-hooks: Print "exit" message with newline
- [42a2c964](https://github.com/zephyrproject-rtos/zephyr/commit/42a2c96422cbeb46f27074960b0898d06658fdcd) newlib: fix heap user mode access for MPU devices

Maintainers (3):

- [d9ff55f2](https://github.com/zephyrproject-rtos/zephyr/commit/d9ff55f2e344f8efb0612b45a8231352fa7f34db) CODEOWNERS: add more owners to tests/*
- [def4a4c1](https://github.com/zephyrproject-rtos/zephyr/commit/def4a4c1524b720f1e7a9794659943c0fb18c1e7) CODEOWNERS: more fix and and updates
- [6b5ded4c](https://github.com/zephyrproject-rtos/zephyr/commit/6b5ded4c3e3cb0c11b72771f8da3256e702a9c68) CODEOWNERS: Add pfalcon for various net directories

Miscellaneous (1):

- [81bac40b](https://github.com/zephyrproject-rtos/zephyr/commit/81bac40b79e044be2f33e14e4dcd674b5fd0565c) gitignore: let git ignore *.patch file only to top tree

Networking (22):

- [12855789](https://github.com/zephyrproject-rtos/zephyr/commit/128557896ce60d531c9eb69de69a3f7892976686) net: if: Add functions to get correct IPv4 address
- [3e16be3c](https://github.com/zephyrproject-rtos/zephyr/commit/3e16be3c3ce20296c991a35a5f805700a85b7dc7) net: lwm2m: refactor engine_get_obj to be more useful
- [44c9b79a](https://github.com/zephyrproject-rtos/zephyr/commit/44c9b79a49e5ed730c273bebcf7752a16dfc935d) net: lwm2m: clear lwm2m_obj_path obj in string_to_path
- [cf55b70b](https://github.com/zephyrproject-rtos/zephyr/commit/cf55b70b4c4c8c3a9cb1bc5d74230dc877b0f75c) net: lwm2m: fix error code in read and write handlers
- [f80c52d6](https://github.com/zephyrproject-rtos/zephyr/commit/f80c52d66857745dfe611eb04a61ee04ad4cfe7d) net: lwm2m: introduce LWM2M_HAS_PERM macro
- [aa9a24aa](https://github.com/zephyrproject-rtos/zephyr/commit/aa9a24aa25408f32cfe4024db0bed4865b8918d0) net: lwm2m: remove LWM2M_OP_NONE flag and renumber the rest
- [42717a97](https://github.com/zephyrproject-rtos/zephyr/commit/42717a97f76a614b8666bea69d37f7256ca3f4d4) net: lwm2m: use BIT macro instead of LWM2M_OP_BIT
- [b6ca731b](https://github.com/zephyrproject-rtos/zephyr/commit/b6ca731bdcf446ba98639b42a39236ad42de9c2d) net: lwm2m: remove unused CONFIG_LWM2M_BOOTSTRAP_PORT config
- [f038d35a](https://github.com/zephyrproject-rtos/zephyr/commit/f038d35a98aa212b1dc07db554ecd1ce8e8ce100) net: lwm2m: remove unused LWM2M_PEER_PORT define
- [af8a0b1a](https://github.com/zephyrproject-rtos/zephyr/commit/af8a0b1a5dec4dfcdbba3f4fee9d267e56df7971) net: tc: Proper packet priority to traffic class mapping
- [9681f3d0](https://github.com/zephyrproject-rtos/zephyr/commit/9681f3d081ede931cee8fff596395fa617a3d56c) net: Update bit size of _unused member in struct net_pkt
- [7359c5b1](https://github.com/zephyrproject-rtos/zephyr/commit/7359c5b10b5580ef5a8069a10ece874923033d90) net: lwm2m: Do not use snprintk() to get debugging token
- [8c2362a6](https://github.com/zephyrproject-rtos/zephyr/commit/8c2362a62dbd58bd9876c36250ef3608403f5932) net: ip: context: Merge send_data() into the only caller
- [bba1fe8c](https://github.com/zephyrproject-rtos/zephyr/commit/bba1fe8ca95c4021921606b7d0f61085080020ab) net: lwm2m: Re-order lwm2m object structs for memory alignment
- [2027c10a](https://github.com/zephyrproject-rtos/zephyr/commit/2027c10a9f0847ad0fd49ae6ca39c8346c3a5126) net: lwm2m: remove "path" from object and resource instances
- [bc7a5d3a](https://github.com/zephyrproject-rtos/zephyr/commit/bc7a5d3a6c7b4592c97e21a9191cb4d089330911) net: lwm2m: relocate/memory align notification_attrs struct
- [573c1f77](https://github.com/zephyrproject-rtos/zephyr/commit/573c1f777ef976c9aa10a0935696fce58193328c) net: lwm2m: improve return errors from update_attrs()
- [6ef46e3f](https://github.com/zephyrproject-rtos/zephyr/commit/6ef46e3f3141c753574ddd896f7d8e3aaef8632b) net: lwm2m: remove attr_list from obj, obj_inst and res_inst structs
- [ad13866f](https://github.com/zephyrproject-rtos/zephyr/commit/ad13866ffd61462aec1bc22ec5d6bdb0e974ca35) net: lwm2m: remove "used" from observe_node
- [fc8d0935](https://github.com/zephyrproject-rtos/zephyr/commit/fc8d0935924bf2c7378fe8d6413bc8ed182ccfaa) net: lwm2m: lower default maximum observes from 20 to 10
- [e81b9043](https://github.com/zephyrproject-rtos/zephyr/commit/e81b9043c50351d167a2b288801b972cfa856336) net: websocket: Simplify building of responses
- [03f9f664](https://github.com/zephyrproject-rtos/zephyr/commit/03f9f6649685c4d3068df6839b031e236b51d698) net: websocket: Revise generation of Sec-WebSocket-Accept header

Samples (5):

- [33eb03a8](https://github.com/zephyrproject-rtos/zephyr/commit/33eb03a8d927296cf8c2cc229cce614253eebffd) samples: net: https-client: Increasing main stack size
- [94136829](https://github.com/zephyrproject-rtos/zephyr/commit/94136829427610d7794d7b08c6db82a659d160cf) samples: subsys: usb: Set disk name Kconfig option
- [c913c671](https://github.com/zephyrproject-rtos/zephyr/commit/c913c6710d3c72dcd84210472475ddc29485b6b4) smaples/mgmt/mcumgr/smp_svr: fix missing nffs.h header
- [7d9631e6](https://github.com/zephyrproject-rtos/zephyr/commit/7d9631e62a313af67547b56b688a58529c40fe72) samples/net: Fix echo_client for cc2520
- [d536ffa6](https://github.com/zephyrproject-rtos/zephyr/commit/d536ffa694a06262ef3a7a5ffa0792f680692e51) samples/echo_server: Increased stack sizes for testing OT on kw41z

Scripts (13):

- [b737fcb9](https://github.com/zephyrproject-rtos/zephyr/commit/b737fcb9ba6a74531c1ac8d7b35a3f3b96b04297) scripts: kconfig: Add incremental search to menuconfig
- [7229a9a5](https://github.com/zephyrproject-rtos/zephyr/commit/7229a9a560692160fc21d2225658076f00e98804) scripts: kconfig: Switch 'menuconfig' over to menuconfig.py
- [133bad78](https://github.com/zephyrproject-rtos/zephyr/commit/133bad78998818f37c720eafcd501525081944bc) scripts: install windows-curses package on Windows
- [65f0c679](https://github.com/zephyrproject-rtos/zephyr/commit/65f0c67906941050171511c2e4c67a1e939ddd2d) checkpatch: downgrade COMPLEX_MACRO to a warning
- [27d34926](https://github.com/zephyrproject-rtos/zephyr/commit/27d34926e56736321e76477648491d26886a3f2c) menuconfig: Increase indent and make Unicode more robust
- [e099f381](https://github.com/zephyrproject-rtos/zephyr/commit/e099f3813ea232d641ecd606b4a9c38051735ade) scripts: extract_dts_includes: rename arguments for easier reading
- [081c9c3b](https://github.com/zephyrproject-rtos/zephyr/commit/081c9c3becc8b99f295ed015c4fc8c1f718bb515) scripts: extract_dts_includes: Generate'_0' defines only when needed
- [97a1ea22](https://github.com/zephyrproject-rtos/zephyr/commit/97a1ea22fcf62513ac5b043b93c8fe19d872149c) scripts: extract_dts_includes: Fix extract_cells for a list
- [ded17a91](https://github.com/zephyrproject-rtos/zephyr/commit/ded17a910dd5de387457bdda32fdd5111f969f87) scripts: extract_dts_includes: Fix extract_controller for a list
- [9272a3e5](https://github.com/zephyrproject-rtos/zephyr/commit/9272a3e5ac2ad98e80aaab4e3416492e89e3b19c) scripts: extract_dts_includes: remove prefix argument
- [93d3a427](https://github.com/zephyrproject-rtos/zephyr/commit/93d3a42776d5e0bddd9b2e061c5a46ee7d9ede16) scripts: extract_includes_dts: Remove usage of cell_string yaml attribute
- [295c1d85](https://github.com/zephyrproject-rtos/zephyr/commit/295c1d85803fae3ff03e834856ea43953348cb60) menuconfig: Fix rendering of long prefilled edit box string
- [e24788eb](https://github.com/zephyrproject-rtos/zephyr/commit/e24788eb71ce1af7c755d12e06d40c8c0a846f62) menuconfig: Make search more flexible and search prompts

Storage (6):

- [4954fe06](https://github.com/zephyrproject-rtos/zephyr/commit/4954fe06f2eacde232d5a6a4e2b201219ade93c3) subsys: fs: fix generic storage partition selection
- [f4dcb459](https://github.com/zephyrproject-rtos/zephyr/commit/f4dcb4593d51c4c28bb0431f3c95e4eae7910240) subsys: fs: fcb: fix - crc write size not aligned
- [b99ff6f9](https://github.com/zephyrproject-rtos/zephyr/commit/b99ff6f9e1602f79a9ef8eb5f43b17e65f1eace5) subsys: fs: Extend storage_dev type beyond 'struct device'
- [2b5b7da9](https://github.com/zephyrproject-rtos/zephyr/commit/2b5b7da9f34d96d29b26226f94502b4f99ae54c4) subsys: disk: Add support for multiple disk interfaces
- [dd5449a7](https://github.com/zephyrproject-rtos/zephyr/commit/dd5449a77b5c914143e2995e546c0246acbf78f1) subsys: fs: Add the support for multiple instances of fs
- [cf06bc58](https://github.com/zephyrproject-rtos/zephyr/commit/cf06bc58a7331519ad571afb8f9422a2cf0a8611) susbsys: settings: optimized fcb compression for deleted entry

Testing (35):

- [542f10de](https://github.com/zephyrproject-rtos/zephyr/commit/542f10de78992383318e432e5ee0050d83228cb4) tests: net: ip: Refactor and add IPv4 tests
- [11120bf1](https://github.com/zephyrproject-rtos/zephyr/commit/11120bf1c71723864e9c74c9df5055a0d5574c9e) tests: remove comma from whitelist
- [ee1e9886](https://github.com/zephyrproject-rtos/zephyr/commit/ee1e9886a9d7cea3c6c721079f2e2bce87078eac) tests: boards: altera_max10: Add test for Nios-II MSGDMA soft IP
- [7a587eea](https://github.com/zephyrproject-rtos/zephyr/commit/7a587eea8f764ccce39bb7ba9a045ca61ee3ae41) tests: document skipping tests and listing them
- [cc6f8b52](https://github.com/zephyrproject-rtos/zephyr/commit/cc6f8b524cbcd2ee26132edce5d7d349ccc7d717) tests: fp_sharing: Fix definition of PI_NUM_ITERATIONS
- [12c5bfaf](https://github.com/zephyrproject-rtos/zephyr/commit/12c5bfaf148a06549788277dc4a26f0c9e5da6a7) tests : ipv6_fragment : Avoid NULL pointer access
- [93109f2d](https://github.com/zephyrproject-rtos/zephyr/commit/93109f2d8ee04564a2451ff8d0bbe05221ab3a1d) tests: enhance test meta-data/improve test naming
- [efb52c5b](https://github.com/zephyrproject-rtos/zephyr/commit/efb52c5bc09904720eb43b4c02ba572e2a97b8d6) tests: neighbor: use ztest asserts
- [478f6807](https://github.com/zephyrproject-rtos/zephyr/commit/478f6807a4aefcd3e956f087af57fa54eaff10c4) tests: http: call tests via ztest macro
- [ee6b8761](https://github.com/zephyrproject-rtos/zephyr/commit/ee6b8761cd1688d796452988fb97a39cbbb0df77) tests: ipv6: convert to ztest
- [8603f7a4](https://github.com/zephyrproject-rtos/zephyr/commit/8603f7a4ce9dd3d5ef78e8d3947f574ba876522d) tests: flash_map: use proper test name
- [fa0a670d](https://github.com/zephyrproject-rtos/zephyr/commit/fa0a670dea1a3492ae2ec20de216ed524af9808e) tests: integration: do not run test on hw
- [bc672895](https://github.com/zephyrproject-rtos/zephyr/commit/bc672895bab69744aa905e15ee5e43f6f6353d67) tests: remove duplicate tests
- [540e11ce](https://github.com/zephyrproject-rtos/zephyr/commit/540e11ced7765e6256b4744a1cd46b079f4f382e) tests: rename main test to main.c
- [c57326e1](https://github.com/zephyrproject-rtos/zephyr/commit/c57326e1b69a7bbefdc4fb6703baae0d61658faa) tests: fix doxygen comments
- [c44f4e0e](https://github.com/zephyrproject-rtos/zephyr/commit/c44f4e0ee51bbde76f3d53530c2b948421ceed3e) tests: alert: add doxygen documentation
- [a279403c](https://github.com/zephyrproject-rtos/zephyr/commit/a279403c47da22898f74d04af6ef275a3acafcd1) tests: remove dot after PASS|FAIL
- [01b83175](https://github.com/zephyrproject-rtos/zephyr/commit/01b831751d8053c1fd6f96980faa82b196b1d549) tests: subsys: fs: Add changes to support multiple FS instance
- [c239ea70](https://github.com/zephyrproject-rtos/zephyr/commit/c239ea701fe6be5160e90df89283f598c00d6a64) tests: subsys: fs: Add test for FAT FS dual instance case
- [7174546b](https://github.com/zephyrproject-rtos/zephyr/commit/7174546b750f3c63270dc8ad7374c2db60b9111f) tests: threads: Document description for test cases
- [8e8cb4a9](https://github.com/zephyrproject-rtos/zephyr/commit/8e8cb4a90b9bda19caa3d80cb153fda4efc733b3) tests: doxygen comment cleanup
- [2a64fe66](https://github.com/zephyrproject-rtos/zephyr/commit/2a64fe666afe718cf33e50632c0572a6a31f9ebc) ztest: prints newline after failure message
- [79a0fa68](https://github.com/zephyrproject-rtos/zephyr/commit/79a0fa68e3cbbc5b3ddd480a6ec49e4f42993ed3) tests: mem_protect: Add memory domain testcases
- [0e8daafd](https://github.com/zephyrproject-rtos/zephyr/commit/0e8daafd4c86fe7a2b724370904be42e60a52d6e) tests kernel pending: unitialized variable
- [5ef03f5f](https://github.com/zephyrproject-rtos/zephyr/commit/5ef03f5f416f7ebffcd8c64034909191414ac6ae) tests: spi_loopback: Add frdm_kw41z configuration
- [3be0c56d](https://github.com/zephyrproject-rtos/zephyr/commit/3be0c56d50ec4eca188be45e6ce35b952a381935) tests/subsys/settings/fcb: add deleted settings compression test
- [d76cc488](https://github.com/zephyrproject-rtos/zephyr/commit/d76cc488a2a216f1d49776823aba1838305d8e5d) tests: net: checksum_offload: Check for valid UDP_HDR
- [5575487d](https://github.com/zephyrproject-rtos/zephyr/commit/5575487da6db8deb2ae3d2ae17c58fceb7c52096) tests: posix: Fix sigevent initialization
- [f71e497d](https://github.com/zephyrproject-rtos/zephyr/commit/f71e497d98f34c4c1ce2553367363a1b898f7da6) tests: net: ipv6: Add assert for net_if_config_ipv6_get
- [7e0d1d27](https://github.com/zephyrproject-rtos/zephyr/commit/7e0d1d27d5c6bb3899002fc882413cbf8849e7bd) tests: lib: rbtree: Clarify increment of variable
- [93e71ab0](https://github.com/zephyrproject-rtos/zephyr/commit/93e71ab092a3d77324a8f03788ada31b9f3b70bd) tests: net: mgmt: Do not allocate link address from stack
- [d5515658](https://github.com/zephyrproject-rtos/zephyr/commit/d551565802e2de579ab3e77eb196ddf3f6580643) tests: net: coap: Fix uninitialized memory access
- [47638440](https://github.com/zephyrproject-rtos/zephyr/commit/47638440136542cc2027818bda24f0aacb3a7f44) tests: net: tcp: IPv4 header was not initialized
- [e8d0571b](https://github.com/zephyrproject-rtos/zephyr/commit/e8d0571b26dcba603d857282f4b987f558f333e4) tests: net: tcp: Remove unnecessary code
- [c9898097](https://github.com/zephyrproject-rtos/zephyr/commit/c9898097bb68ce47413f2cc14ebfa671ee622dd2) tests: watchdog: Add new test implementation

