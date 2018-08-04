+++
title = "Zephyr Development News 19 June 2018"
date = "2018-06-19"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 19 June 2018 newsletter tracking the latest
[Zephyr](https://www.zephyrproject.org/) development merged into the
[mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

<!--more-->

As usual, content is broken down as follows:

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

The floodgates are open with the beginning of the v1.13 merge
window. This newsletter covers the following inclusive commit range:

- [0f9a6426](https://github.com/zephyrproject-rtos/zephyr/commit/0f9a642697f51ff4e22bf4be5163f428b27e868e) release: Post-release patch level update
- [fb6f9b78](https://github.com/zephyrproject-rtos/zephyr/commit/fb6f9b78c9094ca9ae7cc16aa43eb1988ba18440) ext: Kconfig: Remove redundant 'default n' properties

Important Changes
-----------------

**CONF_FILE can now be a CMake list:**

Most Zephyr users will likely recognize the CMake variable `CONF_FILE`,
which can be used to set the path to the top-level application Kconfig
fragment. (Normally, this defaults to `prj.conf`.)

A longstanding but lesser-known feature is that `CONF_FILE` can also
be a whitespace-separated list of fragments; these will all be merged
into the final configuration. Some samples use this feature to add
board-specific "mix-ins" to the top-level prj.conf; see the
[led_ws2812 CMakeLists.txt](https://github.com/zephyrproject-rtos/zephyr/blob/fb6f9b78c9094ca9ae7cc16aa43eb1988ba18440/samples/drivers/led_ws2812/CMakeLists.txt)
for an example.

The "whitespace-separated" part of this feature is a holdover from
when Zephyr used the Linux kernel's Makefile build system,
Kbuild. Since moving to CMake, the whitespace separation has been a
little bit less convenient, as CMake uses semicolon-separated strings
as its internal "list" data type.

To make this feature cleaner in the new world order, `CONF_FILE` now
also supports separation via semicolons. The old whitespace separation
behavior is not affected to keep backwards compatibility. For example,
setting `-DCONF_FILE="hello.conf;world.conf zephyr.conf"` at the
CMake command line would merge the three fragments `hello.conf`,
`world.conf`, and `zephyr.conf` into the final `.config`.

**PWM on STM32:**

Device tree bindings were added for timers and PWM devices on STM32
targets.  A large variety of STM32 targets (F0, F1, F3, F4, and L4
families) now have such nodes added on a per-SoC basis. Many of the
official boards produced by STMicroelectronics now have PWM enabled.

The old Kconfig options (`CONFIG_PWM_STM32_x_DEV_NAME`, etc.) have
been removed. Applications using PWM on STM32 may need updates to
reflect this switch to device tree.

**UART on nRF:**

The UART driver for nRF devices has been refactored to use the vendor
HAL. This change was followed by a large tree-wide rename of the
Kconfig options: `CONFIG_UART_NRF5` was renamed to `CONFIG_UART_NRFX`,
and `CONFIG_UART_NRF5_xxx` options were renamed to
`CONFIG_UART_0_NRF_xxx`.

Applications using this driver may need updates.

**Many Kconfig warnings are now errors:**

The tree-wide cleanups and improvements to Zephyr's usage of Kconfig
continues as Kconfiglib grows more features. Notably, many warnings
are now errors, improving the rate at which CI catches Kconfig
issues.

Features
--------

**Arches:**

The work to enable Arm v8-M SoCs, some of which include support for
"secure" and "non-secure" execution states, continues. There is a new
`CONFIG_ARM_NONSECURE_FIRMWARE` option, which signals that the
application being built is targeting the non-secure execution
state. This depends on a new hidden `CONFIG_ARMV8_M_SE` option, which
SoCs can select to signal that hardware support for this feature is
present. This was followed with infrastructure APIs related to address
accessibility and interrupt management in secure and non-secure
contexts.

The [native POSIX]
(http://docs.zephyrproject.org/boards/posix/native_posix/doc/board.html)
"architecture" now supports `-rt` and `-no-rt` command line
options, which allow deferring the decision for whether execution
should be slowed down to real time to runtime. (The option
`CONFIG_NATIVE_POSIX_SLOWDOWN_TO_REAL_TIME` now determines the
default value.)

**Bluetooth:**

There is a new choice option for controlling the [transmit
power](http://docs.zephyrproject.org/reference/kconfig/choice_149.html)
value.

On Linux hosts, the native POSIX target can now access the kernel
Bluetooth stack via a new HCI driver, which can be enabled with
`CONFIG_BT_USERCHAN`.

The Bluetooth mesh sample application
`samples/boards/nrf52/mesh/onoff-app` now supports the persistent
storage API introduced in v1.12. This allows the application to rejoin
the same network if the board is reset.

The host stack now supports more flexible choices for how to pass
attributes to `bt_gatt_notify()`.

**Boards:**

The frdm_kl25z board now supports USB.

Nordic board Kconfig files can now select `CONFIG_BOARD_HAS_DCDC`,
which will enable the DC/DC converter.

**Build:**

There is a new `CONFIG_SPEED_OPTIMIZATIONS` flag, which requests the
build system to optimize for speed. (The default is to optimize for
binary size.)

The warning output for when the value a user sets for a Kconfig option
differs from the actual value has been improved.

**Documentation:**

Zephyr's Kconfig documentation now includes output for choices. For
example, here is the [page documenting the architecture
choice](http://docs.zephyrproject.org/reference/kconfig/choice_0.html#choice-0).

**Device Tree:**

The RISCV32 QEMU target now has DT support for flash, SRAM, and UART.

nRF52 SoCs now have device tree support for GPIO.

**Drivers:**

A variety of nRF peripheral accesses throughout the tree were replaced
with calls to inline accessors in the vendor HAL. The stated reason
given is to enable easier testing.

The nRF PWM driver now has prescaler support.

The mcux Ethernet driver now uses the carrier detection API calls
described below in the new networking features.

A new driver for the TI SimpleLink WiFi offload chip was merged; so
far, this only supports the network management commands related to
WiFi which were introduced for v1.12 (see `include/net/wifi_mgmt.h`
for details).

A variety of USB-related changes were merged.

The USB subsystem now sports new `USBD_DESCR_xxx_DEFINE` macros for
declaring descriptors of various types; behind the scenes, these use
linker magic to ensure that the defined descriptors end up in
contiguous memory. This allowed migrating descriptors formerly defined
in an increasingly large `subsys/usb/usb_descriptor.c` into the files
for the individual USB classes, etc. that defined them.

As all Zephyr USB controllers support USB v2.0, the USB protocol
version reported in the device descriptor has been updated to that
value, increasing it from its former setting of v1.1.

The HID interrupt endpoint size configuration option
`CONFIG_HID_INTERRUPT_EP_MPS` is now visible and thus configurable by
applications.

Interface descriptors are now configurable at runtime.

**Networking:**

Ethernet drivers can now signal detection and loss of a carrier via
new `net_eth_carrier_on()` and `net_eth_carrier_off()`
routines. This is used by the [network
management](http://docs.zephyrproject.org/subsystems/networking/network-management-api.html)
core to generate interface "up" and "down" events. This is used by the
DHCP implementation to obtain new addresses when a network interface
reappears after going down.

The network shell's `conn` command now unconditionally prints the
state of each TCP connection.

A variety of performance improvements were merged into the networking
layer; these speed things up by avoiding unnecessary work, like
duplicated filling in of packet headers and checksums. Better
management of some internal caches when multiple networking interfaces
are running on board was also merged.

**Samples:**

The BBC micro:bit now supports servomotors; see ``samples/basic/servo_motor``.

**Scripts:**

A variety of updates were merged to the Kconfiglib dependency vendored
into Zephyr, along with its users; these are mostly related to
hardening warnings into errors and improving error and warning output.

**Testing:**

The long-ranging work on [issue
6991](https://github.com/zephyrproject-rtos/zephyr/issues/6991)
continues with several samples being refactored, moved or otherwise
cleaned up to better fit in a test management system.

Bug Fixes
---------

**Arches:**

The PendSV interrupt handler now prevents other operating system
interrupts from running before accessing kernel state, preventing races.

**Bluetooth:**

The USB Bluetooth device class implementation saw a few
fixes. Notably, it now has a transmit thread as well as a receive
thread, fixing an issue where `bt_send()` was incorrectly called
from interrupt context, and properly reserves some headroom needed in
its net_buf structures.

**Build:**

The `CONFIG_COMPILER_OPT` option now allows setting multiple compiler
options, separated by whitespace.

Numerous fixes and updates were merged affecting usage of Kconfig
options throughout the tree.

The "minimal" C library that ships with Zephyr is no longer built as
part of the "app" target, which is reserved as much as possible for
user applications. Any applications that may have been relying on this
behavior may need updates, as the C library is now part of its own
Zephyr library.

**Drivers:**

Bluetooth drivers now have access to `bt_hci_cmd_send()` and
`bt_hci_cmd_send_sync()` routines via `<hci.h>`; allowing them to,
well, send HCI commands. HCI drivers can now also declare "quirks", or
deviations from standard behavior, with `BT_QUIRK_NO_RESET` being the
first user.

The Nordic RTC timer driver saw a fix for the number of hardware
cycles per tick; the PWM driver also has improved accuracy after a
clock frequency fix.

A build issue in the Bluetooth HCI implementation using SPI as a
transport was fixed.

The lis2dh accelerometer driver seems to be working again, after
seeing build breakage and I2C protocol usage fixes.

**Kernel:**

A fix was merged partially restoring the behavior of
`CONFIG_MULTITHREADING=n` following the scheduler rewrite. (Some
former behavior related to semaphores was not restored, forcing flash
drivers elsewhere in the tree to behave differently depending on
whether this option is enabled.)

A race condition which could cause
[k_poll()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv26k_pollP12k_poll_eventi5s32_t)
to return NULL when a timeout is set has been fixed.

**Networking:**

The TCP stack now properly responds to [Zero Window
Probe](https://tools.ietf.org/html/rfc6429) segments.

Some use-after free bugs in network statistics calculations were fixed.

IPv4 and UDP checksums are now calculated only when needed in the DHCPv4 core.

**Samples:**

The `mbedtls_sslclient` networking sample now uses a hardware
entropy source at system startup to seed the random number generator
when one is available, rather than relying on `sys_rand32_get()`,
which doesn't guarantee cryptographically strong output.

Individual Changes
==================

Patches by area (226 patches total):

- Arches: 26
- Bluetooth: 25
- Boards: 5
- Build: 14
- Continuous Integration: 2
- Device Tree: 11
- Documentation: 12
- Drivers: 59
- External: 3
- Kernel: 5
- Libraries: 2
- Miscellaneous: 3
- Networking: 27
- Samples: 12
- Scripts: 11
- Storage: 1
- Testing: 8

Arches (26):

- [a7de06a6](https://github.com/zephyrproject-rtos/zephyr/commit/a7de06a687138a64b01f512a89adeb188f5932a7) native_posix: irq_offload to use a sw interrupt
- [477b5497](https://github.com/zephyrproject-rtos/zephyr/commit/477b5497a72310bcb8431e4df83f82284b7c0386) native: Add command line options to control real timeness
- [ab81d2c7](https://github.com/zephyrproject-rtos/zephyr/commit/ab81d2c7abf2221d374c5e74a5992026babc41c7) arch: arm: block ARM_MPU K-option in Cortex-M0
- [7b56b448](https://github.com/zephyrproject-rtos/zephyr/commit/7b56b448f666f5055f679a3458ac45cf3def7c49) arch: arm: accelerate _get_num_regions() for Cortex-M0+, M3, and M4
- [dbede45d](https://github.com/zephyrproject-rtos/zephyr/commit/dbede45dbe77709c54da9b8f9636eda2e70a2eff) arch: arm: improve inline comment in _arm_mpu_config/enable
- [61439b01](https://github.com/zephyrproject-rtos/zephyr/commit/61439b01c20f2951e39030091a5cb460b6c3aa8b) arch: arm: remove redundant flag
- [41070c3b](https://github.com/zephyrproject-rtos/zephyr/commit/41070c3b35f510c82ecffde66bce5b07633cf98b) arch/arm: Fix locking in __pendsv
- [8c53f242](https://github.com/zephyrproject-rtos/zephyr/commit/8c53f2422c4b2ea53ebb8bc0d3f3d9df1073fd86) arch: arm: set VECTOR_ADDRESS to _vector_start
- [28007296](https://github.com/zephyrproject-rtos/zephyr/commit/2800729614f5a91aac7164695d5de11dea184d93) arch/stm32: remove irq definition files
- [3a87e0ed](https://github.com/zephyrproject-rtos/zephyr/commit/3a87e0ed057d21158dfbbd0358594892d296d770) native: Fix entropy generator kconfig warning
- [ebbb744b](https://github.com/zephyrproject-rtos/zephyr/commit/ebbb744b031bd4ad073aad812ab8d709cde3e576) native: Fix host BT driver kconfig warning
- [070c1ae0](https://github.com/zephyrproject-rtos/zephyr/commit/070c1ae04139ac39a2943a0e8c85fadf4a42eb41) soc: nRF52x: Add Kconfig options to enable DC/DC converter
- [f177fb88](https://github.com/zephyrproject-rtos/zephyr/commit/f177fb88a0d9b549ca93d809162d1d032fae813f) arch: arc: Fix reference to removed NSIM Kconfig symbol
- [77643677](https://github.com/zephyrproject-rtos/zephyr/commit/77643677a1ee289b7a367aecfcc31a19c0e8b596) esp32: update to ESP-IDF v3.0-dev-2648-gb2ff235b
- [31aa9b9a](https://github.com/zephyrproject-rtos/zephyr/commit/31aa9b9ad151e658df28f4119c5dbd026992fb1b) arch: arm: atmel_sam: Use a single RAM region when possible
- [e86c53b4](https://github.com/zephyrproject-rtos/zephyr/commit/e86c53b48f072834c2f5c7361887cea30a22e945) arch: arm: atmel_sam: Map the whole RAM in MPU
- [bb55155d](https://github.com/zephyrproject-rtos/zephyr/commit/bb55155d5be62ddec209f68bdb801907c7d9cd78) arch: arm: core: cortex_m: add a barrier before the dummy FP instruction
- [158ea44e](https://github.com/zephyrproject-rtos/zephyr/commit/158ea44ed3e419229cb0d0aad9d874dcde4cb4bb) arch: arm: improve help text for ARM_SECURE_FIRMWARE
- [dd640f14](https://github.com/zephyrproject-rtos/zephyr/commit/dd640f143e14776f43f7bf71047fde246663faeb) arch: arm: introduce ARM_NONSECURE_FIRMWARE option
- [13dc3762](https://github.com/zephyrproject-rtos/zephyr/commit/13dc376240e88eb2e07127a3f281582faeb0c3f4) arch: arm: introduce ARMV8_M_SE option
- [0a2dcaaf](https://github.com/zephyrproject-rtos/zephyr/commit/0a2dcaaf8fb72d32986410f0da56ef1b46659f3a) arch: arm: introduce dependencies for CPU_CORTEX_M_HAS_SPLIM option
- [f630559e](https://github.com/zephyrproject-rtos/zephyr/commit/f630559e815d78c0f9afee82367727989fe49737) arch: arm: Define and implement API for test target (Secure)
- [d426adcc](https://github.com/zephyrproject-rtos/zephyr/commit/d426adccaa6fa94726c526fb2f5272854fe3dc48) arch: arm: refactor function to align with the adopted api
- [87936612](https://github.com/zephyrproject-rtos/zephyr/commit/879366120e7d049c719e380aeb729519a7d5cc5b) arch: arm: implement cmse address range check (secure)
- [fe3cd4c8](https://github.com/zephyrproject-rtos/zephyr/commit/fe3cd4c8ff4a4ef5897844d85de8e9b5d953382a) arch: arm: convenience wrappers for C variable Non-Secure permissions
- [7a864bb7](https://github.com/zephyrproject-rtos/zephyr/commit/7a864bb79b3c75739fc36183a9dd67569584e1ea) arch: arm: define and implement ARM IRQ target state API

Bluetooth (25):

- [c3edc82f](https://github.com/zephyrproject-rtos/zephyr/commit/c3edc82fe7811e3d1c2b1a421918c3ba6a4b3d99) Bluetooth: GATT: Allow Characterist to be used with bt_gatt_notify
- [679a0b39](https://github.com/zephyrproject-rtos/zephyr/commit/679a0b395fc80959200eb82dbf4c7fedcd8b9b8f) Bluetooth: GATT: Allow Characterist to be used with bt_gatt_indicate
- [68de9d5d](https://github.com/zephyrproject-rtos/zephyr/commit/68de9d5d66f37ece9982df18d6eda2bf6c00d85e) Bluetooth: Use Characteristic attribute whenever possible
- [7d989657](https://github.com/zephyrproject-rtos/zephyr/commit/7d9896575b00c54d5f8cd38cef9d9667aa3b0bf9) Bluetooth: Add HCI User Channel driver for native POSIX port
- [ea5b8667](https://github.com/zephyrproject-rtos/zephyr/commit/ea5b866763ebcc6222e28e335b6add6051671c56) Bluetooth: hci: spi: Select BT_RECV_IS_RX_THREAD
- [edb2ad11](https://github.com/zephyrproject-rtos/zephyr/commit/edb2ad11f0387a1a9162c42b180a9e969d8173ca) Bluetooth: controller: Remove redundant include of cmsis.h
- [dc95e1ba](https://github.com/zephyrproject-rtos/zephyr/commit/dc95e1ba05cfed5231da8db39bebded2d0ebd65c) Bluetooth: controller: Add Tx Power Kconfig option
- [362a6b34](https://github.com/zephyrproject-rtos/zephyr/commit/362a6b34c76a5d645c9985f2cae5d5400eddd7d9) Bluetooth: controller: Fix to use max. tx power in DTM test mode
- [bb4ed94c](https://github.com/zephyrproject-rtos/zephyr/commit/bb4ed94c606a2a49293dfbb8dad631349975c6c9) bluetooth: tester: Increase system workqueue stack size
- [e1b77247](https://github.com/zephyrproject-rtos/zephyr/commit/e1b772479b12ccf31b3ec8e3c5b43d1644038535) Bluetooth: GATT: Fix notifications
- [b1b10171](https://github.com/zephyrproject-rtos/zephyr/commit/b1b10171787a11d002e3ed05e254d5e4cd4df8c3) Bluetooth: Export HCI command APIs through public hci.h header file
- [b20aff2f](https://github.com/zephyrproject-rtos/zephyr/commit/b20aff2f80271364f6dd865993cfbaa82401d9d7) Bluetooth: Introduce HCI driver quirks
- [660c5c92](https://github.com/zephyrproject-rtos/zephyr/commit/660c5c92c08eb9fe34a2c475d3fe47678d44677f) Bluetooth: controller: Remove include guards in internal files
- [37e6162c](https://github.com/zephyrproject-rtos/zephyr/commit/37e6162c47893f40344999da65282d57c2047138) bluetooth: tester: Fix bt_gatt_service_register call with invalid params
- [3904442e](https://github.com/zephyrproject-rtos/zephyr/commit/3904442e6bd24b2fff45e0a2a7a0c9d60576a45b) bluetooth: tester: Remove redundant config option from qemu.conf
- [aa190cd5](https://github.com/zephyrproject-rtos/zephyr/commit/aa190cd5b5f4e6229e67b9ac2c9ed2608c8c96b7) bluetooth: tester: Set configuration file for qemu_cortex_m3 target
- [48b7f236](https://github.com/zephyrproject-rtos/zephyr/commit/48b7f236fa3ffd1c1bcde3d22a5895836fe83d4e) Bluetooth: Fix assertion condition in bt_gatt_discover
- [bc606d22](https://github.com/zephyrproject-rtos/zephyr/commit/bc606d22204c2fa501a5b0dcc24293bbebc0585b) Bluetooth: controller: Use nRFx functions for RTC reg with sideeffects
- [347f3262](https://github.com/zephyrproject-rtos/zephyr/commit/347f32621a97d5cbd1a4b48e583468c45b89ebfc) Bluetooth: controller: Use nRFx functions for ECB reg with sideeffect
- [17429725](https://github.com/zephyrproject-rtos/zephyr/commit/17429725850ba0acafebe0ece90729ee6e2c4a5f) Bluetooth: controller: Use SOC series macro instead of board macro
- [5f146e49](https://github.com/zephyrproject-rtos/zephyr/commit/5f146e491ecf07ef325828f9229f9c4edbdc8452) Bluetooth: controller: Use SOC series macro instead of the board macro
- [88f0fbdc](https://github.com/zephyrproject-rtos/zephyr/commit/88f0fbdc00f8e78ea912f724f3eeee47564a808b) Bluetooth: controller: Use nRFx functions for RTC reg w sideeffects
- [1c5bb494](https://github.com/zephyrproject-rtos/zephyr/commit/1c5bb494159698ffd136f1be6851d001d07e8afa) Bluetooth: controller: Use nRFx functions for CCM reg w sideeffects
- [c97645c8](https://github.com/zephyrproject-rtos/zephyr/commit/c97645c88430767f1e905ad76507f1777441a2ae) Bluetooth: controller: Use nRFx functions for TIMER reg w sideeffects
- [15ae4fa3](https://github.com/zephyrproject-rtos/zephyr/commit/15ae4fa314ef0c7876890776b90293c0ea83cfb8) Bluetooth: controller: Use nRFx functions for PPI reg with sideef

Boards (5):

- [fb3aedde](https://github.com/zephyrproject-rtos/zephyr/commit/fb3aeddebbf7a10ff4e11a7a3d691a8fe2d8f76b) boards: lpcxpresso54114_m0: do not set as default
- [a58043e1](https://github.com/zephyrproject-rtos/zephyr/commit/a58043e187a2ca744d75ee010b433915033ed51f) boards: cc3220sf_launchxl: Restore removal of CONFIG_XIP setting
- [558eac2f](https://github.com/zephyrproject-rtos/zephyr/commit/558eac2f9825327500038ad198d3613daabff924) boards: arm: stm32: Added pwm to supported list
- [2055b84f](https://github.com/zephyrproject-rtos/zephyr/commit/2055b84f7909453904606a83192497f10ce132d4) boards: frdm_kl25z: add USB support
- [74c44b29](https://github.com/zephyrproject-rtos/zephyr/commit/74c44b29845f16cbc0a03c84f106d197092021af) boards: arm: nrf52840: default IEEE802154_NRF5 if IEEE802154 enabled

Build (14):

- [d94231f6](https://github.com/zephyrproject-rtos/zephyr/commit/d94231f66ef396b854daf450c36b3e1f1130e262) cmake: libc: minimal: Move sources from 'app' to a new CMake library
- [025a1e90](https://github.com/zephyrproject-rtos/zephyr/commit/025a1e9086f01af62907a1dfaf3be73b861f9c23) cmake: fix CONF_FILE parsing to allow for cmake lists
- [ee9af86f](https://github.com/zephyrproject-rtos/zephyr/commit/ee9af86f4c0aa25a938e1bdc4312f8e91d35dd46) cmake: Improve user error feedback when -H$ZEPHYR_BASE is specified
- [a74e80fa](https://github.com/zephyrproject-rtos/zephyr/commit/a74e80fa5f108852c25332d26043015e57695427) cmake: Removing the need for always rebuild
- [f38e388a](https://github.com/zephyrproject-rtos/zephyr/commit/f38e388ad1b9150bb75941bcf65015cf2276536c) cmake: Update to dependency handling for syscalls.json
- [8f3fea30](https://github.com/zephyrproject-rtos/zephyr/commit/8f3fea300af612062cc3a4cba0fd3b59b613a050) cmake: bluetooth: Don't #include gatt files from src files
- [7f5203d3](https://github.com/zephyrproject-rtos/zephyr/commit/7f5203d370d1f3b299192df6ff8035f7b722c148) kconfig: Remove UART_QMSI_{0,1}_NAME Kconfig reference
- [2e0af08e](https://github.com/zephyrproject-rtos/zephyr/commit/2e0af08e551187e53229f4e712d7503e9447644a) build: remove unused CMakeLists.txt
- [d62117e5](https://github.com/zephyrproject-rtos/zephyr/commit/d62117e5b84dcbab00c2cc248bda6447767cc6f4) kconfig: Change how BT affects SYSTEM_WORKQUEUE_PRIORITY
- [b35a41f9](https://github.com/zephyrproject-rtos/zephyr/commit/b35a41f9815cf84afd2e87f5128dbf55db094a7d) include: linker: add sections for USB device stack
- [5bfc7ff2](https://github.com/zephyrproject-rtos/zephyr/commit/5bfc7ff2753c9b4c8eb29adb26c77605c5eb4836) kconfig: Fail in CI if Kconfig files reference undefined symbols
- [92a6898b](https://github.com/zephyrproject-rtos/zephyr/commit/92a6898bd2260478f9a5ac71ee57da385a6ed01c) cmake: allow multiple compiler options
- [e8413d18](https://github.com/zephyrproject-rtos/zephyr/commit/e8413d18f50365cea468ad5ce52baddcdb534077) kconfig: add a compiler speed optimization
- [3c1a78ea](https://github.com/zephyrproject-rtos/zephyr/commit/3c1a78ea0d51ee5eeab1a0ff9d9f275312f1af23) cmake: replace PROJECT_SOURCE_DIR with ZEPHYR_BASE

Continuous Integration (2):

- [33fa63e4](https://github.com/zephyrproject-rtos/zephyr/commit/33fa63e40ec9550cda2d899996accf9163a4e770) sanitycheck: Add progress to verbose mode
- [5dce5ea5](https://github.com/zephyrproject-rtos/zephyr/commit/5dce5ea56efff9c7e5e7f3e148da0cd4b2e201d0) ci: user latest docker file

Device Tree (11):

- [e5b0e9ac](https://github.com/zephyrproject-rtos/zephyr/commit/e5b0e9ac073ab115e3de845a7396134910b56dae) DTS: interrupt controller: Define IRQ priorities for CAVS & DW ICTL
- [4ec773f2](https://github.com/zephyrproject-rtos/zephyr/commit/4ec773f276925d9aff88120fbbee9341ac4c62a1) DTS: intel_s1000: Clean up I2C and UART stuff from soc.h
- [71e66f06](https://github.com/zephyrproject-rtos/zephyr/commit/71e66f06b4eefda7ea991cf008db4a684c15743c) dts: stm32: Add Timer and PWM binding
- [0e8d97f1](https://github.com/zephyrproject-rtos/zephyr/commit/0e8d97f186df24c259f2e89ca9b7c6a5330ea18e) dts: stm32f0: Add PWM nodes
- [da0caab3](https://github.com/zephyrproject-rtos/zephyr/commit/da0caab3fd5607a01269b6d045a7eeb75a2de7c9) dts: stm32f1: Add PWM nodes
- [bfa1941e](https://github.com/zephyrproject-rtos/zephyr/commit/bfa1941e1d9f1345e49becae66c01d7dcf7d0040) dts: stm32f3: Add PWM nodes
- [7a60a2c4](https://github.com/zephyrproject-rtos/zephyr/commit/7a60a2c49b10a3b629c1de74cc234eedea518434) dts: stm32f4: Add PWM nodes
- [c7d2dc23](https://github.com/zephyrproject-rtos/zephyr/commit/c7d2dc23632b95f640e307224051e08268fae9ed) dts: stm32l4: Add PWM nodes
- [5c6ccf4a](https://github.com/zephyrproject-rtos/zephyr/commit/5c6ccf4acc9530d765dd153582beffe04c9767f6) dts: stm32: Enable PWM nodes on selected boards
- [b7c4c030](https://github.com/zephyrproject-rtos/zephyr/commit/b7c4c0302cb441bd6a845c3be7348727cb9526a1) dts: riscv32: riscv32-qemu: Add device tree support
- [0824ec64](https://github.com/zephyrproject-rtos/zephyr/commit/0824ec640950b857cd4a270a058fe25991fba924) dt: nrf52840: remove 0x from USBD address

Documentation (12):

- [5917f9b6](https://github.com/zephyrproject-rtos/zephyr/commit/5917f9b605cefd70cd38295643870252618a351a) doc: Makefile: Remove CONFIG_SHELL assignment
- [953dfe75](https://github.com/zephyrproject-rtos/zephyr/commit/953dfe75e5c113979b73d0a28f2a622ba7bebb93) doc: Makefile: Remove the 'doxy-code' target
- [fa121da1](https://github.com/zephyrproject-rtos/zephyr/commit/fa121da196264af8affc238e08eb6401caeac854) doc: Makefile: Remove the 'prep' target
- [9af9b1fb](https://github.com/zephyrproject-rtos/zephyr/commit/9af9b1fbdb7ad92d1a8f7f3fddfc69402d2666e4) doc: Makefile: Lowercase internal Make variables
- [a760c5b0](https://github.com/zephyrproject-rtos/zephyr/commit/a760c5b0293173814ef2e8bbd9b869f19508dd7d) doc: Makefile: Remove latex_paper_size (PAPER) option
- [4dcf928a](https://github.com/zephyrproject-rtos/zephyr/commit/4dcf928a4058d70e85bfe694dbef8733b7351bcf) doc: fix doxygen error for device.h macros
- [92f146ea](https://github.com/zephyrproject-rtos/zephyr/commit/92f146ea7abf1aab3f63792449b90a9b7aa4f050) doc: update application docs wrt CONF_FILE
- [ef75956d](https://github.com/zephyrproject-rtos/zephyr/commit/ef75956deb4c311a57a9e63be33be5dfa6200aa4) doc: update known-issues filter
- [f5e38130](https://github.com/zephyrproject-rtos/zephyr/commit/f5e3813010a3214c26bb2501b3ded4d547b23739) docs: Fix mailbox k_mbox_msg.tx_block documentation
- [d901add4](https://github.com/zephyrproject-rtos/zephyr/commit/d901add4c7b804cd39c167d36811060931e2bb78) doc: update .gitignore file list
- [a3d83ec9](https://github.com/zephyrproject-rtos/zephyr/commit/a3d83ec9f40c54e4e10149b13b201076cbbc0cd7) doc: update doc build tools documentation
- [de6d61d1](https://github.com/zephyrproject-rtos/zephyr/commit/de6d61d110d601d8ff470a29f040b80010c45c2d) doc: remove local copy of jquery.js

Drivers (59):

- [e16037d8](https://github.com/zephyrproject-rtos/zephyr/commit/e16037d87aba4d14d3cb432e4b61a2e3eeffbff1) drivers: sensor: lis2dh: Fix of compilation issue
- [87bd2c25](https://github.com/zephyrproject-rtos/zephyr/commit/87bd2c25bffa84dcf870b1ca5f79896d7edfa30b) drivers: sensor: lis2dh: Fix I2C burst read/write operations
- [e7206318](https://github.com/zephyrproject-rtos/zephyr/commit/e7206318fa5f4232deb03c87dee1071e92b8a72e) drivers: eth: mcux: Inform IP stack when carrier is lost
- [51fecf80](https://github.com/zephyrproject-rtos/zephyr/commit/51fecf80d955c0fda06630a4169396ca5c4a603c) usb: bluetooth: Add TX thread
- [00a6b4c5](https://github.com/zephyrproject-rtos/zephyr/commit/00a6b4c5ae9ff54d266c075eead897820118e6c7) usb: bluetooth: Fix assert due to unreserved headroom
- [452cb618](https://github.com/zephyrproject-rtos/zephyr/commit/452cb618449172beff851ebe67cd0952e958974f) usb: bluetooth: Use transfer API for ACL packets
- [1ce6a6ea](https://github.com/zephyrproject-rtos/zephyr/commit/1ce6a6eaa83f2d8a0c79ce1c2890c253877cd279) subsys: usb: update bcdUSB to 2.00
- [7b7784e1](https://github.com/zephyrproject-rtos/zephyr/commit/7b7784e14967304b54ff2ac500ec9e0246ea8bf0) drivers: dma_cavs: Add support for circular list
- [3f3a907b](https://github.com/zephyrproject-rtos/zephyr/commit/3f3a907bb87139a11be11ede520434ccd61eda31) drivers: timer: Use sys_clock_hw_cycles_per_tick in nrf_rtc_timer.
- [c524ff6b](https://github.com/zephyrproject-rtos/zephyr/commit/c524ff6b8c366a7d5b788e0c97f0cf23a7d46dc1) subsys: console: getchar: Use consistent var names for RX path
- [0bdcef9e](https://github.com/zephyrproject-rtos/zephyr/commit/0bdcef9e00ae02c0ae9f0d8fdd83cfd5e214e6f4) pwm: stm32: Use macro to simplify registration
- [f34e74db](https://github.com/zephyrproject-rtos/zephyr/commit/f34e74dba2b4487197fc52cea3852828b749544f) pwm: stm32: Add support for all PWMs up to PWM20
- [20365bac](https://github.com/zephyrproject-rtos/zephyr/commit/20365bac0e856934281ba9002f47e1422024c0c6) pwm: stm32: Do not hardcode the prescalers
- [c65499d4](https://github.com/zephyrproject-rtos/zephyr/commit/c65499d4855ff4882bc8d0174d7730f0317086e7) pwm: stm32: Add clock group information
- [07908748](https://github.com/zephyrproject-rtos/zephyr/commit/079087483da6ea717fc2eeea4e996aa160ff5868) pwm: stm32: Add STM32F0-specific clocks
- [bef42fad](https://github.com/zephyrproject-rtos/zephyr/commit/bef42fad57d9dc57d29fbbd75449bdd60f8937b0) pwm: stm32: Fix driver to compile with STM32F0
- [18f24f08](https://github.com/zephyrproject-rtos/zephyr/commit/18f24f08f2ade358e883d8a961b02525611c6e88) pinmux: stm32f3: Add PA8_PWM1_CH1
- [653d75cf](https://github.com/zephyrproject-rtos/zephyr/commit/653d75cfbaae8ad331beaea12364202938cbb793) pwm: stm32: Add PWM fixup for STM32* and remove Kconfig options
- [e7252fbb](https://github.com/zephyrproject-rtos/zephyr/commit/e7252fbbfea9e70e5c92536ad16984379c96d32b) drivers: uart: Refactor nrf uart shim
- [3f99eefe](https://github.com/zephyrproject-rtos/zephyr/commit/3f99eefe5af74aad2214b2f1db851ad0973f9f49) drivers: uart: Rename nrf5 namings to nrfx
- [1f22a418](https://github.com/zephyrproject-rtos/zephyr/commit/1f22a418caaf3c7026b1792b1e14e097dbd6b804) gpio: doc: Be explicit about how EDGE and DOUBLE_EDGE work together
- [1002e904](https://github.com/zephyrproject-rtos/zephyr/commit/1002e904d54f561c9f3d0b5a8d68f3c616981877) drivers/exti: stm32: Use CMSIS IRQ defines instead of zephyr
- [d84795b0](https://github.com/zephyrproject-rtos/zephyr/commit/d84795b0c1985f68f0537a9e7e620bd70c8b91a8) drivers/dma: stm32: Use CMSIS IRQ defines instead of zephyr
- [f5310d5b](https://github.com/zephyrproject-rtos/zephyr/commit/f5310d5b5463f3a2f004dd809b46834f54296814) drivers: pwm: pwm_nrf5_sw: Fix calculation of cycles per second
- [fc1898cc](https://github.com/zephyrproject-rtos/zephyr/commit/fc1898ccb54588de64eabe56f5817aee22a2fa1b) drivers: pwm: pwm_nrf5_sw: Add prescaler support
- [2e6386f5](https://github.com/zephyrproject-rtos/zephyr/commit/2e6386f5afd9dc5915d071a9637b9dc0eaa9a3c8) drivers: ieee802154: Remove GPIO_MCUX_PORT{A,B}_NAME Kconfig references
- [02b5f3ed](https://github.com/zephyrproject-rtos/zephyr/commit/02b5f3edc8f6b08fe53fee91c4f2c0c4c55a1c51) drivers: gpio: Fix GPIO_QMSI_{0,1}_NAME Kconfig references
- [2a834995](https://github.com/zephyrproject-rtos/zephyr/commit/2a8349950ea2ab8b42c70c7abc7a7dbbfd03d6f9) drivers: sensors: Consistently quote "GPIO_0" string default
- [8df42eb4](https://github.com/zephyrproject-rtos/zephyr/commit/8df42eb4dc64776a0802ee7911d120ac65f77b15) drivers: Replace ff hex constants with 0xff
- [a55c72d3](https://github.com/zephyrproject-rtos/zephyr/commit/a55c72d35fef0805e8b798172cd49e915eb809d5) subsys: usb/class/hid: make interrupt endpoint size configurable
- [6c60abb0](https://github.com/zephyrproject-rtos/zephyr/commit/6c60abb03b7c120a2e28289ba502b98e79289605) drivers: gpio: add dts support for nrf52 gpio
- [2fe51996](https://github.com/zephyrproject-rtos/zephyr/commit/2fe51996db89c3e941134178b50c2c6982f9b5c7) drivers/flash: Remove irrelevant option in w25qxxdv driver
- [cf14a60f](https://github.com/zephyrproject-rtos/zephyr/commit/cf14a60f5a07d2c3a5fe336269aa8792a03d9653) include: usb: add descriptor and data section macros
- [0fca1644](https://github.com/zephyrproject-rtos/zephyr/commit/0fca16443a469962bc09d5e8a583b100a04028d6) subsys: usb: rework usb string descriptor fixup
- [589dbc4c](https://github.com/zephyrproject-rtos/zephyr/commit/589dbc4cd809eeb9aa5acc290c250260a8141477) subsys: usb: add function to find and fix USB descriptors
- [6807f3a8](https://github.com/zephyrproject-rtos/zephyr/commit/6807f3a826a7dbf119221af3e438ac1911a85897) subsys: usb: move descriptor parts to the class drivers
- [7c708604](https://github.com/zephyrproject-rtos/zephyr/commit/7c7086049efbad510aabe97281ccee8b32a8ae33) include: driver: usb: add check for endpoint capabilities
- [52eacf16](https://github.com/zephyrproject-rtos/zephyr/commit/52eacf16a24e4c335dae2c3aed2f427d61e49128) driver: usb: add check for endpoint capabilities
- [18b27b7f](https://github.com/zephyrproject-rtos/zephyr/commit/18b27b7f9d858125c99a1f7775a765710f57f501) subsys: usb: fetch endpoint address from usb_ep_cfg_data
- [bf332d00](https://github.com/zephyrproject-rtos/zephyr/commit/bf332d00047c31441ae6819f5cd8d0d0a157e2e4) subsys: usb: validate and update endpoint address
- [12375490](https://github.com/zephyrproject-rtos/zephyr/commit/1237549082bb9d6300214bef4fc28d96f8d3a21e) subsys: usb: configure Interface descriptor at runtime
- [1383dad8](https://github.com/zephyrproject-rtos/zephyr/commit/1383dad8a7cbc3d3c4c330a97b64e86bce4ffe35) subsys: usb: rework composite device support
- [32cac08e](https://github.com/zephyrproject-rtos/zephyr/commit/32cac08e5559cee317f178a8f7ab87c02c90a5b0) usb: class: adapt functions for new composite interface
- [391cf424](https://github.com/zephyrproject-rtos/zephyr/commit/391cf424a73f26dca0c11de3072bb25d127c635f) usb: tests: Add missing sections to sanitycheck
- [085a8b75](https://github.com/zephyrproject-rtos/zephyr/commit/085a8b75c571a19daaa8425e07edc0c32cfa9e27) usb: hid: fix write to interrupt IN endpoint
- [408ea146](https://github.com/zephyrproject-rtos/zephyr/commit/408ea1464b254972f00469cad4f23c078c2857d4) drivers: flash: nrf: Avoid locking when not threaded
- [49554dd3](https://github.com/zephyrproject-rtos/zephyr/commit/49554dd35a5a8dd79848584ca41b5e4d64cb6cb3) drivers: usb_dc_stm32: Change SYS_LOG_LEVEL
- [785faea8](https://github.com/zephyrproject-rtos/zephyr/commit/785faea8d411831cc6ba2cd045312517c8aa7fd4) drivers: timer: nRFx: Use nrf_rtc hal for registers w sideeffects
- [53220198](https://github.com/zephyrproject-rtos/zephyr/commit/532201980df90dfbf8d25188949b3979a7561200) drivers: clock_control: Use nrf_clock HAL for registers w sideeffects
- [78bf7518](https://github.com/zephyrproject-rtos/zephyr/commit/78bf7518a98fc050dd9ef1e2592fcb7168126aa6) drivers: entropy: nrf5: Use nrf_rng hal for registers w sideeffects
- [88de5bd8](https://github.com/zephyrproject-rtos/zephyr/commit/88de5bd84b4ce77071712ae0463f1a4c37006c93) drivers: serial: Remove SOC_NRF52810 Kconfig reference
- [392da5ba](https://github.com/zephyrproject-rtos/zephyr/commit/392da5baee6c5779214580c81b025af8766225fb) drivers: flash: w25qxxdv: Avoid locking when not threaded
- [fc4fc655](https://github.com/zephyrproject-rtos/zephyr/commit/fc4fc655d304e0c1b37bf8ed91013e6476a61ca0) drivers: serial: Revert change to init level for nrfx uart driver.
- [03f2eb7f](https://github.com/zephyrproject-rtos/zephyr/commit/03f2eb7f32c34039df33f7653947558e9be1b701) stm32_pwm: add pinmux port definition for pwm4
- [80b8c501](https://github.com/zephyrproject-rtos/zephyr/commit/80b8c501c987f725adc8061141c1e9d9863cb514) drivers/serial: stm32: simplify check of TEACK/REACK flags
- [13a96574](https://github.com/zephyrproject-rtos/zephyr/commit/13a96574cd03fc556f6d2eab563fb3c93fb35cc4) drivers/serial: stm32: Put LPUART code under LPUART Kconfig symbol
- [ebc31f62](https://github.com/zephyrproject-rtos/zephyr/commit/ebc31f623538fbcf90041a7da87fa36ebac197a9) drivers: can: Prepare STM32 driver for other series than STM32F0
- [c601f3be](https://github.com/zephyrproject-rtos/zephyr/commit/c601f3be6758ef9266972a4d458c023c4f5b7fd1) can: Add can support for STM32L432
- [7688f490](https://github.com/zephyrproject-rtos/zephyr/commit/7688f490652a58a4485d6eeb41aeeea15ba0fd77) drivers: usb_dc_stm32: change all endpoints to bidirectional

External (3):

- [4db7cce0](https://github.com/zephyrproject-rtos/zephyr/commit/4db7cce06e72751fb2186bca90dc6acc2a7c4e94) ext: lib: mgmt: Remove MDLOG Kconfig reference
- [354c8222](https://github.com/zephyrproject-rtos/zephyr/commit/354c8222f1ba70d8f209fe4239c34dbb438d8660) ext: hal: nordic: Update nrfx to version 1.1.0
- [fb6f9b78](https://github.com/zephyrproject-rtos/zephyr/commit/fb6f9b78c9094ca9ae7cc16aa43eb1988ba18440) ext: Kconfig: Remove redundant 'default n' properties

Kernel (5):

- [fd559355](https://github.com/zephyrproject-rtos/zephyr/commit/fd55935560f5c869e70534d852d47a50f3ef80cf) kernel: work_q: Document implications of default sys work_q priority
- [b173e435](https://github.com/zephyrproject-rtos/zephyr/commit/b173e4353fe55c42ee7f77277e13106021ba5678) kernel/queue: Fix spurious NULL exit condition when using timeouts
- [55a7e46b](https://github.com/zephyrproject-rtos/zephyr/commit/55a7e46b66bfcfe2c739ae57f01542bde922e314) kernel/poll: Remove POLLING thread state bit
- [2e405fbc](https://github.com/zephyrproject-rtos/zephyr/commit/2e405fbc6d049a5475518245b067294b4cb2a6e0) native_posix & kernel: Remove legacy preemption checking
- [3d14615f](https://github.com/zephyrproject-rtos/zephyr/commit/3d14615f56c8be48033e2b79b4b990da6783ddff) kernel: Restore CONFIG_MULTITHREADING=n behavior

Libraries (2):

- [99cef4c6](https://github.com/zephyrproject-rtos/zephyr/commit/99cef4c60ddc88283a6de4d4406012fb69c353f8) lib: Fix malformed JSON_LIBARY Kconfig default
- [6245d6c4](https://github.com/zephyrproject-rtos/zephyr/commit/6245d6c47b959f66ff05beee56624f9991909c29) libc: minimal: Add typedefs for "least" types

Miscellaneous (3):

- [0f9a6426](https://github.com/zephyrproject-rtos/zephyr/commit/0f9a642697f51ff4e22bf4be5163f428b27e868e) release: Post-release patch level update
- [5890004e](https://github.com/zephyrproject-rtos/zephyr/commit/5890004ea72066fb4b1e8100bb289fb5a00646a5) release: 1.12 doc cleanup
- [c16bce7a](https://github.com/zephyrproject-rtos/zephyr/commit/c16bce7a6a2a9b1960835ecdaa6c9a23a78a9159) samples, subsys, tests: Use ARRAY_SIZE() whenever possible

Networking (27):

- [c0109fd6](https://github.com/zephyrproject-rtos/zephyr/commit/c0109fd6904a607a88febbdd821fdddbca270f15) net/ethernet: There is no need to fill in the header in all frags
- [9e0cfaf0](https://github.com/zephyrproject-rtos/zephyr/commit/9e0cfaf0a7af7524e40cd0ca91c7084263a67d0e) net/arp: There is no need to fill in the header in all frags
- [06fbcb1c](https://github.com/zephyrproject-rtos/zephyr/commit/06fbcb1cd00ddaeedc7aaac8f5076b24aff95f87) net/arp: Removing header filling duplicate
- [97699537](https://github.com/zephyrproject-rtos/zephyr/commit/97699537f300ba46f9d36aae5bc1761de0644049) net/arp: Clear cache per-iface when relevant
- [a999d53a](https://github.com/zephyrproject-rtos/zephyr/commit/a999d53a338c911a85e1547e1b8b6f1404cfb961) net/icmpv6: Removing duplicate checksum calculation
- [d4e0a687](https://github.com/zephyrproject-rtos/zephyr/commit/d4e0a6872ee881d041feb498f215cf9643fb69dd) net/pkt: Simplify a tiny bit how TC priority is set
- [e1c11499](https://github.com/zephyrproject-rtos/zephyr/commit/e1c1149957f136107d292ad0cf33c5d4d4a7a06f) net/pkt: Use IS_ENABLED instead of ifdef
- [eb3ecf6e](https://github.com/zephyrproject-rtos/zephyr/commit/eb3ecf6e6604e32bf474daf9489b75f78f9a1812) net: shell: conn: Always show TCP state
- [3122112a](https://github.com/zephyrproject-rtos/zephyr/commit/3122112aa80392bc02318618eed32e0bad7e9134) net: ethernet: Provide stubs for ethernet carrier functions
- [b93d29df](https://github.com/zephyrproject-rtos/zephyr/commit/b93d29df564b8e0baa1c5933792baa979d99c724) net: ethernet: Add carrier detection to L2
- [fa882418](https://github.com/zephyrproject-rtos/zephyr/commit/fa8824184d503157a7fb3a5d4090775f82c68c8a) net: dhcpv4: Fix IPv4 and UDP checksum calculation
- [5cda31c8](https://github.com/zephyrproject-rtos/zephyr/commit/5cda31c8f1bdb1217eadf7f590c4e1a16dcd8d89) net: dhcpv4: Detect network interface on/off events
- [4dd61f88](https://github.com/zephyrproject-rtos/zephyr/commit/4dd61f8897922610d215dd8058ecaf892dda4201) net: tcp: Process zero window probes when our recv_wnd == 0
- [3cf1b07d](https://github.com/zephyrproject-rtos/zephyr/commit/3cf1b07d5a6439b76a357a343d1e91c134488f7f) net: stats: do not use deallocated packet pointer
- [30c4aae9](https://github.com/zephyrproject-rtos/zephyr/commit/30c4aae9481aa33283dc97491cf2b9b7a69a6427) net: samples: increase main stack size for echo_client
- [d4943989](https://github.com/zephyrproject-rtos/zephyr/commit/d4943989406f1bacc07b0afcf32a470267f6d401) net: stats: handle_na_input: unref packet after stats are updated
- [ce6f9819](https://github.com/zephyrproject-rtos/zephyr/commit/ce6f9819e076f14eba54015efcb80f7ab77d03b3) net: Remove redundant NETWORKING dependency
- [1a96f2b4](https://github.com/zephyrproject-rtos/zephyr/commit/1a96f2b48fbdbec54edff3f306f034f73160cdf0) net: ethernet: Show interface for dropped RX packet
- [4ae875f9](https://github.com/zephyrproject-rtos/zephyr/commit/4ae875f9c18456245b33ce3ee78dc62b37cd82eb) net: arp: Timeout too long ARP request
- [699023a9](https://github.com/zephyrproject-rtos/zephyr/commit/699023a9871f2981341ef3ce17b6b82949d532b0) net: ethernet: Fix asserts in net_eth_fill_header()
- [e62972bb](https://github.com/zephyrproject-rtos/zephyr/commit/e62972bb8e4b3c3f0f98fe4cce9da0564d77060d) net: ethernet: net_eth_fill_header: Remove superfluous "frag" param
- [268c0e33](https://github.com/zephyrproject-rtos/zephyr/commit/268c0e33105f263255a56f8bd1dde8eaad3005cb) net: tcp: Add MSS option on sending SYN request
- [f8dc4b6b](https://github.com/zephyrproject-rtos/zephyr/commit/f8dc4b6b50049bc027dc7a4bb852675e463b6c71) net: bluetooth: Enforce the minimum user_data size at Kconfig
- [c0e0d613](https://github.com/zephyrproject-rtos/zephyr/commit/c0e0d6131d1e25a30d9c30ccfdda2bf5a3e71f7d) net: rpl: Fix malformed Kconfig default
- [3bc77e88](https://github.com/zephyrproject-rtos/zephyr/commit/3bc77e88fb80bf914fe42622d8b00e2b5f2ba916) net: drivers: wifi: SimpleLink WiFi Offload Driver (wifi_mgmt only)
- [7934e249](https://github.com/zephyrproject-rtos/zephyr/commit/7934e249830afbb7e4e18202f9b6b3600d03caeb) net: lwm2m: retry registration update 6 seconds before expiration
- [1da4ddba](https://github.com/zephyrproject-rtos/zephyr/commit/1da4ddba8676869142b7a47d15f50c41c1c1cfe4) net: pkt: Fix comment typo in word tailroom

Samples (12):

- [57f67903](https://github.com/zephyrproject-rtos/zephyr/commit/57f6790335da6f6fbe9ee4803367d0869f550c43) samples: can: move CAN sample under drivers
- [3f8352f2](https://github.com/zephyrproject-rtos/zephyr/commit/3f8352f2e6d3c70ac4ee2f61dcf324e6affdd01a) samples: remove sample.tc
- [f37287bb](https://github.com/zephyrproject-rtos/zephyr/commit/f37287bbcabcd0f2cf558112df5ee180abbf6d4a) samples: cleanup sample test naming
- [10d8e711](https://github.com/zephyrproject-rtos/zephyr/commit/10d8e711be311a0977654300539caf19cd94110d) samples: move grove samples to sensors and display
- [59309c1a](https://github.com/zephyrproject-rtos/zephyr/commit/59309c1a2d13f5fc47d28382321505de8caf106c) samples: sockets: dumb_http_server: Use consistent logging settings
- [fb4227bd](https://github.com/zephyrproject-rtos/zephyr/commit/fb4227bd97e8ce5cf26bd2554051b9199a2dd084) samples: mbedtls_sslclient: Use entropy driver to kickstart RNG
- [416614e2](https://github.com/zephyrproject-rtos/zephyr/commit/416614e26a18f3b6057bc1fdc8a576aa82488e51) samples: net: echo-client: Increase buf count for frdm-k64f
- [7a073bf9](https://github.com/zephyrproject-rtos/zephyr/commit/7a073bf9f5de5486e951a16607ed492e5f029ef3) samples: bluetooth: Fix microbit/nrf5 UART flow control assignments
- [e5b5f85c](https://github.com/zephyrproject-rtos/zephyr/commit/e5b5f85c1a276f9ac44152cb83f59b3179ad6bba) samples: servo_motor: Add support for the BBC micro:bit
- [1bbfdf1d](https://github.com/zephyrproject-rtos/zephyr/commit/1bbfdf1d1ada373cdd5847272f2726d083468f01) samples: mesh/onoff-app: Enable persistent storage support
- [98465702](https://github.com/zephyrproject-rtos/zephyr/commit/984657022f3b2c29560e623def4b3aa9336cbb2a) samples: net: wifi: Add a cc3220sf_launchxl conf file
- [af70e8f7](https://github.com/zephyrproject-rtos/zephyr/commit/af70e8f7f0e18089229099a5af5aef9519198f28) samples: net: Check the return value of close()

Scripts (11):

- [cb95ea0b](https://github.com/zephyrproject-rtos/zephyr/commit/cb95ea0b5381478dacfce3fe81052ad84cb1ff63) kconfiglib: Update to add list of choices
- [31ab6bff](https://github.com/zephyrproject-rtos/zephyr/commit/31ab6bffb2120259a85fdf27921ebf15a605bf78) genrest: Generate documentation and links for choices
- [20721f39](https://github.com/zephyrproject-rtos/zephyr/commit/20721f39fa367ee46a1e346fb696d9158b5e0725) scripts: kconfig: Improve the 'user value != actual value' warning
- [ad29ec69](https://github.com/zephyrproject-rtos/zephyr/commit/ad29ec69dd935bc24249338bf83d457e28d4cdf9) scripts: extract: globals.py: fix node name when it includes "@"
- [f971aaca](https://github.com/zephyrproject-rtos/zephyr/commit/f971aacaf38f63b52d991fcf3d8b91316f6baf8d) scripts: kconfig: Turn most warnings into errors
- [7f84001f](https://github.com/zephyrproject-rtos/zephyr/commit/7f84001fd3c8999e44c1ca40e0a8498713ffbcfb) menuconfig: Fix searching for nonexistent objects
- [f425c0aa](https://github.com/zephyrproject-rtos/zephyr/commit/f425c0aa271c111932704425eb558a946e250519) scripts: kconfig: Disable the "FOO set more than once" warning
- [59c8ae8c](https://github.com/zephyrproject-rtos/zephyr/commit/59c8ae8caf04f1fa29ea3b9170228b21e0a14110) kconfiglib: Fix incorrectly ordered props. for some multi.def symbols
- [ea108107](https://github.com/zephyrproject-rtos/zephyr/commit/ea108107e6ce94cc38a4ae4ae5e2be612bc50780) scripts: kconfig: Extend the assignment-failed warning
- [80f19cca](https://github.com/zephyrproject-rtos/zephyr/commit/80f19cca4230145b7094c613c6c5212c06effbbb) kconfiglib: Correctly report choice locations in some warnings
- [4dcde2e6](https://github.com/zephyrproject-rtos/zephyr/commit/4dcde2e628a7a531432b30e87aa14f076a6a8d07) menuconfig: Allow searches from the info dialog and vice versa

Storage (1):

- [72959543](https://github.com/zephyrproject-rtos/zephyr/commit/72959543991917ea09d47cdb5c0b941e8947c6fc) settings: fix typo in header file

Testing (8):

- [9b2880fe](https://github.com/zephyrproject-rtos/zephyr/commit/9b2880fe6e38874eca903898066dd875a0632b37) tests: posix: fix meta-data and rename test file
- [252be0b9](https://github.com/zephyrproject-rtos/zephyr/commit/252be0b909d7323d7886495aa6ca5b04ebd749f3) tests/kernel/sched/preempt: enable test for native_posix
- [e8a906c2](https://github.com/zephyrproject-rtos/zephyr/commit/e8a906c29c5cce770cd39f5c21210f0b9b0828d7) tests: disable preempt testcase for native_posix
- [4a2d109a](https://github.com/zephyrproject-rtos/zephyr/commit/4a2d109a4b0fd63eb613e25bab2a8a8e90b553ef) native tests: fix kernel sched preempt for arch posix
- [791daa70](https://github.com/zephyrproject-rtos/zephyr/commit/791daa7037d693256225c9dc5c761e85da222872) tests: sprintf: remove kconfig options
- [072a43d1](https://github.com/zephyrproject-rtos/zephyr/commit/072a43d1a4f60962b28ec1eff1f577059694c3eb) tests: Do not build arm_irq_vector_table .config's for ARC
- [7bbd3a79](https://github.com/zephyrproject-rtos/zephyr/commit/7bbd3a79ae04f75d084a29afedf5cd921bc4746b) tests/kernel: Add a test for CONFIG_MULTITHREADING=n
- [a3fe7af2](https://github.com/zephyrproject-rtos/zephyr/commit/a3fe7af2dda5f1a181aed86643a895eaf88ae61a) tests: obj_tracing: Enhance object counter logic

