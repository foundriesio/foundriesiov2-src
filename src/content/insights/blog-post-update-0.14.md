+++
title = "microPlatform update 0.14"
date = "2018-04-18"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.14

Zephyr updates from 0.12 cycle, no MCUboot changes


## Linux microPlatform changes for 0.14

OSF Unified Linux Kernel updated to the 4.14.33 stable release.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr updates from 0.12 cycle, no MCUboot changes

## Highlights

- Zephyr changes from the v1.12 development cycle
- No MCUboot or sample application changes

## Components


### MCUboot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### SPI API rework and finalization: 
- The SPI API (in include/spi.h) has been re-worked and
finalized. All in-tree users were upgraded to the new
API. The old SPI API, and all of its implementations,
have been removed. Out of tree uses of the old SPI API
will need updates. A summary of the API changes is
available from the OSF blog:
https://opensourcefoundries.com/blog/2018/04/11/zephyr-news-20180411/#important-changes


##### VLAN for Ethernet: 
- VLAN support was added for Ethernet network
interfaces. Initial support is provided for mcux,
native POSIX, and Atmel E70. The SLIP driver also has
VLAN support.

New net shell commands "net vlan", "net vlan add", and
"net vlan del" were added to query and manipulate the
VLAN configuration.

A new sample application, samples/net/vlan, was added,
which can be used to set VLAN tags for ethernet
interfaces.

As part of these and other network changes, the
ethernet files now live in their own directory,
net/ip/l2/ethernet.


##### Red/black trees: 
- A new red/black balanced binary tree implementation
was added; the API is available in include/misc/rb.h.
Like the linked list types, the structure is
*intrusive*: red-black tree nodes are meant to be
embedded in another structure, which contains the user
data associated with that node.  Code size compared to
a doubly linked list on most architectures is
approximately an additional 2-2.5 KB.


##### Completion of DTS support for I2C and SPI on STM32: 
- All STM32-based boards now use device tree for I2C and
SPI peripherals.


##### Bluetooth generalizations: 
- Continuing the effort to generalize the core Bluetooth
subsystem across SoCs, the Bluetooth "ticker" timing
API now includes a generic hal/ticker.h file, which
abstracts out SoC specific definitions.


##### Driver updates: 
- New driver support includes SPI on nRF52, an interrupt
in transfer callback on USB HID, USB CDC EEM support
for encapsulating Ethernet packets over a USB
transport, and GPIO triggering for the ST LSM6DSL
accelerometer and IMU.


##### Boards: 
- New boards include the SiFive HiFive1 and Nordic nRF52
Thingy:52 (PCA20020).  Ethernet is now enabled by
default on the sam_e70_xplained board.


##### Speeding up CI: 
- An effort is underway to reduce the amount of time
spent in CI. To that end, an additional upstream CI build slave
was added, some duplicative test coverage on qemu_x86
and qemu_cortex_m32 was eliminated, and other
optimizations were performed.


##### Boot banner changes: 
- The boot banner now prints the git version (based on
git describe) and hash, but timestamps were removed
from it by default to increase the reproducibility of
Zephyr builds.

The git version does not work properly for out of tree
Zephyr applications; details are available at https://github.com/zephyrproject-rtos/zephyr/issues/7044.


##### User mode memory pools: 
- A new memory pool implementation which is compatible
with use from user mode threads was merged; the API is
available in include/misc/mempool.h. This
implementation shares code with the in-kernel
k_mem_pool API, but avoids constraints that are
incompatible with user mode.  Memory pools are defined
at compile time with SYS_MEM_POOL_DEFINE(), and
initialized by sys_mem_pool_init(). Memory may be
allocated and freed from an initialized memory pool
with sys_mem_pool_alloc() and sys_mem_pool_free(),
respectively.


##### Network interface management: 
- Network statistics collection is now per-interface.

The network shell command "net iface" can now enable
or disable network interfaces by index.

Initial support for ethernet interface configuration
has been merged. This includes a link speed
capabilities query. An API was also merged for
changing hardware configuration; this includes link
speed, but is not limited to it.


#### Bugs

##### GPIO port H on STM32L0: 
- Support for enabling GPIO port H on STM32L0 was fixed.



##### Sub-region access on ARM MPUs: 
- Support accessing sub-region attributes on ARM MPUs
was fixed.



##### Bluetooth Mesh fixes: 
- A pair of Bluetooth mesh fixes were merged, including
a null dereference and an issue related to enabling
node identity advertising.



##### Soft float fix: 
- The behavior of the CONFIG_FP_SOFTABI option was
fixed. It now generates floating point instructions,
rather than turning them off, which it was doing
previously.



##### Temperature channel for nRF5 TEMP: 
- The temperature sensor channel for the nRF TEMP IP
block was fixed; it is now SENSOR_CHAN_DIE_TEMP.



##### k_thread_create() stack size check: 
- A fix was merged for k_thread_create(), which now
properly checks the provided stack size on systems
which enforce power of two sizes.



##### POSIX fixes: 
- POSIX fixes for pthread_cancel and timer_gettime were
merged.



##### Test fixes and cleanups: 
- Dozens of commits cleaning up and fixing the test
cases were merged as part of an ongoing effort to
standardize the test system, as tracked in
https://github.com/zephyrproject-rtos/zephyr/issues/6991.



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

OSF Unified Linux Kernel updated to the 4.14.33 stable release.

## Highlights

- OSF Unified Linux Kernel updated to 4.14.33.

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.14.33.


#### Bugs
- Not addressed in this update

### Meta Updater Layer


#### Features

##### Layer Update: 
- Added support for custom garage target version and url.
Aktualizr updated for the kRejectAll and metadata check fixes.


#### Bugs
- Not addressed in this update
