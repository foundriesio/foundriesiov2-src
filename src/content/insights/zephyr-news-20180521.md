+++
title = "Zephyr Newsletter 21 May 2018"
date = "2018-05-21"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 21 May 2018 newsletter tracking the latest
[Zephyr](https://www.zephyrproject.org/) development merged into the
[mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

<!--more-->

The goals are to give a human-readable summary of what's been merged
into master, breaking it down as follows:

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

- [e15a4923](https://github.com/zephyrproject-rtos/zephyr/commit/e15a4923e88d038845457201fe11698ad0bb267e) ci: Clean the capability cache when the ccache is cleaned
- [e7509c17](https://github.com/zephyrproject-rtos/zephyr/commit/e7509c17c5938b48f9ad4b7ae78199bb0faa6113) release: Move version to 1.12.0-rc1

Development since the last newsletter has been active, with 300+
patches merged before last Friday's release feature freeze and
subsequent tagging of v1.12.0-rc1. (If you're unfamiliar with Zephyr's
release process, see the
[Development-Model](https://github.com/zephyrproject-rtos/zephyr/wiki/Development-Model)
page on the wiki for more details on these terms.)

The v1.12 release was originally the candidate for the first Long-Term
Support release. However, the release of the first LTS has been
postponed for various reasons, including ongoing work in:

- [architectural updates to the networking stack](https://github.com/zephyrproject-rtos/zephyr/issues/7591)
- [device driver API stabilization](https://github.com/zephyrproject-rtos/zephyr/issues/5697)
- [moving all boards to use Device tree](https://github.com/zephyrproject-rtos/zephyr/issues/4960)

Along with other issues tracked using the [LTS label in Zephyr's
GitHub
issues](https://github.com/zephyrproject-rtos/zephyr/labels/LTS).

An online meeting is being scheduled for further revisiting and
discussing what is required for the final LTS release; details are
expected to be released in the next day or two.

Some timelines are already available; for example, the networking
architectural updates, which are tracked in [issue
7591](https://github.com/zephyrproject-rtos/zephyr/issues/7591), are
targeting completion of major new features in v1.14:

![Networking re-architecting timeline](/uploads/2018/05/21/network-lts-timeline.png)

(Source: [Zephyr Networking Status May
2018](/uploads/2018/05/21/Zephyr Networking Status May 2018.pdf), a
presentation given to Zephyr's Technical Steering Committee by Andrei
Laperie of Intel).

Important Changes
-----------------

**OpenAMP**:

OpenAMP (and its libmetal dependency) was merged to enable
message-based cross-core communication. This carries BSD-3-Clause and
BSD-2-Clause licenses.

A usage sample is in [samples/subsys/openamp](http://docs.zephyrproject.org/samples/subsys/ipc/openamp/README.html).

**New Zephyr SDK**:

Zephyr SDK version 0.9.3 has been released. Linux users should upgrade
using the updated [installation
instructions](http://docs.zephyrproject.org/getting_started/installation_linux.html).

**Non-volatile Storage (NVS)**:

A long-running pull request to add a new storage mechanism for
persistent data was merged. The new Non-Volatile Storage (NVS)
subsystem is meant as an alternative to the existing FAT and NFFS file
systems, as well as the Flash Circular Buffer (FCB) library which was
ported to Zephyr from the MyNewt RTOS.

For more details, refer to the [NVS subsystem
documentation](http://docs.zephyrproject.org/subsystems/nvs/nvs.html).

This would seem to pair well with the [storage API
changes](/blog/2018/05/14/zephyr-news-20180514/) discussed in the
previous newsletter which introduced greater abstraction over the
storage backend.

**k_call_stacks_analyze() deprecated**:

The k_call_stacks_analyze() API was deprecated. Users are recommended
to switch to using
[k_thread_foreach()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv216k_thread_foreach18k_thread_user_cb_tPv),
perhaps re-implementing or calling into a stack usage dumping routine
for each thread.

**Userspace changes**:

Numerous userspace-related features and optimizations were merged.

New API was merged for memory management from specified memory
pools. The main functions are
[k_mem_pool_malloc()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_mem_pool_mallocP10k_mem_pool6size_t)
and
[k_mem_pool_free()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv215k_mem_pool_freeP11k_mem_block).
This is used to allow dynamic allocation of
kernel objects from userspace.

Cleanup functions defined on a per-kernel-object-type basis can now
be invoked when an object loses all permissions. This is used as a
framework for automatic resource release for dynamically-allocated
userspace objects.

New APIs were added for userspace allocation and freeing of kernel
objects of various types:

- [k_pipe_alloc_init()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_pipe_alloc_initP6k_pipe6size_t)/[k_pipe_cleanup()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv214k_pipe_cleanupP6k_pipe) for pipes
- [k_msgq_alloc_init()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_msgq_alloc_initP6k_msgq6size_t5u32_t)/[k_msgq_cleanup()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv214k_msgq_cleanupP6k_msgq) for message queues
- [k_stack_alloc_init()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv218k_stack_alloc_initP7k_stackj)/[k_stack_cleanup()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv215k_stack_cleanupP7k_stack) for stack objects

Additional APIs for allowing userspace access to queues includes:

- [k_queue_alloc_append()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv220k_queue_alloc_appendP7k_queuePv)/[k_queue_alloc_prepend()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv221k_queue_alloc_prependP7k_queuePv)
- [k_fifo_alloc_put()](http://docs.zephyrproject.org/api/kernel_api.html#c.k_fifo_alloc_put)
- [k_lifo_alloc_put()](http://docs.zephyrproject.org/api/kernel_api.html#c.k_lifo_alloc_put)

The [k_poll Polling
API](http://docs.zephyrproject.org/kernel/other/polling.html) is now
also accessible from user mode.

An optimization was merged which avoids executing user/supervisor
boundary checks when invoking system calls from privileged code in
translation units defined under arch/.

Access to the k_object_access_revoke() routine from userspace was
itself revoked, closing a hole where one thread could inappropriately
revoke another's access to a kernel object. Userspace threads may
revoke access to their own objects with k_object_release().

**TCP TIME_WAIT config changes**:

Configuration for how long Zephyr's TCP stack remains in the TIME_WAIT
state during connection closure is now managed through the single
[CONFIG_NET_TCP_TIME_WAIT_DELAY](http://docs.zephyrproject.org/reference/kconfig/CONFIG_NET_TCP_TIME_WAIT_DELAY.html)
option. This replaces the previous CONFIG_NET_TCP_TIME_WAIT and
CONFIG_NET_TCP_2MSL_TIME options. Applications using the old options
will need updates.

Features
--------

**Architectures**:

Support for Arm's v8-M cores continues, with support for secure fault
handling on Cortex-M23 along with other behind-the-scenes work on
memory access privilege checks.

There is a new CONFIG_PLATFORM_SPECIFIC_INIT available on Arm
targets. When enabled, the user must provide a `_PlatformInit`
routine, which will be called at Zephyr startup before anything else
happens.

Support was added to enable a Zephyr image running on an NXP LPC-based
SoC to boot a slave Cortex M0+ core. (Board support was added for the
slave core as `lpcxpresso54114_m0`.)

**Bluetooth**:

The Mesh shell now supports the recently-merged persistent storage
mechanism.

**Device Tree and Drivers**:

Zephyr now supports the automobile Controller Area Network (CAN)
protocol. The API is specified in include/can.h. The new API is
userspace-aware.

GPIO bindings were added for QMSI (Intel Quark) based devices, with
nodes added for quark_se_c1000_ss.

Device tree bindings were added for real-time clocks (RTCs), as well
as NXP Kinetis and QMSI based RTCs. SoC support was added for
KW41Z and quark_se_c1000_ss.

Additional patches continuing the work migrating LED and buttons
definitions to device tree were merged for mimxrt1050_evk and
lpcxpresso54114. Device tree support for sensors on the argonkey board
was also merged, along with em_starterkit device tree optimizations,
and bindings for LSM6DSL sensors and Kinetis watchdogs. A shim driver
using the newly-stabilized watchdog API was added for NXP MCUx
devices. SOC support is provided for K64 and KW2XD.

USBD (USB device) and USBFSOTG (USB full-speed On-the-Go) support was
added for NXP Kinetis SoCs. USB support was also enabled for STMicro
nucleo_f413zh.

WiFi support for the WINC1500 network controller was merged. This chip
can be used to add networking via SPI. This is the first user of the
new WiFi API which was merged during the v1.12 development
cycle. Support can be enabled using CONFIG_WIFI_WINC1500.

A driver was added for ILI9340 LCD displays.

**External Libraries**:

The OpenThread library version was bumped to db4759cc, to pull in some
bug fixes.

The Atmel WINC1500 WiFi driver was merged as part of enabling WiFI on
that chip. This is a BSD-3-Clause licensed HAL.

**Kernel**:

In a highly significant but (hopefully mostly) behind-the-scenes change,
[the scheduler was rewritten](https://github.com/zephyrproject-rtos/zephyr/commit/1acd8c2996c3a1ae0691247deff8c32519307f17).

A new [k_thread_foreach()](http://docs.zephyrproject.org/api/kernel_api.html#_CPPv216k_thread_foreach18k_thread_user_cb_tPv)
API was merged, which allows iterating over
threads. This requires CONFIG_THREAD_MONITOR to be enabled. Creation
and termination of existing threads is blocked via irq_lock() while
the routine is executing.

**Libraries**:

The red-black tree implementation in include/misc/rb.h now has
RB_FOR_EACH() and RB_FOR_EACH_CONTAINER() macros, for iterating over
red-black tree nodes and the structs which contain them.

The POSIX compatibility layer has additional file system support
APIs. Pulling in the POSIX headers defines macros which map POSIX
names to Zephyr-specific file system APIs appropriately. This includes
support for basic syscalls such as open(), read(), write(), close(),
and friends, and also allows for directory operations such as
rename(), stat(), and mkdir(). Refer to the headers in include/posix
for more information.

There is also now support for the POSIX mutex APIs.

**Miscellaneous**:

A new API was added for a singly-linked-list like type which allows
storing two flags in each node, by relying on 4-byte pointer
aligment. For details, refer to include/misc/sflist.h.

**Networking**:

The LWM2M subsystem now includes support for marking resources as
optional. Any resources so marked are not initialized by the core
LWM2M subsystem; applications must initialize them using
lwm2m_engine_set_res_data() and lwm2m_engine_get_res_data().  This
also enables remote administration of these resources by the LWM2M
server through CREATE operations. It also enables future work where
BOOTSTRAP operations will behave differently when encountering
optional resources. As part of these changes, various object resources
throughout the LWM2M core and in supported IPSO objects were marked
optional appropriately.

The 802.15.4 subsystem now supports source address filtering and
performing energy detection scans when OpenThread is in use.

**Samples**:

New samples include:

- a RPL border router application, [samples/net/rpl_border_router](http://docs.zephyrproject.org/samples/net/rpl_border_router/README.html)
- A WiFi shell sample, [samples/net/wifi](http://docs.zephyrproject.org/samples/net/wifi/README.html)
- An OpenAMP usage sample, [samples/subsys/openamp](http://docs.zephyrproject.org/samples/subsys/ipc/openamp/README.html)
- An MCUX IPM mailbox example, [samples/subsys/ipc/ipm_mcux](http://docs.zephyrproject.org/samples/subsys/ipc/ipm_mcux/README.html)
- A sample for the 96Boards ArgonKey, [samples/boards/96b_argonkey](http://docs.zephyrproject.org/samples/boards/96b_argonkey/README.html)
- A CAN sample, [samples/can](http://docs.zephyrproject.org/samples/can/README.html), tested on stm32f072b_disco

**Scripts**:

The flash, debug, and debugserver handlers now use a new meta-tool
called "west". This is still a behind-the-scenes change; further work
expected before the v1.12 release will add documentation for this
tool.

**Testing**:

The effort adding descriptions, cleanups, and other improvements to
Zephyr's test cases to use them from a higher-level test management
system continues.

Bug Fixes
---------

Numerous drivers cleanups and bug fixes went in, affecting various
devices.

Various Arm-specific fixes went in as part of the v8-M work.

A new CONFIG_BT_MESH_IVU_DIVIDER went in, which fixes an issue related
to re-initializing initialization vectors. Various other Bluetooth
cleanups and fixes went in, including removals of deprecated APIs and
unused variables and documentation fixes.

Numerous fixes and additional Doxygen descriptions went into the test
cases.

Networking fixes include net-app fixes for TLS warnings, source IPv4
address selection, build fixes with TCP disabled, and byte order
handling; ethernet MAC address setting; LWM2M port handling fixes;
dropping of invalid packets; and a couple of ICMPv6 fixes.

Various build fixes, error handling and Kconfig dependency management
improvements, k_call_stacks_analyze() removals, and more were added to
the samples.

Individual Changes
==================
Patches by area (309 patches total):

- Arches: 29
- Bluetooth: 7
- Boards: 21
- Build: 5
- Continuous Integration: 2
- Device Tree: 28
- Documentation: 12
- Drivers: 54
- External: 6
- Firmware Update: 1
- Kernel: 25
- Libraries: 11
- Maintainers: 2
- Miscellaneous: 4
- Networking: 31
- Samples: 29
- Scripts: 21
- Storage: 2
- Testing: 19

Arches (29):

- [6307b8b9](https://github.com/zephyrproject-rtos/zephyr/commit/6307b8b97dd713605ebb362d8cf894104ae57b0c) arch: arc: refactor the soc part of em_starterkit
- [47d3a90d](https://github.com/zephyrproject-rtos/zephyr/commit/47d3a90dca3a0b54bc2c8396289317b1cb3d3be7) arch: arc: reuse GCC_M_CPU in cmake file and remove unused comments
- [5eb5bb7d](https://github.com/zephyrproject-rtos/zephyr/commit/5eb5bb7df85cc8c079035be1413e89062b0d9de5) arch: arc: add the missing SPI_DW_SPI_CLOCK in dts.fixup
- [c13b12eb](https://github.com/zephyrproject-rtos/zephyr/commit/c13b12eb49d88121595ac47c27085329c489db41) arch: arc: explictly list all def config
- [9bc1dc72](https://github.com/zephyrproject-rtos/zephyr/commit/9bc1dc72964597e032625a921b3e05aa38933e71) arch: arm: Secure fault handling for Cortex-M23
- [0a25ad15](https://github.com/zephyrproject-rtos/zephyr/commit/0a25ad1595d64934661ca5c5d356f52849857229) arch: arm: fix bug in AIRCR config on init
- [361f4ac9](https://github.com/zephyrproject-rtos/zephyr/commit/361f4ac94b4bb969e19f961fc1b1e0d5677118eb) arch: arm: improve fault dump for secure firmware
- [70b45c63](https://github.com/zephyrproject-rtos/zephyr/commit/70b45c63e52f9646bde50c6d538ba56cc6cc3df4) arch: arm: distinguish integrity signatures with/without FP
- [7c91a4a5](https://github.com/zephyrproject-rtos/zephyr/commit/7c91a4a53b754e821452d14e54b0cead480bfcc4) arch: arm: fix SecureFault IRQn for non-CMSIS compliant MCUs
- [5ab3960c](https://github.com/zephyrproject-rtos/zephyr/commit/5ab3960c757acda015d8c0f1de8e6da8809cdef1) arch: Cmake: Add \__ZEPHYR_SUPERVISOR__ macro for arch files.
- [0b7e22bd](https://github.com/zephyrproject-rtos/zephyr/commit/0b7e22bdb6b26581da4638103225fa386cca0c20) arch: arm: Add platform init hook at \__start
- [fd4759b5](https://github.com/zephyrproject-rtos/zephyr/commit/fd4759b5d7863d31385948a11b4feadab2f4ed05) arch: nxp: lpc54xxx: Rename SoC bits from LPC54114 to LPC54114_M4
- [a5c12b6c](https://github.com/zephyrproject-rtos/zephyr/commit/a5c12b6c05fb1800690c0988caa2220c7979ca77) arch/arm/soc/nordic_nrf/nrf52: NFCT pins configuration
- [0daf69bb](https://github.com/zephyrproject-rtos/zephyr/commit/0daf69bb5700fc10b5fa0625a69a858d8ddb3bde) xtensa: fix CONFIG_INIT_STACKS for IRQ stack
- [29ed87c9](https://github.com/zephyrproject-rtos/zephyr/commit/29ed87c930e593127094080edf0303bf56cbc5ed) native: entropy: warn of security risk
- [167efd70](https://github.com/zephyrproject-rtos/zephyr/commit/167efd70b69fbf491e5089eb242bc2e77891344a) arm: mpu: nxp: set bus master 4 to write and read access
- [d6f14291](https://github.com/zephyrproject-rtos/zephyr/commit/d6f14291ee6f451d572c4082cc83bd9da05be3ea) arch: nxp_kinetis: enable USB device driver
- [c842f32d](https://github.com/zephyrproject-rtos/zephyr/commit/c842f32dddb2e318b66ce882c3aa110f9f9a2df2) arch: arm: Define & implement API for test target (Non-Secure)
- [600d731c](https://github.com/zephyrproject-rtos/zephyr/commit/600d731c95e964d9c6ebd6fd45ee5c2efc8d0f80) arch: arm:  select CPU_CORTEX_M_HAS_CMSE in ARMv8-m
- [8e0c830d](https://github.com/zephyrproject-rtos/zephyr/commit/8e0c830dcee567390b51a14981d21b8d08b98ef7) arch: arm: implement cmse address range check
- [b8ec6da3](https://github.com/zephyrproject-rtos/zephyr/commit/b8ec6da38f94c8b289a61233271cd8028d785c27) arch: arm: convenience wrappers for C variable permissions checks
- [e9ca0a7d](https://github.com/zephyrproject-rtos/zephyr/commit/e9ca0a7daef8a45fa4dd29f9a2b63e90b562186b) nxp_kinetis: Enable mcux watchdog driver on k64, kw2xd socs
- [02253c23](https://github.com/zephyrproject-rtos/zephyr/commit/02253c231d6e5ae65197118a3f08683fb3907b99) nxp_kinetis: Fix rtc base address in kw41z dts.fixup
- [b7312d1b](https://github.com/zephyrproject-rtos/zephyr/commit/b7312d1bbc32d752a7745484091089155dd37468) arch: arm: lpc: Added support for Cortex-M0+ on lpc54114 soc
- [7514a92c](https://github.com/zephyrproject-rtos/zephyr/commit/7514a92cbeb783dd3dd7eeddb2863467ed52b1f3) arch: arm: nxp_lpc: Added support for init of slave core
- [53f91976](https://github.com/zephyrproject-rtos/zephyr/commit/53f91976b16b26a48fd2900a51f130b8a6ea045a) arch/x86: Use dts to set gpio options for quark_se and quark_d2000
- [250c4a87](https://github.com/zephyrproject-rtos/zephyr/commit/250c4a87ed36ad703bedbc0509fd98c88ea55c12) arch: Use dts to set rtc priorities for Intel quark, x86 and arc
- [bd9706cd](https://github.com/zephyrproject-rtos/zephyr/commit/bd9706cd9bb73a3385d9111fcf79026fd830bc8f) arch/arc: Use dts to set gpio priorities for quark_se_c1000_ss
- [60d509f3](https://github.com/zephyrproject-rtos/zephyr/commit/60d509f3d705cc1bc19f5333e5cd638faadc6c96) arch: Use dts to set i2c priorities for quark_se/quark_d2000

Bluetooth (7):

- [0fb9ea03](https://github.com/zephyrproject-rtos/zephyr/commit/0fb9ea03043551c66e6f0ec14c4ef9a001255d7d) subsys: bluetooth: Remove deprcated k_call_stacks_analyze API
- [a3c1b3db](https://github.com/zephyrproject-rtos/zephyr/commit/a3c1b3dbcc84a0e5feecf0a3ae2328ec53c1287b) Bluetooth: Mesh: Expose bt_mesh_is_provisioned() publicly
- [4b4b6762](https://github.com/zephyrproject-rtos/zephyr/commit/4b4b6762aa28eb549eb1e3d96682bd5351db3914) Bluetooth: GATT: Fix documentation of bt_gatt_notify
- [cfb34d2b](https://github.com/zephyrproject-rtos/zephyr/commit/cfb34d2b80888f261d4a0f772a286a11a5943337) Bluetooth: Mesh: shell: Add persistent storage support
- [2b73c97d](https://github.com/zephyrproject-rtos/zephyr/commit/2b73c97d68c9b023e1eb10679e5c201a663e92d1) Bluetooth: Mesh: Fix IV Update duration tracking
- [20ea1b86](https://github.com/zephyrproject-rtos/zephyr/commit/20ea1b86b9fbea96247b13def942791243d5b5ab) Bluetooth: Mesh: Remove redundant ivu_unknown variable
- [df4220b2](https://github.com/zephyrproject-rtos/zephyr/commit/df4220b21337b41d2c8facd77e7929cc32fdd0c4) Bluetooth: L2CAP: Add support for dynamically allocated PSM values

Boards (21):

- [2368edd8](https://github.com/zephyrproject-rtos/zephyr/commit/2368edd8e78b052b9840417e6a3a03b8a86c5b90) mimxrt1050_evk: Move led and button definitions to dts
- [b8196c89](https://github.com/zephyrproject-rtos/zephyr/commit/b8196c8906c57990ef8e9ea64aee9ae7c32796aa) boards: em_starterkit: add pmod mux init
- [ef19b90a](https://github.com/zephyrproject-rtos/zephyr/commit/ef19b90a342697e0bffff5562841924e721c8c10) boards: nucleo_f413zh: enable usb
- [5ec02d14](https://github.com/zephyrproject-rtos/zephyr/commit/5ec02d141e87bad7c79ac81578f9936939778d60) boards: 96b_carbon: add gpios in bt controller node
- [d3ea9102](https://github.com/zephyrproject-rtos/zephyr/commit/d3ea910293fa21838663e2643481ab6526658d83) boards/96b_carbon: Update doc with USB support
- [45cfea6f](https://github.com/zephyrproject-rtos/zephyr/commit/45cfea6f4a4e3e810c6fae6fb12465bd8bddcb94) board: lpcxpresso54114: Move led and button definitions to dts
- [0f4a2b75](https://github.com/zephyrproject-rtos/zephyr/commit/0f4a2b75ff2a5420a55e73db1eab5e97debd6966) board: lpcxpresso54114: Rename to lpcxpresso54114_m4
- [5b6fde14](https://github.com/zephyrproject-rtos/zephyr/commit/5b6fde144da3d2ed1aa88b3127956b995bc20576) boards: arm: nrf: Enable mcumgr UART
- [48cc4620](https://github.com/zephyrproject-rtos/zephyr/commit/48cc46206f33ece1a20913535a0cd05b569f54f2) boards: frdm_kw41z: enable xoroshiro on board level only
- [11c68a10](https://github.com/zephyrproject-rtos/zephyr/commit/11c68a10f47bb56f595fe12a30c60d34c23dbeec) boards/arm/nrf52xx_boards: makes GPIO_AS_PINRESET common
- [103cbe8c](https://github.com/zephyrproject-rtos/zephyr/commit/103cbe8c90707352fb4a2069fd6e8fcf46649145) boards: minnowboard: do not run net/bluetooth tests
- [c976dbb2](https://github.com/zephyrproject-rtos/zephyr/commit/c976dbb233b05784061ea18115cf853c08e0bc2d) boards: Document watchdog driver support on k64, kw2xd boards
- [c3ce923f](https://github.com/zephyrproject-rtos/zephyr/commit/c3ce923fd9581f9a7d1756fb89a656906c490fd1) arm: lpcxpresso54114_m0: Add board support for slave core
- [3053f351](https://github.com/zephyrproject-rtos/zephyr/commit/3053f351fadd9e7d51ad056962616fb52ee2b7d7) boards: nios2: altera_max10: Enable device support for altera_max10
- [4687c989](https://github.com/zephyrproject-rtos/zephyr/commit/4687c989c3fe0019d7b5534987da2927fdc2e4b7) boards: nios2: qemu: Enable device support for qemu
- [ce13fc8e](https://github.com/zephyrproject-rtos/zephyr/commit/ce13fc8eeb74977090ca59eb7efb684c2e790c31) boards: stm32: argonkey: Enable STM32 I2C interrupt support
- [17c15ff1](https://github.com/zephyrproject-rtos/zephyr/commit/17c15ff1826832b7ac81235dfe33cb5653bfd5d9) boards: stm32: argonkey: Add dts support to sensors
- [c9262bb4](https://github.com/zephyrproject-rtos/zephyr/commit/c9262bb47f8c40a685451a01a494f439b2fdf43a) board: argonkey: add LSM6DSL configuration in Kconfig.defconfig
- [f8288abd](https://github.com/zephyrproject-rtos/zephyr/commit/f8288abd229e3d488740b5ace0089b2e4c6b383a) boards/qemu_x86: Enable fast scheduler options
- [59dc82e0](https://github.com/zephyrproject-rtos/zephyr/commit/59dc82e0d28451a436baa794a8f9ca433270aa05) boards: adjust openocd runner arg syntax
- [e73637af](https://github.com/zephyrproject-rtos/zephyr/commit/e73637af24b14c492c62a1b5865df5e6563ce976) boards: stm: Add CAN support for stm32f072b micro controller

Build (5):

- [c674167f](https://github.com/zephyrproject-rtos/zephyr/commit/c674167fea42ba75e795cc4d2dcdbf410f1a2ea7) cmake: extensions: Added a new macro zephyr_library_ifdef
- [cc8b7265](https://github.com/zephyrproject-rtos/zephyr/commit/cc8b72651725eafebada51f52ffe21e658ae2c5e) cmake: Add new generate_inc_file_for_gen_target function
- [4dc9e5b2](https://github.com/zephyrproject-rtos/zephyr/commit/4dc9e5b2de33109a00b84e7003dc02a5f0742d99) kconfig: Get rid of 'option env' bounce symbols
- [64badd97](https://github.com/zephyrproject-rtos/zephyr/commit/64badd97cd683ddfb7d72d3abdf89a979e91912a) cmake: flash: save runner configuration to CMake cache
- [aa262894](https://github.com/zephyrproject-rtos/zephyr/commit/aa262894581b4fd85054ed3ae10702a34f16a8e9) kconfig: Get rid of leading/trailing whitespace in prompts

Continuous Integration (2):

- [e15a4923](https://github.com/zephyrproject-rtos/zephyr/commit/e15a4923e88d038845457201fe11698ad0bb267e) ci: Clean the capability cache when the ccache is cleaned
- [df9210ca](https://github.com/zephyrproject-rtos/zephyr/commit/df9210ca56a780ca79e0061ffb1ebf50d5fee31c) ci: use new docker file with new SDK

Device Tree (28):

- [e524f0b8](https://github.com/zephyrproject-rtos/zephyr/commit/e524f0b846fcbc7bbd106300aaabbe8c9d71e924) dts: x86: derive RAM and ROM size from dts instead of Kconfig
- [99e1f849](https://github.com/zephyrproject-rtos/zephyr/commit/99e1f849bf6df8f6cfcd135087a6610ea86f96ac) dts: optimize the dts for em_starterkit
- [9c7d92a6](https://github.com/zephyrproject-rtos/zephyr/commit/9c7d92a694e7503f6ccf86e61e5f8ddc9da8f8d4) dts: fixes in the dts of em_starterkit em9d configuration
- [532e4d22](https://github.com/zephyrproject-rtos/zephyr/commit/532e4d22eedde133c38b15808d8eb1201b3635ca) dts: optimize and bug fixes the dts of em_starterkit
- [8cf04a18](https://github.com/zephyrproject-rtos/zephyr/commit/8cf04a18fd0272c7b544a46f42894c3e0cc01e5e) dts/bindings: Add reset/irq gpios to zephyr,bt-hci-spi yaml
- [48e2dba2](https://github.com/zephyrproject-rtos/zephyr/commit/48e2dba28fe48c4555592c12e2b34605f82a48e2) dts: xtensa: fix build error.
- [d8983e6d](https://github.com/zephyrproject-rtos/zephyr/commit/d8983e6d11d71b1048c4d269eabc9d5afb000fc8) dts/st,stm32-usb: Add use-prop-name to disconnect-gpios
- [9c27ae71](https://github.com/zephyrproject-rtos/zephyr/commit/9c27ae7162e2aa2cf4c949881a69e3f9a8c49165) dts: bindings: add yaml file for Kinetis USBD support
- [d8cd1195](https://github.com/zephyrproject-rtos/zephyr/commit/d8cd11956212fcbdc45235cb345740a01bed47f9) dts: arm: nxp: use DT to configure USBD on Kinetis SoC
- [ae71554b](https://github.com/zephyrproject-rtos/zephyr/commit/ae71554be363bd194578525610405a3d3f24ae15) dts: stm32l4: add node and fixup for i2c4
- [d75291ef](https://github.com/zephyrproject-rtos/zephyr/commit/d75291ef93d4a4eff9d68e382bf016be8e04ae0d) yaml: rtc: Add yaml definitions for RTC
- [1fe586f6](https://github.com/zephyrproject-rtos/zephyr/commit/1fe586f6787430a8ccb15336d72308376bf4646f) dts: nxp: kw41z: Fixup NXP Kinetis RTCs on KW41Z
- [7960f791](https://github.com/zephyrproject-rtos/zephyr/commit/7960f79134be70160ca06bd1d9c10aa75d6f8ff2) dts: Add kinetis watchdog bindings and update k64, kw2xd soc nodes
- [8f908f38](https://github.com/zephyrproject-rtos/zephyr/commit/8f908f38e0c3464359c10928340b4a8c6e091089) dts: nios2f: Add device tree support
- [29489246](https://github.com/zephyrproject-rtos/zephyr/commit/294892465566cd2d12ef32d379013a1153cc3bd2) dts: nios2-qemu: add device tree support
- [9e1f1acc](https://github.com/zephyrproject-rtos/zephyr/commit/9e1f1acc242410a8ca6a7ed31053c3bb652ca1bd) dts/x86: Add Copyright headers to x86 dtsi files
- [b8e8077c](https://github.com/zephyrproject-rtos/zephyr/commit/b8e8077cbee155029455798f6c45780a86a832aa) dts: Adding priority cell to Intel's IOAPIC IRQ controllers descriptor
- [e4aced51](https://github.com/zephyrproject-rtos/zephyr/commit/e4aced513dc7e93f8463d379b5fb70e5d424119f) dts/x86: Enable generating the IRQ priority on all SoCs
- [878d0fb8](https://github.com/zephyrproject-rtos/zephyr/commit/878d0fb87707e3becd7d5d4eead962bf41b49025) dts: Add yaml descriptor for the QMSI GPIO driver
- [69e5b3ec](https://github.com/zephyrproject-rtos/zephyr/commit/69e5b3ec3d7320c51450eeff438f6fa208d60aab) dts/x86: Fix GPIO nodes for intel_curie and quark_d2000
- [1f2553ba](https://github.com/zephyrproject-rtos/zephyr/commit/1f2553ba5c6dfad2a9b6e68d0649ebc5e868e499) dts: Add yaml descriptor for the QMSI RTC driver
- [16c455e4](https://github.com/zephyrproject-rtos/zephyr/commit/16c455e4cd3ccb7be0e09573bee8b9f595c6c619) dts/arc: Add rtc node to quark_se_c1000_ss
- [43878fd8](https://github.com/zephyrproject-rtos/zephyr/commit/43878fd8b68dbdb55bb106449e7c64637092a5b1) dts/bindings: Remove useless attribute in QMSI uart node descriptor
- [8bbb80e3](https://github.com/zephyrproject-rtos/zephyr/commit/8bbb80e30867c21b1032c4e8274703adb587b986) dts/x86: Fix UART nodes for ia32, atom and quark_x1000
- [29e51982](https://github.com/zephyrproject-rtos/zephyr/commit/29e519821db63d71c87441292734486f94c20f7d) dts/arc: Add the GPIO nodes to quark_se_c1000_ss
- [17a2c1e6](https://github.com/zephyrproject-rtos/zephyr/commit/17a2c1e699b21426752e776cce3377a5a23e69fc) dts: Add yaml descriptor for the QMSI SS GPIO driver
- [0ce2cc19](https://github.com/zephyrproject-rtos/zephyr/commit/0ce2cc19b3617556816f19e9e163d2c91272222f) dts/x86: Update i2c nodes with interrupts for quark_se and quark_d2000
- [36b0c321](https://github.com/zephyrproject-rtos/zephyr/commit/36b0c321a7c78753dcfeb53df0732d31d3c36172) dts: bindings: Add SPI yaml file for LSM6DSL sensor

Documentation (12):

- [9af44d82](https://github.com/zephyrproject-rtos/zephyr/commit/9af44d8256e863214ebfaabf7349542cd69a6caf) doc: add native posix command line help
- [15f2035c](https://github.com/zephyrproject-rtos/zephyr/commit/15f2035cabc17ebefa2357074a454703d3a0768e) doc: update the doc of em_starterkit
- [9342e3d3](https://github.com/zephyrproject-rtos/zephyr/commit/9342e3d32eec10e191ada3fcf644b9797de78920) doc: getting_started: Remove redundant and erronous doc's
- [2a892d5d](https://github.com/zephyrproject-rtos/zephyr/commit/2a892d5d6d70becfb2c7f4c2dcdf9f2cc7ef45fc) doc: update mac instructions
- [941007d4](https://github.com/zephyrproject-rtos/zephyr/commit/941007d4a0582883d5e6f2804bdf0745c88568b7) doc: Update Zephyr SDK version
- [b98388c6](https://github.com/zephyrproject-rtos/zephyr/commit/b98388c67f0ec8be1a122e798432eafa58c64d67) doc: networking: qemu_setup: Update details and add DNS information
- [aa9fe261](https://github.com/zephyrproject-rtos/zephyr/commit/aa9fe261666c963dfae35a509eafae0761a765f9) doc: genrest: Show properties on the correct symbol definition
- [39f396a8](https://github.com/zephyrproject-rtos/zephyr/commit/39f396a8ad2a2f386f24de27ad0cf4046dc8572b) doc: tests: remove obsolete and bogus test groups
- [09c81379](https://github.com/zephyrproject-rtos/zephyr/commit/09c813793bb6f11caea76db39cc97bf40d84cc0d) doc: genrest: Speed up documentation rebuilding
- [d1d0dd45](https://github.com/zephyrproject-rtos/zephyr/commit/d1d0dd45ed7203dbbafe6fa43e69bdcabeb34953) doc: fix missing NVS API documentation
- [ef927a87](https://github.com/zephyrproject-rtos/zephyr/commit/ef927a87ec78eb4a7cc956bb4e7d84dc0154e2f4) doc: fix missing networking API documentation
- [f93ca237](https://github.com/zephyrproject-rtos/zephyr/commit/f93ca23765220f3f05ace1f57c305ed5db16b46b) doc: mark bt_test_cb API as not documented

Drivers (54):

- [3f249755](https://github.com/zephyrproject-rtos/zephyr/commit/3f249755143654abc53206714a22a568ed627fcc) drivers: spi: fix the bug of slave selection in spi_dw
- [63ffbe9d](https://github.com/zephyrproject-rtos/zephyr/commit/63ffbe9dcb5404bc1f53984b9d938a0034e7bde8) usb: usb_device.c: rewrite if condition judgment
- [4b0b65c1](https://github.com/zephyrproject-rtos/zephyr/commit/4b0b65c1b8cd08072074c2dbe640be55756d24c7) subsys: usb: check for invalid descriptor type request
- [b0db28b5](https://github.com/zephyrproject-rtos/zephyr/commit/b0db28b512c8306c88f3240dc8da1a1f4e79377a) drivers: Cmake: Add \__ZEPHYR_SUPERVISOR__ macro for driver files.
- [931630ca](https://github.com/zephyrproject-rtos/zephyr/commit/931630ca2bd50e831c9e6ac6f369e7b0c61c37ba) usb: webusb: Define and use MS descriptor structures
- [df5e0e00](https://github.com/zephyrproject-rtos/zephyr/commit/df5e0e008e2d019b0f563ddd8bf92e867fa00e23) usb: webusb: Use sizeof instead of magic numbers
- [7fa8537d](https://github.com/zephyrproject-rtos/zephyr/commit/7fa8537d227be71d446d1c6e761d7a34dc1a89e6) usb: webusb: Trivial cleanup
- [7de55a07](https://github.com/zephyrproject-rtos/zephyr/commit/7de55a07fc36d717baf9764e9f2b27665cb22065) pwm: stm32: Fix type for PMW3 support
- [82c0b8cb](https://github.com/zephyrproject-rtos/zephyr/commit/82c0b8cba11d82b1b5ba5933e64fe21579ec311a) drivers/bluetooth/hci: Name the choice of BT HCI driver bus
- [49d82086](https://github.com/zephyrproject-rtos/zephyr/commit/49d820866c5019a32b26ccd5becdb5203af411fc) drivers/dma: dma_stm32f4x: check stream id boundaries
- [e2393a00](https://github.com/zephyrproject-rtos/zephyr/commit/e2393a002e8a2ee8a9d46fd18174b3c6adc7cc6e) drivers: timer: nRFx: Remove redundant code
- [05c45e35](https://github.com/zephyrproject-rtos/zephyr/commit/05c45e359a94e96353dfac1f0abeccf6893e988a) drivers: serial: Fix race condition in nRF5 UART TX
- [e61c4812](https://github.com/zephyrproject-rtos/zephyr/commit/e61c48123c05ca8ed18acc98ea8fd5487cb92206) drivers: crypto: crypto_tc_shim: Set output length for all operations
- [ab16853b](https://github.com/zephyrproject-rtos/zephyr/commit/ab16853b26e0b309f46e29ec675f70f3643125e9) drivers: crypto: crypto_mtls_shim: Set output length for all operations
- [845ac3ef](https://github.com/zephyrproject-rtos/zephyr/commit/845ac3ef4666d23332158321570930433d450824) drivers: spi: Fix TOCTOU while transceiving SPI messages
- [cd580e0b](https://github.com/zephyrproject-rtos/zephyr/commit/cd580e0bbaa1014c907153b1ddaf7a51e0f306d9) drivers/adc: Uneven buffers will lead to buffer overflow
- [9bdf1cdb](https://github.com/zephyrproject-rtos/zephyr/commit/9bdf1cdb0ebac700df2f59ed6092d2627ad53543) drivers/wifi: Add winc1500 WiFi driver
- [2a1d222a](https://github.com/zephyrproject-rtos/zephyr/commit/2a1d222adc9c39a75830e3a37d392463bc365570) drivers/wifi: Generalize GPIO configuration for the WINC1500 driver
- [0294c673](https://github.com/zephyrproject-rtos/zephyr/commit/0294c67349c70ad8386a659d8464c0dacd9dd793) drivers/wifi: Move configure macros to Kconfig
- [8e65f6ab](https://github.com/zephyrproject-rtos/zephyr/commit/8e65f6ab2a824c42857a27b4f073fe07eaaeaee6) drivers/wifi: Let's go away from SPI legacy API in WINC1500
- [1e4ba823](https://github.com/zephyrproject-rtos/zephyr/commit/1e4ba8231d76feb8f3c969f5307b9c67b8362bab) drivers/wifi: Remove useless gpio configuration call in winc1500 driver
- [569e70aa](https://github.com/zephyrproject-rtos/zephyr/commit/569e70aaae37f3338e531926222464cab4bf45a6) drivers/wifi: Split case logic into functions in winc1500 driver
- [5f9ccad9](https://github.com/zephyrproject-rtos/zephyr/commit/5f9ccad97fc2882b5e9bd036ec9f668d5fd61146) drivers/wifi: Switch info level to debug level in winc1500 driver
- [24bb24e6](https://github.com/zephyrproject-rtos/zephyr/commit/24bb24e696124a52a90e926bb347aaf85e08f7bf) drivers/wifi: WINC1500 driver is not using WAKE pin
- [21455032](https://github.com/zephyrproject-rtos/zephyr/commit/214550327358618a35dd6499cb05f21291084fbe) drivers/winc1500: Implement wifi mgmt offloaded API
- [ce947431](https://github.com/zephyrproject-rtos/zephyr/commit/ce947431e22499bd447bbcdb6e6c21762a1443b3) drivers/wifi: Move all winc1500 related code to its own directory
- [5dc6f99c](https://github.com/zephyrproject-rtos/zephyr/commit/5dc6f99cfd48e61d052c43c3d2a5116b2a810f10) drivers: usb: add usb device driver for Kinetis USBFSOTG Controller
- [06840af1](https://github.com/zephyrproject-rtos/zephyr/commit/06840af1cc1cfe12ccca3ebcb5936dbc6f3541f1) drivers: usb: kinetis: fixup endpoint config, stall and read
- [50990cdf](https://github.com/zephyrproject-rtos/zephyr/commit/50990cdfaf6e74b372cdfdd67cc47a0672012ba5) drivers/ieee802154: KW41Z drivers is missing hw ACK caps
- [e681f9cb](https://github.com/zephyrproject-rtos/zephyr/commit/e681f9cbebce8c98a3527cb074e71804b550d30d) pwm: stm32: fix off-by-one on PWM period
- [af601c22](https://github.com/zephyrproject-rtos/zephyr/commit/af601c22e6ec536adcda4c4ca7af17e817eaaf7d) i2c: stm32: add support for I2C4
- [70fdb7f2](https://github.com/zephyrproject-rtos/zephyr/commit/70fdb7f2efbe28e2b0c2cdc2cf749cd852b0fda9) pinmux: stm32l4: add I2C4 pinmux on PD12/PD13
- [d0fa5872](https://github.com/zephyrproject-rtos/zephyr/commit/d0fa58722d8aaf69e50846d83fe6f8ae59ff3e7b) watchdog: iwdg: honor IWDG_STM32_START_AT_BOOT
- [35cb2ba3](https://github.com/zephyrproject-rtos/zephyr/commit/35cb2ba346f97e6d0a154db514ce4988c1ed7a6f) watchdog: stm32: fix style issue
- [4aaaccc7](https://github.com/zephyrproject-rtos/zephyr/commit/4aaaccc7399356de8ee4b408595c22241832a557) rtc: Kconfig: Split off QMSI into separate Kconfig
- [27bdb833](https://github.com/zephyrproject-rtos/zephyr/commit/27bdb83308301a1dbe3db9e1fbaf6560facda654) rtc: Add prescalar configuration option
- [7b92d3fb](https://github.com/zephyrproject-rtos/zephyr/commit/7b92d3fb1c7fc2f5d99e55d6b08ee6ca41cb3bbd) rtc: nxp: Add RTC driver for NXP Kinetis
- [39d63d31](https://github.com/zephyrproject-rtos/zephyr/commit/39d63d316b92955f0338ec98a14d94542e4e10a9) clock_control: Add support for getting LPO frequency in mcux sim driver
- [474a618f](https://github.com/zephyrproject-rtos/zephyr/commit/474a618f1bff34a5b04c929fd90af3998f1d41c2) watchdog: Introduce mcux wdog shim driver
- [5477ee45](https://github.com/zephyrproject-rtos/zephyr/commit/5477ee4531081eded62f8668aa509924b09ece58) mcux: Add MCUX IPM driver for lpc and kinetis socs
- [375e8d73](https://github.com/zephyrproject-rtos/zephyr/commit/375e8d73cef1fe07dc08e7dc3203b3f1821a9ab4) spi_handlers: fix some build issues
- [7e5b021b](https://github.com/zephyrproject-rtos/zephyr/commit/7e5b021b569d2d2d3b33ecd9fedf349c666851b8) drivers: adc: fix TOCTOU attacks
- [c4a62e04](https://github.com/zephyrproject-rtos/zephyr/commit/c4a62e0427cc7ecd78c18945957a8eb46b46aa73) drivers: serial: nrf: Fix is_pending handling
- [17c64566](https://github.com/zephyrproject-rtos/zephyr/commit/17c6456678d5e50a991b97e4cfc7c815ced2f472) drivers/uart: Use dts to set uart priorities for QMSI driver
- [61ef30d1](https://github.com/zephyrproject-rtos/zephyr/commit/61ef30d10eca817ca76cb388a1bc5e98ad4a30e0) drivers/uart: Use dts to set uart options for ns16550 driver
- [ed26b957](https://github.com/zephyrproject-rtos/zephyr/commit/ed26b957467871d8a3ec84c31748ef25afb37052) drivers/gpio: Removing dts generated options in QMSI Kconfig
- [00bbbae4](https://github.com/zephyrproject-rtos/zephyr/commit/00bbbae41d304ad183fbba1be44a118056370956) drivers/serial: Add port 2 instance in ns16550 driver
- [ca16779d](https://github.com/zephyrproject-rtos/zephyr/commit/ca16779d9e18da97711405c0088442f5357ed74c) driver: ILI9340 LCD display driver
- [05234e35](https://github.com/zephyrproject-rtos/zephyr/commit/05234e352f046bcb344efe1a1c0c0fc7e0078aa7) driver: sample: ILI9340 sample application
- [9e12807a](https://github.com/zephyrproject-rtos/zephyr/commit/9e12807a6b59816ad0f86e7f4b3b382a02c767f7) API: can: Add API for Controller Area Network driver
- [023e4518](https://github.com/zephyrproject-rtos/zephyr/commit/023e4518f24ab19fc6afede26d06b8a58ed261e9) drivers: can: Add Kconfig for CAN driver
- [d3101b1f](https://github.com/zephyrproject-rtos/zephyr/commit/d3101b1fa4117ec9e475b9db4a5baf15d610857d) drivers: can: Add syscall handlers for CAN API
- [50f8296b](https://github.com/zephyrproject-rtos/zephyr/commit/50f8296baadd48c7d67b3399604c29071b096e65) drivers: can: Add dts bindings for CAN
- [2976ac35](https://github.com/zephyrproject-rtos/zephyr/commit/2976ac351db2bcb88a23984f47b3022e79836cab) drivers: can: Add CAN driver support for STM32

External (6):

- [4dd8d684](https://github.com/zephyrproject-rtos/zephyr/commit/4dd8d684336ab574355635e13fd139a15daa9c99) ext: Add dual core startup code for lpc54114 based on mcux 2.3.0
- [6871057e](https://github.com/zephyrproject-rtos/zephyr/commit/6871057e31a097f9a08134e10c31cb9bfe8a8a18) ext: Modified lpc54114 startup code from mcux for use with Zephyr.
- [4d1da3f7](https://github.com/zephyrproject-rtos/zephyr/commit/4d1da3f7235c54b4f7fa9a16131812df1a70095b) ext: Add winc1500 driver from Atmel
- [89ac6b5d](https://github.com/zephyrproject-rtos/zephyr/commit/89ac6b5db70b766ee0a090fab162ddd2a7df5f88) ext/hal: Add WINC1500 README for non-Apache 2.0 licensed contribution
- [3ddfd171](https://github.com/zephyrproject-rtos/zephyr/commit/3ddfd1714e3f4e38d28867c740e5c127bccf6a18) ext: Import libmetal for IPC/open-amp
- [17b64baf](https://github.com/zephyrproject-rtos/zephyr/commit/17b64bafae2f7a7d5cec40767aa081bb40c6c4d0) ext: Import OpenAMP for IPC

Firmware Update (1):

- [05148610](https://github.com/zephyrproject-rtos/zephyr/commit/05148610a4c19fe0ec38b196df8dc8b059ac2345) mgmt: Fix smp_bt.c build

Kernel (25):

- [110b8e42](https://github.com/zephyrproject-rtos/zephyr/commit/110b8e42ff5d718d26801d260559456f3d083979) kernel: Add k_thread_foreach API
- [149a3296](https://github.com/zephyrproject-rtos/zephyr/commit/149a3296ab0f510cf7699ebd846c077d6fce9980) kernel: Deprecate k_call_stacks_analyze() API
- [8618716c](https://github.com/zephyrproject-rtos/zephyr/commit/8618716c681c6ae619b2cf81033df2bac681c1d9) kernel: Cmake: Add \__ZEPHYR_SUPERVISOR__ macro for kernel files.
- [d70196ba](https://github.com/zephyrproject-rtos/zephyr/commit/d70196ba875eb0d33a8a1937787190e9ce21a76c) linker-defs: Increase the number of kernel objects
- [5133cf56](https://github.com/zephyrproject-rtos/zephyr/commit/5133cf56aa6db75daa47f80a2d3cc4a247f84dae) kernel: thread: Move out the function _thread_entry() to lib
- [577d5ddb](https://github.com/zephyrproject-rtos/zephyr/commit/577d5ddba4b5517bce7c14163aad9c8b41fd108b) userspace: fix kobj detection declared extern
- [a2480bd4](https://github.com/zephyrproject-rtos/zephyr/commit/a2480bd472e2d7f74d13652ea5fbbaeb23653ef6) mempool: add API for malloc semantics
- [e9cfc54d](https://github.com/zephyrproject-rtos/zephyr/commit/e9cfc54d00bb469ec7eefd43ffaec410446a094e) kernel: remove k_object_access_revoke() as syscall
- [337e7433](https://github.com/zephyrproject-rtos/zephyr/commit/337e74334c35cafe582ce971ab7ced6f02b83a77) userspace: automatic resource release framework
- [92e5bd74](https://github.com/zephyrproject-rtos/zephyr/commit/92e5bd7473318ae05d83bad506cd02918f5874d2) kernel: internal APIs for thread resource pools
- [97bf001f](https://github.com/zephyrproject-rtos/zephyr/commit/97bf001f11498dcc07b4b1ab2f0df31a47695245) userspace: get dynamic objs from thread rsrc pools
- [44fe8122](https://github.com/zephyrproject-rtos/zephyr/commit/44fe81228df0cfdfe6e43a84227d727fef00d57c) kernel: pipes: add k_pipe_alloc_init()
- [0fe789ff](https://github.com/zephyrproject-rtos/zephyr/commit/0fe789ff2ea89b8d9b847b9d6bceae84d3beb144) kernel: add k_msgq_alloc_init()
- [f3bee951](https://github.com/zephyrproject-rtos/zephyr/commit/f3bee951b1d5944492db70e26c3e03cd1be1c645) kernel: stacks: add k_stack_alloc() init
- [47fa8eb9](https://github.com/zephyrproject-rtos/zephyr/commit/47fa8eb98ccd39ec48c8cc55f1f10f2589dd50c1) userspace: generate list of kernel object sizes
- [85699f7c](https://github.com/zephyrproject-rtos/zephyr/commit/85699f7c6fb114a4650a46e9efe227a05a0f63e5) kernel: Fix compile warning with _impl_k_object_alloc
- [2b9b4b2c](https://github.com/zephyrproject-rtos/zephyr/commit/2b9b4b2cf71e5c7d3620a713cae2a92c248649d2) k_queue: allow user mode access via allocators
- [8345e5eb](https://github.com/zephyrproject-rtos/zephyr/commit/8345e5ebf0008074fb15a5cd4f6c592b9357b6b7) syscalls: remove policy from handler checks
- [3772f771](https://github.com/zephyrproject-rtos/zephyr/commit/3772f77119464dcc7d76072079dae646c9ddddf6) k_poll: expose to user mode
- [4ca0e070](https://github.com/zephyrproject-rtos/zephyr/commit/4ca0e07088a1c8e08bff3e5ab7dc61e449d5c094) kernel: Add _unpend_all convenience wrapper to scheduler API
- [ccf3bf7e](https://github.com/zephyrproject-rtos/zephyr/commit/ccf3bf7ed34bf425e923697a581ea8f191b4b3b9) kernel: Fix sloppy wait queue API
- [9666c30d](https://github.com/zephyrproject-rtos/zephyr/commit/9666c30d5fb64245d2ebfbe2a967957a75efc401) kernel: mem_slab: Reschedule in k_mem_slab_free only when necessary.
- [c0ba11b2](https://github.com/zephyrproject-rtos/zephyr/commit/c0ba11b281d65c85dae1829fd9532decd3de8046) kernel: Don't _arch_switch() to yourself
- [1acd8c29](https://github.com/zephyrproject-rtos/zephyr/commit/1acd8c2996c3a1ae0691247deff8c32519307f17) kernel: Scheduler rewrite
- [3ce9c84b](https://github.com/zephyrproject-rtos/zephyr/commit/3ce9c84ba85c7c3ff5b3a4e941f93e25f0a6bb4f) kernel: Wait queues aren't dlists anymore

Libraries (11):

- [bcdfa76f](https://github.com/zephyrproject-rtos/zephyr/commit/bcdfa76ff387a70d3b47b309917b0e6598287baf) lib: posix: Fix pthread_attr_init() return code
- [2514f3c8](https://github.com/zephyrproject-rtos/zephyr/commit/2514f3c837260a946e497bcc7f0bd317fd4a5b2a) libc: minimal: fix fwrite()
- [ba240502](https://github.com/zephyrproject-rtos/zephyr/commit/ba2405023b7261f7dbbad9e2ebd8c00959cb638a) lib: rbtree: Add RB_FOR_EACH macro for iterative enumeration
- [eb0aaca6](https://github.com/zephyrproject-rtos/zephyr/commit/eb0aaca64d017fad306b040b871e3c0d1b8d6c71) lib: posix: Add Posix Style File System API support
- [eb8ba696](https://github.com/zephyrproject-rtos/zephyr/commit/eb8ba696d284fed758b503627dac8e572c7cdd8b) lib: posix: Implement posix mutex APIs
- [4e3d99ed](https://github.com/zephyrproject-rtos/zephyr/commit/4e3d99ed7e5a3c0b7bc3cc902718751df781324f) lib: posix: Use default attribute for mutex
- [0f1d30aa](https://github.com/zephyrproject-rtos/zephyr/commit/0f1d30aa672db47f9b6be185204f64c7b47ae559) lib: posix: Do not redefine PATH_MAX in unistd.h
- [d33b49d4](https://github.com/zephyrproject-rtos/zephyr/commit/d33b49d4a38f353cd73d33d96ef0837a046a7563) lib/rbtree: Fix crash condition with empty trees and rb_min/max()
- [6040bf77](https://github.com/zephyrproject-rtos/zephyr/commit/6040bf77739444ec1380ee0869f096408de8d45f) lib/rbtree: Fix & document insert comparison order
- [12d6329e](https://github.com/zephyrproject-rtos/zephyr/commit/12d6329e4a7ebd8dba919f9a7b3d0aee765c3452) lib/rbtree:  Add RB_FOR_EACH_CONTAINER()
- [f4b6daff](https://github.com/zephyrproject-rtos/zephyr/commit/f4b6daff4be4eb2f29de867ecccf10b454f15d6b) lib/posix: Port wait_q usage to new API

Maintainers (2):

- [8b29cb84](https://github.com/zephyrproject-rtos/zephyr/commit/8b29cb84abdb429aa670038ab525b792823c57eb) CODEOWNERS: fix path syntax
- [a631e1a1](https://github.com/zephyrproject-rtos/zephyr/commit/a631e1a1e4fdc5173972dd28db5fd87d3537d305) CODEOWNERS: Fix nxp related directories

Miscellaneous (4):

- [62bff616](https://github.com/zephyrproject-rtos/zephyr/commit/62bff616c27aa0ea1a7cfacde4ca249295f55347) subsys: shell: Remove deprcated k_call_stacks_analyze API
- [79215adc](https://github.com/zephyrproject-rtos/zephyr/commit/79215adceb0b0a1abb5f4d9660ace5c46bd69ee3) list_gen: slist: mark some APIs are private
- [c8010e48](https://github.com/zephyrproject-rtos/zephyr/commit/c8010e487751cadff7f7edda5348faf1dc72127e) sflist: slist-alike that stores flags
- [e7509c17](https://github.com/zephyrproject-rtos/zephyr/commit/e7509c17c5938b48f9ad4b7ae78199bb0faa6113) release: Move version to 1.12.0-rc1

Networking (31):

- [9e09e2a1](https://github.com/zephyrproject-rtos/zephyr/commit/9e09e2a1b7d74f163ea07aa7dfe8953e02a0b0dc) OpenThread: Change SETTINGS_CONFIG_PAGE_SIZE to target specific value
- [2c987298](https://github.com/zephyrproject-rtos/zephyr/commit/2c987298f262e9cb3f9f2c1e96b18fff994d1695) net: tcp: expose some TCP helper functions
- [8a21d386](https://github.com/zephyrproject-rtos/zephyr/commit/8a21d3862bef6c283cc9940f9601328eefd6c705) net: app: fix build warning in _net_app_ssl_mainloop()
- [e50cacb3](https://github.com/zephyrproject-rtos/zephyr/commit/e50cacb356e355bdb80a6bfcdfdfc3f85649e3f5) net: app: Select proper source IPv4 address in client
- [0db9af5a](https://github.com/zephyrproject-rtos/zephyr/commit/0db9af5a284f0518d1569c603488943a168d139e) net: lwm2m: return error from lwm2m_engine_get_* functions
- [0d67f6a7](https://github.com/zephyrproject-rtos/zephyr/commit/0d67f6a78d0677c97e08324b2e6eca303c3647f7) net: lwm2m: introduce FLAG_OPTIONAL to denote optional resources
- [4fb16db2](https://github.com/zephyrproject-rtos/zephyr/commit/4fb16db26dd65118838f5dc4877af5a946ba4175) net: lwm2m: mark OPTIONAL resources for LwM2M Security
- [9506b427](https://github.com/zephyrproject-rtos/zephyr/commit/9506b427b7a8f91332d1ee8bfb2fd37f4702c14b) net: lwm2m: mark OPTIONAL resources for LwM2M Server
- [12901396](https://github.com/zephyrproject-rtos/zephyr/commit/1290139626e3ae1ebd06703755527e073767d06b) net: lwm2m: mark OPTIONAL resources for LwM2M Device
- [7a1024e5](https://github.com/zephyrproject-rtos/zephyr/commit/7a1024e5c83c52ca5a9998f7a2d4a94939de69b0) net: lwm2m: mark OPTIONAL resources for LwM2M Firmware Update
- [a5bdbc17](https://github.com/zephyrproject-rtos/zephyr/commit/a5bdbc17517982a08c95aaac90c7fc88e6c2e7f6) net: lwm2m: mark OPTIONAL resources for IPSO Light Control
- [b6774f0e](https://github.com/zephyrproject-rtos/zephyr/commit/b6774f0eea502358ec6e58dc94bf7042c5e657d1) net: lwm2m: mark OPTIONAL resources for IPSO Temperature
- [07ec5567](https://github.com/zephyrproject-rtos/zephyr/commit/07ec5567fcc4ba72b6bd563949fb743852c3b333) net: lwm2m: remove unused OBJ_FIELD_MULTI_DATA macro
- [bb98d876](https://github.com/zephyrproject-rtos/zephyr/commit/bb98d8766a235c4fa008253168a70333ac9d4748) net: coap: add COAP_INIT_ACK_TIMEOUT_MS setting
- [d07391d3](https://github.com/zephyrproject-rtos/zephyr/commit/d07391d3868966c8fddb74f00d2286e9dbbd609d) net: coap: clear more fields in coap_reply_clear()
- [89f57c22](https://github.com/zephyrproject-rtos/zephyr/commit/89f57c225ac3f1da6238283af59138518fffca0b) net: tcp: Define single config option for TIME_WAIT delay
- [d6dfde36](https://github.com/zephyrproject-rtos/zephyr/commit/d6dfde36c4ca5fdee9c8cc41df85178e744b0d17) net/ethernet: Fix mac address setting through ethernet mgmt
- [49bd1e9c](https://github.com/zephyrproject-rtos/zephyr/commit/49bd1e9c6f278d70a18fec8234dd645a4ae85d67) ieee802154: Add support for filtering source short/ieee addresses
- [69e69b7f](https://github.com/zephyrproject-rtos/zephyr/commit/69e69b7f935a03f702e85b0d9fd6703aeff4ad71) ieee802154: Add support for energy detection scan on driver API
- [cc8fab8d](https://github.com/zephyrproject-rtos/zephyr/commit/cc8fab8ddb86dfcc88ad087048b9d403a95fd4f9) net: app: client: fix local port byte-order in bind_local()
- [9cbe86f8](https://github.com/zephyrproject-rtos/zephyr/commit/9cbe86f8328ea480172f780a19b6f802f80ca212) net: app: client: handle client_addr port in net_app_init_client()
- [a0210343](https://github.com/zephyrproject-rtos/zephyr/commit/a021034327fc98ac31bc1357ea1581d48be65632) net: lwm2m: honor CONFIG_LWM2M_LOCAL_PORT when starting client
- [21fdf536](https://github.com/zephyrproject-rtos/zephyr/commit/21fdf536baf5c54bfd242c8293983625e4d10d9f) net: lwm2m: default LWM2M_LOCAL_PORT to 0 (random)
- [a58781f5](https://github.com/zephyrproject-rtos/zephyr/commit/a58781f50421af822813a3edfee60a48e5a918c6) net: lwm2m: add LWM2M_FIRMWARE_UPDATE_PULL_LOCAL_PORT setting
- [198b3586](https://github.com/zephyrproject-rtos/zephyr/commit/198b358638ccd017c6d5064a1db2800936cdcbf7) net: lwm2m: simplify registration client
- [68ef8f06](https://github.com/zephyrproject-rtos/zephyr/commit/68ef8f06a5082ee3baa4128c4fe8e84832f22a57) net: conn: Drop invalid packet
- [3c09bee9](https://github.com/zephyrproject-rtos/zephyr/commit/3c09bee9210c634ce06630a9394e461a8e47c274) net: app: server: Fix compile error if TCP is disabled
- [c0af4de7](https://github.com/zephyrproject-rtos/zephyr/commit/c0af4de7b3c3cec4c2f632493ad12e9e50a55b73) net: openthread: Bump OpenThread commit to db4759cc
- [5f534dc6](https://github.com/zephyrproject-rtos/zephyr/commit/5f534dc6de778d5bd65f7d22d004a4228e9748b9) net: openthread: Add function for getting current radio channel
- [38866179](https://github.com/zephyrproject-rtos/zephyr/commit/38866179a5d0039c0da17bd9522c116d67af7490) net: icmpv6: Fix error condition
- [3a6944d8](https://github.com/zephyrproject-rtos/zephyr/commit/3a6944d81f350417daa9fefa9000b7ebfa4bd638) net: icmpv6: replace NET_ASSERT with NET_ERR

Samples (29):

- [994be4dc](https://github.com/zephyrproject-rtos/zephyr/commit/994be4dc4b0a0f871c3402c3220adc2b2321a666) samples: net: dns: Fix compile error
- [3df9201e](https://github.com/zephyrproject-rtos/zephyr/commit/3df9201ef33d09394e961df184ff628e49ce3a8d) samples: net: dns_resolver: Add config options for tests
- [677262e9](https://github.com/zephyrproject-rtos/zephyr/commit/677262e9f6b2e11cdbdb236d1eeb15f13bf4185b) samples: net: lwm2m: adjust BT RX buffer count /sizes for BT
- [769c3a8b](https://github.com/zephyrproject-rtos/zephyr/commit/769c3a8bf2b2767817f07cdb252ce1c111969781) samples: boards: Remove deprcated k_call_stacks_analyze API
- [ef4cb15f](https://github.com/zephyrproject-rtos/zephyr/commit/ef4cb15f0449db386f2681993c5bac668f535e91) samples: subsys: debug: sysview: Adapt k_thread_foreach API
- [d257b946](https://github.com/zephyrproject-rtos/zephyr/commit/d257b946e35068a9d69fc5b66a924087552be926) samples: net: mbedtls_sslclient: Fix prj.conf file
- [16a8a309](https://github.com/zephyrproject-rtos/zephyr/commit/16a8a309a3f8902af9100251c5a0885d2a0fcf67) samples: sockets: dumb_http_server: Improve error handling
- [b56b1436](https://github.com/zephyrproject-rtos/zephyr/commit/b56b1436ed6c1ba355ef13a45c665b06cb9abd58) samples: sockets: Make more errors fatal
- [3b8c6c70](https://github.com/zephyrproject-rtos/zephyr/commit/3b8c6c70e642cc73cb73b5dac59350179bf7e54c) samples: usb: webusb: Add MS-OS descriptors for compatible IDs
- [6164c60c](https://github.com/zephyrproject-rtos/zephyr/commit/6164c60ce215535376d9d6650923f05e4cc5abc3) samples: usb: webusb: Add MS OS v1.0 descriptors too
- [092f7160](https://github.com/zephyrproject-rtos/zephyr/commit/092f716020ffcd700416c300b8745908a9b7e13a) samples: sockets: dumb_http_server: Disable TIME_WAIT delay
- [6cadd380](https://github.com/zephyrproject-rtos/zephyr/commit/6cadd380b75aadb163327227edc3a3b9c89c7972) samples: net: Fix echo_server reply packet preparation
- [b2fa9ada](https://github.com/zephyrproject-rtos/zephyr/commit/b2fa9ada5ecbcc9230812e4e568e441d930d7953) samples: smp_svr: Rename conf file
- [5ebf1a2c](https://github.com/zephyrproject-rtos/zephyr/commit/5ebf1a2c14de07ca1d19ca2c66907e7a0b2487b9) samples: smp_svr: Add sample.yaml
- [ddc30c8e](https://github.com/zephyrproject-rtos/zephyr/commit/ddc30c8e40fb6cfc25bd8667eae00db99d6bdb5f) samples: leds_demo: depend on netif and gpio
- [9c113d29](https://github.com/zephyrproject-rtos/zephyr/commit/9c113d29f519b13360cbc310a5d299ff3f4e872a) samples: drivers: crypto: Print output length for all operations
- [bdfbbfee](https://github.com/zephyrproject-rtos/zephyr/commit/bdfbbfee3fa05ddc553d0075d174b0236af9615f) samples: sensor: vl53l0x: trivial README.rst fix
- [7588680a](https://github.com/zephyrproject-rtos/zephyr/commit/7588680afb923075331adedecc64c87640495627) samples: olimex_stm32_e407: ccm: trivial README.rst fix
- [554999d3](https://github.com/zephyrproject-rtos/zephyr/commit/554999d32039d62e5555402d907d40df3d272d36) samples/net: Add a simple sample to run wifi shell module
- [45156f6e](https://github.com/zephyrproject-rtos/zephyr/commit/45156f6e717957874fc3cb7d8ff1b3c28e7fdbdd) samples: cdc_acm: enable sanitycheck for Kinetis boards
- [08795cf2](https://github.com/zephyrproject-rtos/zephyr/commit/08795cf27d32c906aaeef805a9c07cefdacae89c) samples: net: rpl: Simple RPL border router application
- [2ef50442](https://github.com/zephyrproject-rtos/zephyr/commit/2ef5044277384f5ed76a256e319fbf2604560c26) samples: net: rpl: Enhance RPL border router application
- [26ebb918](https://github.com/zephyrproject-rtos/zephyr/commit/26ebb918f704077b03fa212e9c3ed8f627cc66c3) samples: net: rpl: Add observer support to node application
- [37b7caa6](https://github.com/zephyrproject-rtos/zephyr/commit/37b7caa6bbdd021997e66f2b0bb5ec84cd86646e) sample: Add MCUX IPM sample application
- [0b76b128](https://github.com/zephyrproject-rtos/zephyr/commit/0b76b12837deb995077bf026de01a6e9a9e50dfe) samples: sockets: big_http_download: Update for DHCPv4 support.
- [02bb83be](https://github.com/zephyrproject-rtos/zephyr/commit/02bb83bec285e411799333cf2c12231e332099f2) samples/boards: Add ArgonKey test
- [ca9a98e6](https://github.com/zephyrproject-rtos/zephyr/commit/ca9a98e6e2589503051a3eb7d2192037435c9fd9) samples/subsys/console: Remove unused tx_sem semaphore
- [5eb88298](https://github.com/zephyrproject-rtos/zephyr/commit/5eb882980dcb9322258351c79edb077b9a1db83d) sample: add OpenAMP sample application
- [2de9f2f8](https://github.com/zephyrproject-rtos/zephyr/commit/2de9f2f8fd17385f545effd007bdaf3da8e97dbe) samples: can: Add example code for CAN driver

Scripts (21):

- [e307ba34](https://github.com/zephyrproject-rtos/zephyr/commit/e307ba340c332595912e0365ca846fb8c72e8cd6) kconfiglib: Record which MenuNode has each property
- [6d4d8ce0](https://github.com/zephyrproject-rtos/zephyr/commit/6d4d8ce026e4ff0a382518dd67f27ab919db1a25) menuconfig: Show properties on the correct symbol definition
- [b58cbfd6](https://github.com/zephyrproject-rtos/zephyr/commit/b58cbfd6ab20d083eeda36cdc2c9b104089b4c2b) menuconfig: Add .config loading dialog
- [2715a011](https://github.com/zephyrproject-rtos/zephyr/commit/2715a011eeb565ce7281e5fadc029bba08c0468b) scripts: runner: add \__str__ for RunnerCaps
- [1430e0c7](https://github.com/zephyrproject-rtos/zephyr/commit/1430e0c752fb21fb6ff2ed936daa8974adf58ebe) scripts: runner: core: don't print unless self.debug
- [b6af8eb9](https://github.com/zephyrproject-rtos/zephyr/commit/b6af8eb93219fd9287006d02e8580e1cd916536d) scripts: create meta-tool package, "west"
- [641ae471](https://github.com/zephyrproject-rtos/zephyr/commit/641ae471a7691828d5f5ae92c04389508ee4d1db) scripts: west: add cmake utility module
- [9e7d16ac](https://github.com/zephyrproject-rtos/zephyr/commit/9e7d16acd9b20e15f69e47ef239ff4bc7149d220) scripts: make runner a west subpackage
- [3919e70e](https://github.com/zephyrproject-rtos/zephyr/commit/3919e70e0914c0817cd6d9be062be00f81f60c05) scripts: west: remove redundant quote_sh_list definition
- [4a354e89](https://github.com/zephyrproject-rtos/zephyr/commit/4a354e891dbff815428a71a24f8de806d7540440) scripts: west: runner: add get_runner_cls()
- [b611e5b1](https://github.com/zephyrproject-rtos/zephyr/commit/b611e5b1ea0801c75c3bc98c8915938985fa8436) scripts: west: add flash, debug, debugserver commands
- [fbd2e92b](https://github.com/zephyrproject-rtos/zephyr/commit/fbd2e92b42e6698111759eb1921b4271029fca70) scripts: remove zephyr_flash_debug.py
- [367c0bab](https://github.com/zephyrproject-rtos/zephyr/commit/367c0bab6d6da3e333ccfe75bc390b468009c763) scripts: west: remove command from runner arguments
- [a81f0559](https://github.com/zephyrproject-rtos/zephyr/commit/a81f0559c304aaed01f487119cf012ff692256a4) scripts: west: trivial fix to runner comments
- [bc587d92](https://github.com/zephyrproject-rtos/zephyr/commit/bc587d92629ef1079fd4e4e4674f4ce03fc3be82) scripts: west: add subprocess.call wrapper to runner classes
- [a9aa250b](https://github.com/zephyrproject-rtos/zephyr/commit/a9aa250b88b1d8ad9339943408c891f96b78df21) scripts: west: clean up intel_s1000 runner
- [bc7b1c59](https://github.com/zephyrproject-rtos/zephyr/commit/bc7b1c595ed4090be6d80859a01a0bb372ae030c) scripts: west: fix some intel_s1000 runner issues
- [c9dfbfaf](https://github.com/zephyrproject-rtos/zephyr/commit/c9dfbfaf021f9fdc48912ee6a2c3b90ac366b16e) scripts: west: convert runner to use log module
- [5317f76d](https://github.com/zephyrproject-rtos/zephyr/commit/5317f76dec7de2c85c8b9268c9947920724117e9) scripts: west: introduce common runner configuration
- [68e5933e](https://github.com/zephyrproject-rtos/zephyr/commit/68e5933e971f9b4fe5af1539aa94e3c8aae3b910) scripts: west: add build directory to runner configuration
- [38e8f06f](https://github.com/zephyrproject-rtos/zephyr/commit/38e8f06fdb1cc68d1f1bbb551f93e538c510e57c) scripts: west: add context-sensitive runner help

Storage (2):

- [b1e45b41](https://github.com/zephyrproject-rtos/zephyr/commit/b1e45b413ef24b438ebc379b6ccfc59e11247dc0) subsys: fs: Add Non Volatile Storage (NVS) for zephyr
- [72050f46](https://github.com/zephyrproject-rtos/zephyr/commit/72050f46bc3821dc266168227a91bca0bda8b11c) settings: Make it safe to call settings_subsys_init() multiple times

Testing (19):

- [bb717783](https://github.com/zephyrproject-rtos/zephyr/commit/bb7177830d4e6d2fdbf77185c503e2213e764e67) tests: kernel: profiling: Add test for k_thread_foreach API
- [43775402](https://github.com/zephyrproject-rtos/zephyr/commit/43775402a9b3f1c4d2ee398b94e46d8828339bea) tests: Kconfig: Added a new Kconfig for qemu_x86
- [2db1c080](https://github.com/zephyrproject-rtos/zephyr/commit/2db1c080d8d84c2fe47f9cb43caad1a377ea5e6d) tests: drivers: build_all: Ensure correct builds.
- [c07ec386](https://github.com/zephyrproject-rtos/zephyr/commit/c07ec386bf7585453c3711eecee6b2175d949f27) tests: subsys: fs: Enable proper configuration for qemu_x86.
- [e2db76c9](https://github.com/zephyrproject-rtos/zephyr/commit/e2db76c9cc2edfb5564ebb2c70ac8f4649ca7e57) tests/net: Fix ethernet mgmt mac change test
- [a1fc3969](https://github.com/zephyrproject-rtos/zephyr/commit/a1fc3969fc993c6a34901ab414d0c126c0f58c83) tests: common: fixed pointer formatting
- [36eb4dd0](https://github.com/zephyrproject-rtos/zephyr/commit/36eb4dd0211587028c80e5cd50826022287cc9d8) tests: samples: exclude usb_kw24d512 from wpanusb sample
- [eeeffcaf](https://github.com/zephyrproject-rtos/zephyr/commit/eeeffcaf58b8b4fc7eb5d075cf5835a5e8bceb35) tests: rtc: Adjust RTC samples tests for NXP RTC
- [fb74866c](https://github.com/zephyrproject-rtos/zephyr/commit/fb74866c2d01523e8a4a9af49eac20e511fa708b) tests: watchdog: Update test to work with the mcux watchdog driver
- [3f43fc77](https://github.com/zephyrproject-rtos/zephyr/commit/3f43fc7770453994054d16498727267638038309) tests: watchdog: Replace platform whitelists with depends_on
- [c18a1132](https://github.com/zephyrproject-rtos/zephyr/commit/c18a11327b5614a12f1a7a56b1b7b8ff94dc3846) HACK: tests: disable output disasm for 1 ARC test
- [ad6b8904](https://github.com/zephyrproject-rtos/zephyr/commit/ad6b8904713e6d436c1a4ce1bc83bdba5e9fcc3b) tests: kernel: Add description for test cases
- [55cf6dd7](https://github.com/zephyrproject-rtos/zephyr/commit/55cf6dd76c567657ca11733c269f07e9b61506ab) tests: posix: Add test for Posix File System API's
- [8b31cdad](https://github.com/zephyrproject-rtos/zephyr/commit/8b31cdad16e239ac58968310caf7450859fcf77b) tests: kernel: Add description for test cases
- [c1200cd3](https://github.com/zephyrproject-rtos/zephyr/commit/c1200cd3e2aa5168429ac6728c0f293eb9ebe72c) tests: posix: fs: Add description for test cases
- [7393cb24](https://github.com/zephyrproject-rtos/zephyr/commit/7393cb2478874bc4ffb339f320a8f72bd2799460) tests: threads: Add test case to verify k_wakeup()
- [f0eaa8e8](https://github.com/zephyrproject-rtos/zephyr/commit/f0eaa8e87904f972fad23a38abde9cfd94e402ea) tests: mutex: Add test case to test mutex API
- [5e87c08a](https://github.com/zephyrproject-rtos/zephyr/commit/5e87c08a391ed4d755218bc3dfcb1842bf05a507) tests: posix: Increase sram size
- [0c80ee08](https://github.com/zephyrproject-rtos/zephyr/commit/0c80ee083183fc34ddde17b2fadb6f9f88c35d6d) tests/kernel: Bump stack sizes for a few tests on qemu_x86

