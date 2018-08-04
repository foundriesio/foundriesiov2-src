+++
title = "microPlatform update 0.17"
date = "2018-05-10"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.17

Zephyr heading towards end of v1.12 development cycle, MCUboot
heading towards 1.2.0 release, samples compatibility updates.


## Linux microPlatform changes for 0.17

No changes have gone into the LMP since 0.16.
<!--more-->
# Zephyr microPlatform

## Summary

Zephyr heading towards end of v1.12 development cycle, MCUboot
heading towards 1.2.0 release, samples compatibility updates.

## Highlights

- MCUboot's configuration system overhauled
- Zephyr with Spectre v2 mitigations, build system improvements, LED API, scheduler re-vamp, USB improvements
- Reference sample compatibility updates for upstream LED GPIO changes

## Components


### MCUboot


#### Features

##### Configuration system overhaul: 
- The bootloader's configuration system was generalized
across its ports into a single
mcuboot_config/mcuboot_config.h abstraction.
Documentation on how to specify this configuration
file was added to the porting guide (doc/PORTING.md).


#### Bugs

##### Mynewt unit tests: 
- The unit tests on the Mynewt target were fixed.



### Zephyr


#### Features

##### Retpolines on x86: 
- x86 CPUs affected by Spectre v2 now support retpolines
when invoking interrupt and exception handlers, during
thread entry, and when invoking syscall handlers.

These changes also saw the removal of the (unused)
_far_jump() and _far_call() routines.


##### LED and Button Definition Moves: 
- This continues the long-term project to move device
configuration from Kconfig to Device Tree.

LED and button definitions were removed from all STM32
board.h files, since the corresponding defines now
come from device tree. This is a breaking change, as
the old XXX_GPIO_PORT is now XXX_GPIO_CONTROLLER.
Applications which used the old names will need
updates.

NXP Kinetis SoCs were also converted to generate this
information from Device Tree. This change preserved
names, but did not include updates for the FXOS8700 or
FXAS21002 temperature sensors or the MCR20A 802.15.4
radio. Rather than break these sensors, this update
has reverted the NXP-specific conversion patches until
functionality is restored upstream.


##### Deprecated __stack macro removed: 
- The __stack macro, which was deprecated in favor of
K_STACK_DEFINE before v1.11 was released, has been
removed.


##### mbedTLS update to fix remote execution holes: 
- The mbedTLS cryptography library was updated from
version 2.7.0 to version 2.8.0, addressing CVEs
2018-0488 and 2018-0487. These are remote execution
vulnerabilities that could occur when TLS or DTLS is
in use.


##### k_thread_cancel() deprecated: 
- The k_thread_cancel() API is deprecated. Applications
should use k_thread_abort().


##### Generic storage partition rename: 
- The NFFS flash partition available on many boards,
which was previously aliased to nffs_partition, has
been renamed to storage_partition, to reflect its
general usefulness for a variety of storage systems.
Its existence is now controlled via a
CONFIG_FS_FLASH_MAP_STORAGE.

Out of tree applications using the old alias or
configuration option to access this partition will
need updates.


##### Architectures: 
- The ARC architecture now supports
CONFIG_STACK_SENTINEL, which can help diagnose stack
overflow issues.

SEGGER RTT support is now enabled on all NXP MCUs.

Support was added for Cadence's proprietary XCC
compiler toolchain for the XTensa architecture, along
with support for the intel_s1000 SoC. Judging from
these drivers, the SoC is intended for use in speech
and other audio processing. Zephyr SoC-level support
is provided for DMA, I2S, UART, GPIO, USB, and I2C,
with board support via intel_s1000_crb.


##### Boards: 
- I2C driver support was enabled for all the official
nRF5 boards provided by Nordic Semiconductor.

The bbc_microbit now supports flash partitions for
mcuboot and on-chip storage.


##### Build system: 
- A variety of improvements were merged into the build
system.

Notably, the build system now caches information
obtained from the toolchain, optimizing subsequent
invocations of cmake using the same toolchain. Factor
of two speedups have been observed when the cache is
used. A few problems have been identified and fixed up
since the initial merge, but hopefully the major
issues are resolved.

In another significant addition, the build system now
contains an initial Python-based menuconfig
alternative. This can currently be used by
running "ninja pymenuconfig" on all supported targets
(though Windows users will need to install an additional
wheel). This is a significant improvement for Windows
users, who previously have not had a configuration
system browser. The pymenuconfig target is
experimental. When it reaches sufficient feature
parity with the existing menuconfig target, it will
replace it, and the C-based Kconfig tools will be
removed from Zephyr.

Further improvements include better error feedback
when toolchains are not found, the list of printed
boards now respecting BOARD_ROOT, and silencing of
verbose compiler check messages.


##### Drivers: 
- There is a new API for LEDs in include/led.h. (Zephyr
had an API for strips of LEDs; this new API is for
controlling individual lights.) The initial API
includes support for basic on/off, as well as
brightness and blinking. A driver and sample
application for the TI LP3943 LED controller were also
merged.

The ST LSM6DSL inertial module driver saw a cleanup
and now supports sensor hub mode. This allows the
LSM6DSL to act as a sensor hub by connecting
additional I2C slave devices through to the driver via
the main communication channel.

STM32L0 and L4 microcontrollers now support the MSI
(multi-speed internal) clock as a system clock source.

The uart_pipe console driver now supports both edge
and level triggering, allowing it to work with CDC
ACM.

The MCUX GPIO driver now uses device tree.

A GPIO driver for NXP i.MX SoCs was merged.


##### Device Tree: 
- Bindings were added for the DesignWare CAVS multilevel
interrupt controller.

GPIO nodes are now present on all Kinetis SoCs.


##### Documentation: 
- The search results pages for the online Zephyr
documentation now have much cleaner output.

Zephyr's documentation describing its Kconfig usage
was re-worked and improved as part of the transition
towards a Python-based menuconfig alternative.


##### Kernel: 
- The kernel's scheduler interface was significantly
refactored and cleaned up. The scheduler's system
interface was decreased to twelve functions; notably,
usage of _Swap() was removed in various places in
favor of a new _reschedule().

Userspace configurations now support dynamic creation
of kernel objects. Previously, kernel objects (such as
mutexes, pipes, and timers) needed to be declared
statically. This is because a special linker pass is
used when building the Zephyr image, which creates a
perfect hash table which was used to validate if a
memory address passed from userspace pointed to a
valid kernel object, among other security checks. In
addition to this hash table, Zephyr now supports
maintaining metadata for dynamically created kernel
objects using the new red/black tree implementation
that was added in the v1.12 development cycle. Dynamic
kernel objects are allocated and freed from the system
heap. The new allocate and free routines are
respectively k_object_alloc() and k_object_free().
They are currently only callable from supervisor mode.


##### Libraries: 
- The singly-linked list implementation in
include/misc/slist.h is now implemented in terms of a
new macro metaprogramming header,
include/misc/list_gen.h. This new header allows
generation of static inline routines implementing
"list-like" behavior (i.e. defining operations for
getting, removing, inserting, etc.) for any compound
data type that implements a base set of operations.
The base operations from which the others are derived
are: initialization; getting the "next" node; setting
the next, head, and tail nodes; and peeking at the
head and tail nodes.

The JSON library's internal descriptor type is more
tightly packed, using bitfields to place information
formerly found in four integers into 32 bits worth of
bitfields. This results in a net savings of read-only
data at a slight increase in text size.


##### Samples: 
- A sample application demonstrating the BLE broadcaster
role by providing Apple iBeacon functionality was
added in samples/bluetooth/ibeacon.

Samples using LEDs and buttons were updated following
the device tree name change from PORT to CONTROLLER
described above.

The LWM2M sample was re-worked to add configuration
overlay fragments for enabling Bluetooth networking
and DTLS. The README was updated with new instructions
for building the sample.


##### Testing: 
- The effort to prepare Zephyr's tests for inclusion in
a test management system continues.

Various tests were cleaned up with style, tag, and
category fixes, along with numerous tests receiving
Doxygen-based documentation.

The sanitycheck script now parses test cases declared
by a test suite from the source code, using regular
expressions.

Sanitycheck also now supports a --list-tests flag,
which prints declared test cases. Its output can be
further refined by passing the -T option a relative
path to a subdirectory of "tests" (e.g. -T
tests/net/socket).

The test suite core now includes support for skipping
tests when they are not supported.


##### USB: 
- There was a fair bit of USB-related activity which
spanned areas in the tree.

The USB DFU class driver was heavily re-worked and
moved to subsys/usb/class. The driver now determines
the flash partition layout for the currently running
image and an area to store an update image via device
tree flash partitions, matching Zephyr's MCUboot area
support mechanism. This allows Zephyr applications to
add firmware update support by enabling the USB DFU
driver and booting under MCUboot. Refer to the README
and other documentation in samples/subsys/usb/dfu for
more details.

The hci_usb sample application, which allows a Zephyr
device which supports USB and a Bluetooth controller
to act as a Bluetooth dongle, had its core USB
operations generalized and migrated into the core USB
subsystem. The sample application is now much smaller;
what remains essentially just enables the driver.

The wpanusb sample, which allows Zephyr applications
to expose 802.15.4 radio functionality to a host via
USB, saw a major cleanup. This sample will be more
widely useful upon release of corresponding Linux
drivers.


#### Bugs

##### Networking fixes: 
- There were several networking-related bug fixes: a
fragment double-free, a build error for HTTP clients,
a buffer overflow in the hostname storage area, an ARP
null network packet dereference, and a miscalculation
of ICMPv6 packet payload length and checksum fields.



##### pthread_cond_signal on cooperative threads: 
- Calling pthread_cond_signal() from a cooperative
thread no longer yields.



##### SMP fixes for irq_lock() shim: 
- The irq_lock() compatibility layer on SMP
configurations was fixed, avoiding potential deadlocks
when swapping away from a thread that holds the lock.



##### Kernel priority validation: 
- The kernel scheduler's validation of priority levels
was fixed.



##### Driver capability check: 
- A bug which allowed user mode code to force the kernel
to execute code at address 0x0 has been fixed by
introducing an extra validation step at every syscall
entry point.



##### I2C user buffer copy fix: 
- A race condition which could potentially allow user
space code to modify memory containing I2C messages
before the kernel-level handler runs was closed.



##### ARC threading fixes: 
- Issues preventing successful thread context switch
during exception return on ARC were fixed. The fatal
error handler on that architecture also no longer
hangs the system after aborting a non-essential
thread.



##### BusFault fixes on ARMv8-M: 
- The BusFault Status Register bits on ARMv8-M MCUs are
now properly cleared when that fault occurs.



##### Bluetooth Mesh fixes: 
- The Bluetooth Mesh implementation continues to become
more robust, with three bug fixes affecting
initialization vectors and node identity advertising,
and two other cleanups.



##### Boot banner fixed for out of tree applications: 
- The boot banner now correctly prints the Zephyr "git
describe" output when the application is outside the
Zephyr tree.



##### Device tree compiler warning fixes: 
- A variety of warnings emitted when using dtc version
1.4.6 are now fixed. These fixes appear to be
backwards-compatible.



##### USB fixes: 
- A variety of USB-related bug fixes went in, including
a fix for the DesignWare driver's excessive generation
of zero-length packets, a missing byte order
conversion computation in the common configuration
descriptor, and other fixes and cleanups.



##### LSM6DSL build fix: 
- The ST LSM6DSL inertial module driver was converted to
use the new SPI API, following the removal of the old
API.



### hawkBit and MQTT sample application


#### Features

##### LED GPIO controller portability check: 
- The sample now checks for old-style (LED_GPIO_PORT)
and new-style (LED_GPIO_CONTROLLER) device names when
finding the GPIO device controlling the user LED.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### LED GPIO controller portability check: 
- The sample now checks for old-style (LED_GPIO_PORT)
and new-style (LED_GPIO_CONTROLLER) device names when
finding the GPIO device controlling the user LED.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

No changes have gone into the LMP since 0.16.
## Highlights

- No changes have gone into the LMP since 0.16.

## Components


