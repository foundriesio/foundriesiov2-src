+++
title = "Zephyr News, 18 April 2018"
date = "2018-04-18"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 18 April 2018 newsletter tracking the latest
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
commits:

- [9bde3c06e](https://github.com/zephyrproject-rtos/zephyr/commit/9bde3c06e1a679985ab8779248ce76c445531426)
  ("tests: build_all: Add LPS22HB and LSM6DSL sensors build test"),
  Apr 10 2018
- [4c400e876](https://github.com/zephyrproject-rtos/zephyr/commit/4c400e87628f17a111d41625b5d241f5dea92fa2) ("net: ipv6: Fix crash from malformed fragment payload"),
  Apr 17 2018

Important Changes
-----------------

**Userspace calling convention change:**

System calls from userspace on ARM targets now expect all
arguments to be passed via registers, instead of mixing stack and
registers as done previously.

**DTS alias renames:**

Various DTS aliases with underscores ('_') in their names were
renamed to use dash ('-') instead. Apparently, underscores were
technically always illegal to use in alias names. This change
avoids a dtc warning in newer versions. In-tree users were
updated; any out of tree applications using the old names will
need changes as well.

**WiFi:**

The initial outline for Zephyr's WiFi suport was
merged. Initial definitions were added in the following
areas:

- device driver skeleton in drivers/wifi
- an mostly stubbed out main header file,
  include/net/wifi.h
- WiFi network management in include/net/wifi_mgmt.h,
  including definitions for events from so-called "offloaded"
  devices (which are separate cores that implement WiFi
  funcionality and communicate with the IC running Zephyr
  via a higher-level protocol)
- shell support for controlling the network management API in
  subsys/net/ip/l2/wifi_shell.c, which can be selected with
  CONFIG_NET_L2_WIFI_SHELL. The initial commands are "wifi
  connect", "wifi disconnect", and "wifi scan".

This is the groundwork for future changes completing the
generic framework and adding individual device drivers.

**Device tree bindings for GPIO keys and LEDs:**

Generic device tree bindings for GPIO-based buttons ("keys") and
LEDs were added in dts/bindings/gpio/gpio-keys.yaml and
dts/bindings/gpio/gpio-leds.yaml respectively.

The initial users are STM32-based boards, which now have device
tree nodes for their buttons and onboard LEDs defined.

Features
--------

**Architectures:**

ARM cores now flush the instruction pipeline after switching
privilege levels, to prevent execution of pre-fetched
instructions with the previous privilege.

**Boards:**

SoC support was added for the Cortex M4 core which is present in
the imx7d SoC. The Zephyr image must be loaded and run by an A7
core also present on the SoC. Initial board support was added for
the Colibri iMX7D as "colibri_imx7d_m4".

Sanitycheck now runs on hifive1.

96b_carbon_nrf51 now uses the new nRF SPIS driver.

Userspace mode was enabled by default for sam_e70_xplained.

**Device tree:**

Device tree bindings for STM32 GPIOs were defined, and all
STM32-based boards now have GPIO device nodes.

**Drivers:**

The native POSIX Ethernet driver now supports network statistics
collection, extending support for the Ethernet interface network
statistics framework that was recently merged.

The driver for the KW41Z BLE and 802.15.4 chip now supports the
OpenThread L2 layer, and received changes to its RNG source which
now feed its (slow and blocking) entropy source's output into the
Xoroshiro PRNG.

The nRF SPI drivers now appear to be completely supported. There
are three available drivers: spi_nrfx_spi.c is a master-only
driver for older devices (or devices with anomalies) without
direct memory access (DMA) support, spi_nrfx_spim.c is a master
driver for devices with DMA support, and spi_nrfx_spis.c is a
driver for the experimental SPI slave API which uses DMA.

Bug Fixes
---------

The k_malloc() and k_calloc() calls in the mempool implementation
now properly check for overflow in all configurations.

A pair of patches fixing IPv6 crashes were merged.

Following reports of confusion, the Windows installation guide
has been restructured to make it easier for new users to
understand what their choices are.

A few sample applications (BT's hci_usb, as well as USB's dfu and
wpanusb) now use the Kconfig knobs CONFIG_USB_DEVICE_VID and
CONFIG_USB_DEVICE_PID to configure the USB vendor and product
IDs. These knobs say they "MUST be configured by vendor"
(e.g. http://docs.zephyrproject.org/reference/kconfig/CONFIG_USB_DEVICE_VID.html);
they default to 0x2FE3 and 0x100 respectively. The VID 0x2FE3
doesn't appear to be allocated by the USB-IF.

The wpanusb sample and ENC28J60 Ethernet driver received fix-ups,
and, in the ENC28J60 case, optimizations.

The number of interrupts on the nRF52840 SoC was fixed.

PWM was disabled on nucleo_f103rb, fixing some test build breaks
and continuing Zephyr's move towards a consistent set of default
board configurations.

CONFIG_CUSTOM_LINKER_SCRIPT, which allows the user to override
the linker scripts provided by Zephyr itself, was fixed. This had
been broken since the transition to CMake, so it seems to have
few, if any, active users.

The Atmel SAM0 flash driver's build is fixed when
CONFIG_FLASH_PAGE_LAYOUT is disabled.

A concurrency fix to the SPI driver core was merged.

Individual Changes
==================

Patches by area (105 patches total):

- Arches: 5
- Bluetooth: 1
- Boards: 8
- Build: 1
- Continuous Integration: 1
- Device Tree: 11
- Documentation: 10
- Drivers: 22
- External: 2
- Kernel: 3
- Libraries: 1
- Maintainers: 2
- Miscellaneous: 2
- Networking: 22
- Samples: 6
- Scripts: 1
- Storage: 1
- Testing: 6

Arches (5):

- [81633023](https://github.com/zephyrproject-rtos/zephyr/commit/816330239ef20da022905ae135a16b53e81d4f3f) arch: Add imx7d m4 soc support
- [397e52f0](https://github.com/zephyrproject-rtos/zephyr/commit/397e52f099e9cd4f979ea63950031867fee320c3) arch: nrf52: Correct the number of IRQs in nRF52840
- [1aa123d0](https://github.com/zephyrproject-rtos/zephyr/commit/1aa123d05d64b3bb544b327e9381e338e2ab1f52) arm: nucleo_f103rb: Do not enable PWM by default
- [4d5fbbc5](https://github.com/zephyrproject-rtos/zephyr/commit/4d5fbbc517c470d778d708f17deaedbe86e92b76) arch: arm: Flush pipeline after switching privilege levels
- [09a8810b](https://github.com/zephyrproject-rtos/zephyr/commit/09a8810b339b8266f835ea29f863a9cb825e486a) arm: userspace: Rework system call arguments

Bluetooth (1):

- [b6d912ab](https://github.com/zephyrproject-rtos/zephyr/commit/b6d912abf669c22a19eea37ea0ec97fc754d4f09) Bluetooth: hci_usb: Use USB Device defined VID / PID

Boards (8):

- [85e8eaa9](https://github.com/zephyrproject-rtos/zephyr/commit/85e8eaa9a65145c9011e0b55a670760f35e12ea8) boards/arm: add support for colibri_imx7d_m4 board
- [a9d7b1ff](https://github.com/zephyrproject-rtos/zephyr/commit/a9d7b1ff25585ac269bc7ecbbc031d401d004aad) boards: hifive1: Add missing board yaml file
- [5319e009](https://github.com/zephyrproject-rtos/zephyr/commit/5319e0099fda51905b29444580e4f63606c4acf7) boards: arduino_due, nrf52_pca20020: Add "ram" and "flash" properties
- [c542c0e3](https://github.com/zephyrproject-rtos/zephyr/commit/c542c0e33e93b4c082882c54904848b4a1cbd16b) boards: dts: Cleanup aliases
- [9c032eb1](https://github.com/zephyrproject-rtos/zephyr/commit/9c032eb14dc7445001bf4ed42f225ace4d4c7e40) boards/arduino101: Enable UART 0 controller
- [1d27d27a](https://github.com/zephyrproject-rtos/zephyr/commit/1d27d27a065870b346e0bace553dba18f2eb7848) boards: 96_carbon_nrf51: Update SPI driver default configuration
- [7c6cf201](https://github.com/zephyrproject-rtos/zephyr/commit/7c6cf201e0133e9727235414c3e638a3c7098d83) boards: stm32: add button and leds gpio definitions
- [95126d1a](https://github.com/zephyrproject-rtos/zephyr/commit/95126d1af67ee34e2a3c58843e5b83f8454a6e23) boards: sam_e70_xplained: Enable userspace

Build (1):

- [c1aa9d16](https://github.com/zephyrproject-rtos/zephyr/commit/c1aa9d16e97055281378d0b346a3b38c46bfc58f) cmake: Fix CONFIG_CUSTOM_LINKER_SCRIPT

Continuous Integration (1):

- [c84235ee](https://github.com/zephyrproject-rtos/zephyr/commit/c84235eee32317e3a3092ab7f59e4b90020daa2c) sanitycheck: Exit on load errors

Device Tree (11):

- [708b59b9](https://github.com/zephyrproject-rtos/zephyr/commit/708b59b9aa4b9906f97a86ede431c9726453370d) dts: stm32: stm32f469 is a stm32f429 derivative
- [e7ab1d30](https://github.com/zephyrproject-rtos/zephyr/commit/e7ab1d306b13155b6f856e5c4034108c083a6c31) dts: stm32: Populate gpio nodes for stm32f4 series
- [8e5cf5fe](https://github.com/zephyrproject-rtos/zephyr/commit/8e5cf5fe8f80667abb25b70f35e878395bba86e9) dts: stm32: Populate gpio nodes for stm32f0 series
- [dbc3c024](https://github.com/zephyrproject-rtos/zephyr/commit/dbc3c0245288f269cbc128040d77e2ec8607793a) dts: stm32: Populate gpio nodes for stm32f1 series
- [a4c426ab](https://github.com/zephyrproject-rtos/zephyr/commit/a4c426abcbe8d0d67731b0a46b08c142b3282525) dts: stm32: Populate gpio nodes for stm32f3 series
- [a78adcdd](https://github.com/zephyrproject-rtos/zephyr/commit/a78adcdd9139f2c560762621bf570824cc6d657a) dts: stm32: Populate gpio nodes for stm32l4 series
- [50bf306f](https://github.com/zephyrproject-rtos/zephyr/commit/50bf306f4f8f03d2d57cae86130c40b1db381da1) dts: stm32: Populate gpio nodes for stm32l0 series
- [93318f9f](https://github.com/zephyrproject-rtos/zephyr/commit/93318f9f00ef2e6e1983a093630da9b167397e59) yaml: rename cell_string clocks
- [6c92e556](https://github.com/zephyrproject-rtos/zephyr/commit/6c92e556355c49442afc1f935ed0064ff12a6866) dts: bindings: add bindings for stm32 gpio
- [2b4cb5a7](https://github.com/zephyrproject-rtos/zephyr/commit/2b4cb5a7ad41183adff7a8e83663fdd334af38b1) dts: provide yaml bindings for led and gpio keys
- [4fe3a977](https://github.com/zephyrproject-rtos/zephyr/commit/4fe3a9776f72ff6c5757d9ff8ded12f23f9a8a51) dts: gpio: create gpio dt-bingings and inlude in stm32 dtsi files

Documentation (10):

- [a02e78d3](https://github.com/zephyrproject-rtos/zephyr/commit/a02e78d3fddedc57a1833327cf2a1e1da0573ac6) doc: fix note for forcing a CI recheck
- [f6a25cfd](https://github.com/zephyrproject-rtos/zephyr/commit/f6a25cfd0e47398a0cfff5e9316b0b0bd46b0521) docs: network-management-api: update a changed function name
- [70a5bded](https://github.com/zephyrproject-rtos/zephyr/commit/70a5bdedd8d2a331a609c5dbc04eb094af768115) doc: network-management-api: clarify intended event listening usage
- [5e9563ab](https://github.com/zephyrproject-rtos/zephyr/commit/5e9563ab8b77bf60115b8f332a03e397bfc7ba2a) doc: usb: Move USB sections to USB Stack
- [556e5329](https://github.com/zephyrproject-rtos/zephyr/commit/556e5329a657844b36a59db8b909675ce28313fd) doc: Make code consistent lowering case
- [a660fcb3](https://github.com/zephyrproject-rtos/zephyr/commit/a660fcb315177b5473cb5bb9f0a3854736b3efc1) doc: Add USB documentation identifiers and links
- [88b66b58](https://github.com/zephyrproject-rtos/zephyr/commit/88b66b58b1d3cc828ac83dfebba34cc3307dbf49) doc: getting_started: Make it more obvious how to follow the guide
- [05f02bd0](https://github.com/zephyrproject-rtos/zephyr/commit/05f02bd038a4f19c8a1b3c47b09936e2cbac16d8) docs: group the GPIO_* flags into logical groups.
- [5e9f7cb2](https://github.com/zephyrproject-rtos/zephyr/commit/5e9f7cb27ac7e7dd0681d7511f4590951bb13a5d) doc: fix misspellings in Kconfig files
- [50468605](https://github.com/zephyrproject-rtos/zephyr/commit/504686053ec33b0ff3fee10e41ba60905821b6fc) doc: Fix path in documentation about uncrustify.cfg

Drivers (22):

- [346165b2](https://github.com/zephyrproject-rtos/zephyr/commit/346165b2e8e4662224106778b12e340d4a30fc3c) serial: Add imx uart driver shim
- [05893ec5](https://github.com/zephyrproject-rtos/zephyr/commit/05893ec51cd0848c577f097410748d127d285b6b) wpanusb: Assign USB Product ID to 802.15.4 over USB
- [c925bf51](https://github.com/zephyrproject-rtos/zephyr/commit/c925bf5175f1f541d66f0506f636946c142d6f78) wpanusb: Remove unneeded configuration option
- [32e089d2](https://github.com/zephyrproject-rtos/zephyr/commit/32e089d2f0a8fad0582dc9ab3ef2139542251ca4) wpanusb: Remove old hardcoded VID / PID
- [a68a177c](https://github.com/zephyrproject-rtos/zephyr/commit/a68a177cc72e439e33b7d1c703b63153cd75cc96) wpanusb: Use DEBUG syslog level
- [e295836b](https://github.com/zephyrproject-rtos/zephyr/commit/e295836b3afd20630f22e0c65ea4929ff2c505e1) usb: dfu: Use USB Device defined VID / PID
- [42902e58](https://github.com/zephyrproject-rtos/zephyr/commit/42902e580bea940c439bec366254192988d2de62) drivers/ethernet: Fix and clean a bit ENC28J60 driver
- [669d4a8c](https://github.com/zephyrproject-rtos/zephyr/commit/669d4a8ccb34e110890bc50af83874337aaf874b) drivers/ethernet: Optimize memory read/write operations in ENC28J60
- [e8bc0632](https://github.com/zephyrproject-rtos/zephyr/commit/e8bc063215d9310519ffdc77660cca27eca9a316) drivers/ethernet: Reduce runtime context size in ENC28J60 driver
- [3e048f6d](https://github.com/zephyrproject-rtos/zephyr/commit/3e048f6d3e6f3935e0d4cb8b96c7a32b91024499) drivers: eth: native_posix: Add ethernet statistics support
- [7738a501](https://github.com/zephyrproject-rtos/zephyr/commit/7738a501d9100ebb6b53b98d1c3410cb07b9b37d) drivers: ieee802154: Add auto-ack support to KW41Z driver
- [9f7470e2](https://github.com/zephyrproject-rtos/zephyr/commit/9f7470e240cb641d06d60ba6426f049605e47415) drivers: ieee802154: Add OpenThread modifications to KW41Z driver
- [c563e331](https://github.com/zephyrproject-rtos/zephyr/commit/c563e331024626cf7d13393b175388a64e6697f7) drivers: entropy: Change KW41Z to use XOROSHIRO for RNG source
- [8b839b4e](https://github.com/zephyrproject-rtos/zephyr/commit/8b839b4e0c5a6d30bb1fbc945273403934d4b758) drivers/wifi: Add files skeleton for adding WiFi drivers
- [998c79d0](https://github.com/zephyrproject-rtos/zephyr/commit/998c79d09be7425930b9893d90a8eda7f285c0c2) drivers: spi: Add shim for nrfx SPIM driver
- [7a9c4cbd](https://github.com/zephyrproject-rtos/zephyr/commit/7a9c4cbd9d56144235dde08b9ca1e84dde963e62) drivers: spi: Align nrfx_spi shim with the nrfx_spim one
- [8c5b16cc](https://github.com/zephyrproject-rtos/zephyr/commit/8c5b16cc793956dcaffdcc5686c5f5d8df318941) drivers: flash: atmel sam0: Fix compilation without page layout support
- [5976afe9](https://github.com/zephyrproject-rtos/zephyr/commit/5976afe91f81c572cba9ea07aee590d742688111) drivers: spi: Correct a typo in spi_nrfx_spi.c
- [1143606c](https://github.com/zephyrproject-rtos/zephyr/commit/1143606ce97d3d1f3640ab36d5963e92f0a8c4b5) drivers/spi: Fix context lock behavior
- [ffb2bcbb](https://github.com/zephyrproject-rtos/zephyr/commit/ffb2bcbb4d885c836e3e32655716ea13f7204b66) drivers/spi: Slave async calls require recv frames as successful status
- [ecd08111](https://github.com/zephyrproject-rtos/zephyr/commit/ecd081115adde72a85ce427c437ea39cccff16cc) drivers: spi: Add shim for nrfx SPIS driver
- [5991cea1](https://github.com/zephyrproject-rtos/zephyr/commit/5991cea137f6b0957431f56dfa372883cbef6d52) drivers: spi: Add missing periods in Kconfig.nrfx

External (2):

- [3afc2b6c](https://github.com/zephyrproject-rtos/zephyr/commit/3afc2b6c61a4aa0fb15428fb9f771efe18fb8ee6) ext/hal/nxp/imx: Import the nxp imx7 freertos bsp
- [ea1d14e5](https://github.com/zephyrproject-rtos/zephyr/commit/ea1d14e529da9fde43845b75407d4620e6ab65fc) hal: nordic: Move nrfx IRQ related stuff from SPI shim to nrfx_glue

Kernel (3):

- [79d151f8](https://github.com/zephyrproject-rtos/zephyr/commit/79d151f81d88b0b0b6084eb209852704c7399a57) kernel: Fix building of k_thread_create
- [b902da35](https://github.com/zephyrproject-rtos/zephyr/commit/b902da35994be91f1147ee0b39105e09a7b290c3) kernel: mempool: Check for overflow in k_malloc()
- [85dcc97d](https://github.com/zephyrproject-rtos/zephyr/commit/85dcc97db9a13c501f16b9e3e5b0661d42181f3b) kernel: mempool: Always check for overflow in k_calloc()

Libraries (1):

- [51a20907](https://github.com/zephyrproject-rtos/zephyr/commit/51a209078021bb9f414b370a1679ec2319060fd4) newlib: Fix compiler warning when using Newlib

Maintainers (2):

- [f8248d4f](https://github.com/zephyrproject-rtos/zephyr/commit/f8248d4fe76199c09fb9dc9c75143a167723b105) CODEOWNERS: Add @pfalcon as a maintainer of BSD Sockets subsystem
- [a534aa6a](https://github.com/zephyrproject-rtos/zephyr/commit/a534aa6a6ea3750d3d1fad390c04d93b4d16f362) CODEOWNERS: update owners

Miscellaneous (2):

- [c7f5cc9b](https://github.com/zephyrproject-rtos/zephyr/commit/c7f5cc9bcbe1d9f9f9a6226a4e023ff157269e96) license: fix spdx identifier in a few files
- [be6bf293](https://github.com/zephyrproject-rtos/zephyr/commit/be6bf29363e19aa5da1982c28e6509a954c5086a) syslog: net: Fix multiple network interface selection for IPv4

Networking (22):

- [61cd96ee](https://github.com/zephyrproject-rtos/zephyr/commit/61cd96ee45cfe9c167338e29f7474ab6a0792f76) net: l2: ethernet: fix kconfig
- [1146ba1f](https://github.com/zephyrproject-rtos/zephyr/commit/1146ba1f91aa9f7d112b25cd2cdf6ac353ec4b6d) net: app: server: Create IPv4 listener also if IPv6 is enabled
- [c1e7fd76](https://github.com/zephyrproject-rtos/zephyr/commit/c1e7fd76ef0fb351f720bf7793eea387342a6da6) net: stats: Add infrastructure for collecting ethernet stats
- [c90b9f53](https://github.com/zephyrproject-rtos/zephyr/commit/c90b9f53cdfeb87e093aaced3bb015850cdbffe2) net: shell: Print ethernet statistics
- [03b24082](https://github.com/zephyrproject-rtos/zephyr/commit/03b24082ee25d197bd976236c1e7270d0cd67299) subsys: net: ip: l2: openthread: Fixed compiler errors and warnings
- [00885bbf](https://github.com/zephyrproject-rtos/zephyr/commit/00885bbf2809fac0ff32cdea9ef6ae0d5b305441) OpenThread: Normalize IEEE802.15.4 driver name for use by L2 layers
- [292033c1](https://github.com/zephyrproject-rtos/zephyr/commit/292033c1d0280898b93920230e12e9d124d0de98) openthread: kw41z: Adding echo/server project config files for KW41Z OT
- [6f57c03a](https://github.com/zephyrproject-rtos/zephyr/commit/6f57c03aee55fd0fe5994a48f6bf6d5893f1c4fa) net: app: Always set relevant sa_family when starting a TCP server
- [ac661a07](https://github.com/zephyrproject-rtos/zephyr/commit/ac661a077947b941e3ae94a03172c3d2643ecf41) net: tcp: Cancel fin_timer in FIN_WAIT_2 instead FIN_WAIT_1
- [6d387ec9](https://github.com/zephyrproject-rtos/zephyr/commit/6d387ec98f06365be9ae9f55f4c214bd74130db0) net: Remove the need for an l2 on offloaded drivers
- [c7d5e872](https://github.com/zephyrproject-rtos/zephyr/commit/c7d5e872dca110cdc70ee5323b9e2ea30b69dc71) net: Don't call l2->enable for offload devices
- [93ac7ce6](https://github.com/zephyrproject-rtos/zephyr/commit/93ac7ce655d97deede07b7ebfd8199d7e3b2928b) net/mgmt: Move NET_EVENT_INFO_MAX_SIZE into net core's private header
- [7bde51d8](https://github.com/zephyrproject-rtos/zephyr/commit/7bde51d86a5572f13a56c75a840be355fb58ec33) net/mgmt: Add initial WiFi management API definitions
- [dc81659b](https://github.com/zephyrproject-rtos/zephyr/commit/dc81659bc506578b9233a91c29a9c7ced02405cc) net/wifi: Select dependencies to get wifi mgmt working
- [17b923ae](https://github.com/zephyrproject-rtos/zephyr/commit/17b923ae3cfe432dfff7b689bcfee495532d5174) net: wifi: Add a wifi.h to hold WiFi definitions
- [eab3f168](https://github.com/zephyrproject-rtos/zephyr/commit/eab3f168fd978c5d7fdf75b05921bd53ba9d128e) net/mgmt/wifi: Add dedicated net mgmt hooks for WiFi offload devices
- [c995bfe7](https://github.com/zephyrproject-rtos/zephyr/commit/c995bfe7e6a9d9b11fdc932031d2fb870b6f85a2) net/wifi: Add a shell module for controlling WiFi devices
- [da8af393](https://github.com/zephyrproject-rtos/zephyr/commit/da8af393024985583e6d0ef974a766b55156a8f7) net: if: Add helper to select src interface for a IPv4 dst addr
- [2bb179b7](https://github.com/zephyrproject-rtos/zephyr/commit/2bb179b7e1d347699556b91fde407d9b30f61ab9) net: shell: Use correct network interface for IPv4 ping
- [a91c46ff](https://github.com/zephyrproject-rtos/zephyr/commit/a91c46ffdefaa2f66a847f0db029a6cc3e0eb17f) net: app: Select local IP address properly if multiple interfaces
- [2563c373](https://github.com/zephyrproject-rtos/zephyr/commit/2563c373c3cddcf0c3c457f424d9eaf6fe790e10) net: ipv6: Fix crash from NULL fragment pointer access
- [4c400e87](https://github.com/zephyrproject-rtos/zephyr/commit/4c400e87628f17a111d41625b5d241f5dea92fa2) net: ipv6: Fix crash from malformed fragment payload

Samples (6):

- [f9159ab6](https://github.com/zephyrproject-rtos/zephyr/commit/f9159ab6bd0aa55a0ee16012ef99d7a81563fa10) samples/telnet: Fix accessing iface ipv4 config
- [435d1738](https://github.com/zephyrproject-rtos/zephyr/commit/435d173870133c91581d480963be2eb1351b537e) samples: net: stats: Print ethernet statistics
- [cd6a3f04](https://github.com/zephyrproject-rtos/zephyr/commit/cd6a3f0457c4e6937489f4d66d9922af51a56179) samples: coap_client: fix net mgmt event handler
- [023ae27d](https://github.com/zephyrproject-rtos/zephyr/commit/023ae27d251c9856e733a4c4fca5b066162bcdd4) samples: telnet: fix net mgmt event handler
- [79c4a5b4](https://github.com/zephyrproject-rtos/zephyr/commit/79c4a5b4bf0fa792b57d4bc31b462d9f8362d1df) samples: net: coap_client: Fix compile error
- [3aa3e976](https://github.com/zephyrproject-rtos/zephyr/commit/3aa3e9767536ea80736bac24db73342914e24263) samples: net: coap: Solved the payload issue in coap GET Method

Scripts (1):

- [3b529ca3](https://github.com/zephyrproject-rtos/zephyr/commit/3b529ca3ee6ca49a6edd1ba60a7a9673a727c8a9) scripts: extract_dts_inlcudes: generate cells for gpio

Storage (1):

- [50893349](https://github.com/zephyrproject-rtos/zephyr/commit/50893349fe08bb316a84f496ee881ca900912184) subsys: nffs: Unlock mutex before returning

Testing (6):

- [0d83900d](https://github.com/zephyrproject-rtos/zephyr/commit/0d83900ddf3682cea620adaf4bb774876fc624eb) tests: net: mld: fix net mgmt event handler
- [3718684e](https://github.com/zephyrproject-rtos/zephyr/commit/3718684e06243834b3ba18b4b694a4c90ba16fe7) tests: net: dhcpv4: fix net mgmt event handler
- [3c8b3875](https://github.com/zephyrproject-rtos/zephyr/commit/3c8b3875c6167f79101bfb55283395252dc56bde) tests: kernel: threads: Additional tests for set_priority
- [1f45f79d](https://github.com/zephyrproject-rtos/zephyr/commit/1f45f79d618279dd5a0d53f04cf015c5cf1ad40c) tests: mempool: Add overflow checks
- [f2177bfb](https://github.com/zephyrproject-rtos/zephyr/commit/f2177bfb8e03568d90880328e933941346d778ae) tests: net:  Make "app" tests dependent on netif
- [25e5c60c](https://github.com/zephyrproject-rtos/zephyr/commit/25e5c60c4173506dfd6cec092a4b585bb4e56d6e) tests/net: utils: increase min RAM requirement to 24K
