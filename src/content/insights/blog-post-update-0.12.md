+++
title = "microPlatform update 0.12"
date = "2018-03-27"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.12

The Zephyr tree incorporates significant changes from the v1.12
merge window, including virtual file system support, websockets,
network logging, and more.

The MCUboot tree includes a single new feature, allowing users to
set device tree overlays.

The zmp tool includes several new features, which are taken
advantage of in the reference applications.


## Linux microPlatform changes for 0.12

No changes have gone into the LMP since 0.11.
<!--more-->
# Zephyr microPlatform

## Summary

The Zephyr tree incorporates significant changes from the v1.12
merge window, including virtual file system support, websockets,
network logging, and more.

The MCUboot tree includes a single new feature, allowing users to
set device tree overlays.

The zmp tool includes several new features, which are taken
advantage of in the reference applications.

## Highlights

- Zephyr tree from the v1.12 merge window
- OSF samples with increased security and improved MCUboot integration
- Several zmp tool and reference application improvements
- Rewritten history, commit 33de222e ("[OSF temphack] temporary hack for mcuboot") has zero diff from 0.11 update

## Components


### MCUboot


#### Features

##### User device tree overlays: 
- It is now possible for users to specify their own
device tree overlays when building MCUboot.


#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### Virtual File System support: 
- Zephyr now has a virtual file system (VFS) switch,
similar in spirit to other operating systems. This
also allows supporting multiple file systems in a
single Zephyr configuration.


##### Network-backed syslog logging: 
- Zephyr's logging subsystem now support a syslog-
compliant network backend. This logging protocol is
standardized in RFC 5424 and RFC 5426.


##### Websockets support: 
- The networking subsystem now has a net-app based
websocket library. Initial support is provided for the
server role, with optional TLS. Sample applications
are provided in samples/net/ws_echo_server and
samples/net/ws_console.


##### ARM CMSIS header changes: 
- Some ARM CMSIS headers were cleaned up and removed,
which will break applications using removed APIs.


##### nRF5 to nRF global rename: 
- The nRF5 SoC family support was globally renamed to
nRF, to accomodate incoming SoC support for Nordic
targets that are not part of the nRF5 family. This may
break applications using Kconfig or other names that
were affected.


##### Elixir indexing for Zepyr: 
- Though not strictly a Zephyr feature, there is now an
Elixir code indexing server available for current and
older Zephyr versions available from Bootlin at
https://elixir.bootlin.com/zephyr/latest/source.


##### base64 library: 
- A base64 library was added to Zephyr's core; it was
imported from the mbedTLS implementation. The mgmt
subsystem and websockets support use this new base64
library.


##### New STM support and features: 
- New architecture-related features include support for
STM32F051X8, STM32L073xZ, STM32F070XB, and STM32F412CG
MCUs, as well as stm32l0 and stm32f446 SoCs.

Clock control, GPIO, interrupts, and pinmux drivers
were merged for stm32l0x.


##### New ARM v8M features: 
- The effort to support ARM v8M continues with
additional fault handling and logging for processor
states present in those SoCs.


##### I2C support in device tree: 
- x86 and nRF SoC support for I2C now comes from device
tree, with board support for x86 on the galileo,
curie, quark_x1000, and quark_d200 boards, and nRF
support on bbc_microbit, nrf51_vbluno51,
nrf52_vbluno52.


##### ARC device tree support: 
- The ARC architecture now supports DTS, with nodes
added for UARTs.


##### Stack growth configuration knob: 
- Support for configuring the direction of stack growth
via Kconfig was added.


##### Entropy driver for nRF: 
- The Bluetooth-specific LL randomness driver was ported
to the Zephyr entropy framework. The Bluetooth core
now uses the entropy subsystem instead of this random
driver.


##### Ethernet enabled by default for sam_e70_explained: 
- The sam_e70_explained board now enables Ethernet by
default.


##### Ethernet over USB by default for nucleo_f412zg: 
- The nucleo_f412zg board now uses ethernet over USB as
its default network interface.


##### Ethernet driver for POSIX target: 
- The native POSIX target now has an Ethernet driver. A
sample is provided in samples/net/eth_native_posix.


##### USB for Arduino Zero, Trinket M0: 
- USB support was enabled on the Arduino Zero and
Trinket M0 boards.


##### Device tree for USB for nrf52840_pca10056: 
- Device-tree based USB support was added for
nrf52840_pca10056.


##### SPI2 for olimexino_stm32: 
- SPI2 support was enabled on the olimexino_stm32 board.


##### New boards: 
- Support was added for the Adafruit Feather M0 Basic
Proto, nucleo-f446re, NUCLEO-L073RZ, nucleo_f070rb,
STM32F0DISCOVERY, Waveshare BLE400, 96Boards Argonkey,
Olimex stm32-h407, and Dragino boards.


##### New Atmel SAM peripheral drivers: 
- USB, GPIO, and SPI device drivers were merged for
Atmel SAM0.

An interrupt-driven UART driver was added for SAM E70.


##### Semtech SX1509B I2C-based GPIO extender: 
- A GPIO driver was merged for Semtech SX1509B I2C-based
GPIO chips.


##### I2C driver core cleanups: 
- Numerous cleanups and improvements were merged to the
I2C driver core and individual drivers.


##### Scheduler API cleanups: 
- Cleanups and unifications were merged to the core
scheduler APIs.


##### New sockets features: 
- Improvements to the the BSD-like sockets API include
MSG_DONTWAIT and MSG_PEEK support in recvfrom,
MSG_DONTWAIT in sendto, a freeaddrinfo implementation,
and empty service support in getaddrinfo.


##### Stack unwind on x86: 
- x86 targets now unwind the stack on fatal errors.


#### Bugs

##### MPS2 cleanup: 
- The Arm MPS2 SoC support was cleaned up.



##### POSIX semaphore fixes: 
- POSIX target semaphore support received fixes.



##### Bluetooth Mesh fixes: 
- Bluetooth Mesh fixes for cfg_cli were merged,
addressing a null pointer dereference and a race
condition.



##### Arduino Zero SPI fix: 
- The SPI pinmux was fixed on Arduino Zero.



##### nRF USB fixes: 
- Fixes to the nRF USB driver were merged affecting
isochronous endpoints and CDC-ACM OUT endpoints.



##### Kernel memory partitions fix: 
- Kernel memory partitions are now correctly placed in
kernel memory when building with userspace support.



##### Scheduler undefined behavior fix: 
- A bug fix in the scheduler avoids undefined integer
shifting behavior.



##### Networking fixes: 
- Networking fixes include net-app debug level checks,
better handling for malformed ICMPv6 echo requests, a
compilation fix if the neighbor cache is disabled, an
IPv6 memory leak caused by echo requests,



### hawkBit and MQTT sample application


#### Features

##### CONFIG_BOOTLOADER_MCUBOOT support: 
- Rather than setting MCUboot-related configuration
options manually, the application now makes use of a
configuration knob provided by upstream to request
linking for loading by MCUboot.


#### Bugs

##### Entropy driver support: 
- The sample application no longer uses the insecure
TEST_RANDOM_GENERATOR on nRF targets, now that they
support a proper entropy driver. This allows network
communication protocols to use the hardware true
random number generator.



### LWM2M sample application


#### Features

##### CONFIG_BOOTLOADER_MCUBOOT support: 
- Rather than setting MCUboot-related configuration
options manually, the application now makes use of a
configuration knob provided by upstream to request
linking for loading by MCUboot.


#### Bugs

##### Entropy driver support: 
- The sample application no longer uses the insecure
TEST_RANDOM_GENERATOR on nRF targets, now that they
support a proper entropy driver. This allows network
communication protocols to use the hardware true
random number generator.


# Linux microPlatform

## Summary

No changes have gone into the LMP since 0.11.
## Highlights

- No changes have gone into the LMP since 0.11.

## Components


