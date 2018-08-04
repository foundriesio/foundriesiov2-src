+++
title = "microPlatform update 0.18"
date = "2018-05-18"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.18

Zephyr from near the end of the v1.12 cycle, minor application
updates for new Bluetooth APIs.


## Linux microPlatform changes for 0.18

OSF Unified Linux Kernel updated to the 4.16.8 stable release.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr from near the end of the v1.12 cycle, minor application
updates for new Bluetooth APIs.

## Highlights

- No MCUboot changes
- Zephyr has a new watchdog API, Python-based menuconfig, new storage APIs, Bluetooth nonvolatile settings
- Sample applications were updated to new Bluetooth identity setting API

## Components


### MCUboot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### New Watchdog API: 
- Continuing the Zephyr Long Term Support (LTS) goal of
having stable driver APIs, the watchdog.h interface
was overhauled and re-worked. The wdt_enable(),
wdt_get_config(), wdt_set_config() and
wdt_api_reload() routines are still around for now,
but have been deprecated. Users of the watchdog API
will want to switch to the new routines documented in
include/watchdog.h instead.

A driver using the new API was merged for the nRF SoC
family's watchdog peripheral. This driver uses device
tree.


##### Menuconfig is now in Python: 
- The previously experimental Python menuconfig
implementation has replaced the C tools, following the
addition of symbol search and jump-to-definition
features.

Users who were building the C tools in order to run
menuconfig must use the new Python tools instead.
Windows users need to install a new dependency via pip
(by re-running "pip3 install -r
scripts/requirements.txt") before using this program.
Mac and Linux users do not require any additional
dependencies.

Zephyr's use of Kconfig includes additional features
not present in the language implemented by the C
tools. Somewhat confusingly, documentation for these
features was added to the board porting guide:

http://docs.zephyrproject.org/porting/board_porting.html#kconfig-extensions

This is a significant change, in that it now makes
Zephyr development possible on Windows in the native
cmd.exe or Powershell shells, without any additional
Unix-specific toolchains or environments.


##### Storage API changes: 
- A variety of storage-related API changes were merged.
These mostly are used to enable new features.

The Kconfig knob which enables the storage_partition
flash partition (see http://docs.zephyrproject.org/devices/dts/flash_partitions.html)
was renamed from
CONFIG_FS_FLASH_MAP_STORAGE to
CONFIG_FS_FLASH_STORAGE_PARTITION. This rename was
done because use of the storage partition does not
require the flash_map module.

The filesystem API's struct fs_mount_t can now store
references to storage devices of arbitrary type in its
storage_dev field; it was previously restricted to a
struct device*, but is now a void*. This change was
made to enable additional layers of indirection
between this field and the backing device.

The disk_access.h API was modified to support
simultaneous use of multiple disk interfaces. The old
disk_access_ram.c and disk_access_flash.c have seen a
corresponding refactor; their globally available
functions are now hidden behind instances of the new
struct disk_info and struct disk_operations structures
introduced in this change. The external FAT file
system library now supports multiple volumes.

The filesystem subsystem now supports multiple mounted
instances of a filesystem. As a result of these
changes, the fs/fs_interface.h API no longer assumes
that either FAT or NFFS file systems are being used.


##### Bluetooth bt_storage removed in favor of settings API: 
- The bt_storage API was removed, as it provided
features now enabled by the settings subsystem using
CONFIG_BT_SETTINGS. Users of this API will need
updates.

The Bluetooth shell and mesh and mesh_demo samples now
have settings support, as demonstrations of using the
API.

Bluetooth Mesh support for the settings API required
some refactoring to expose previously hidden symbols
to the storage API. There are some tradeoffs,
particularly related to managing flash wear when
storing the local sequence number and replay
protection list; refer to the help for the new
CONFIG_BT_MESH_SEQ_STORE_RATE and
BT_MESH_RPL_STORE_TIMEOUT options for details.

Using this API requires a larger system workqueue
stack size; the present recommended size when using
this API is now 2 KB, double its default value.

One additional alternative to using the settings API
is the new bt_set_id_addr() routine, which allows
applications to set their identity addresses in a
manner similar to the bt_settings API.


##### Arches: 
- ARMv8-M MCUs with the Main Extension now have support
for hardware-based main stack overflow protection. The
relevant Kconfig option to enable the feature is
CONFIG_BUILTIN_STACK_GUARD.

x86 CPUs can now grant user space access to the heap
when using the newlib C library.


##### Documentation: 
- In something of a meta development, documentation
was added for how to write Zephyr documentation:

http://docs.zephyrproject.org/contribute/doc-guidelines.html


##### Drivers and Device Tree: 
- The YAML device tree bindings for SPI now include an
optional cs-gpios property, which can be used to
generate GPIO chip select definitions.

The bindings for ST's SPI-based BTLE nodes now require
irq-gpios and reset-gpios properties. The names of
such devices are now only present in Kconfig if a new
CONFIG_HAS_DTS_SPI_PINS selector is unset.

There are two new Kconfig symbols, CONFIG_HAS_DTS_GPIO
and CONFIG_HAS_DTS_GPIO_DEVICE, which respectively
allow declaring that the GPIO driver supports device
tree, and that drivers which need GPIOs do as well.
Currently, only the STM32 and MCUX GPIO drivers select
CONFIG_HAS_DTS_GPIO.

DT-based GPIO support for the NXP i.MX7 M4 SoC was
added.

The mcux DSPI driver now uses device tree; SPI
bindings were added to the SoC files appropriately to
enable this change. This driver also now supports
KW40/41Z SoCs.

The LED driver subsystem now has system call handlers
for user mode configurations.

The USB device controller driver for STM32 devices now
supports all STM32 families, among a variety of other
improvements to enable USB support on STM32 MCUs in a
variety of families. Board support was also added for
olimexino_stm32 and stm32f3_disco.

The pinmux subsystem no longer supports user mode
access. This subsystem's drivers lack sufficient input
validation to prevent a malicious userspace from
accessing unauthorized memory through API calls. A
proper fix will require developing a specification for
the subsystem, and updating existing drivers to do
appropriate input validation.

Altera HAL drivers can now be run on Zephyr. Such a
driver for the Nios-II modular scatter-gather DMA
(mSGDMA) peripheral was merged, from the Altera SDK
v17. This was used to add a shim driver using Zephyr's
dma.h API.


##### Networking: 
- The LWM2M implementation was significantly refactored
and cleaned up.  Once nice benefit of this work is a
3KB RAM savings when running an LWM2M client.

The network interface core now supports
net_if_ipv4_select_src_addr() and net_if_ipv4_get_ll()
routines for accessing IPv4 source addresses.

Each struct net_pkt now uses one less byte of space,
thanks to an optimization in the size of its _unused
field.


##### Testing: 
- The test case documentation now describes best
practices for developing a test suite, and how to list
and skip test cases; see http://docs.zephyrproject.org/subsystems/test/ztest.html
for details.

Various tests were converted to use the ztest API,
along with other cleanups, renames, and Doxygen fixups
added to the test suite.


#### Bugs

##### Build fix on sam_e70: 
- A build issue on sam_e70 was fixed.



##### ARM MPU buffer validation fix: 
- An off-by-one error in the ARM MPU buffer validation
routine was fixed.



##### Bluetooth Mesh sequence number fixes: 
- A dedicated routine for incrementing the sequence
number in the Bluetooth Mesh implementation was added;
in addition to fixing race conditions, this is used by
Mesh's settings subsystem integration in order to
persist sequence numbers to flash.

A Bluetooth Mesh bug affecting sequence number
calculation in the Friend queue was fixed.



##### Drivers fixes: 
- Fixes to the TI ADC108S102 driver; VL53L0X, LSM6DSL,
and HTS221 sensor drivers; and QMSI UART driver were
merged.



##### Sensor DTS fixes on NXP boards: 
- Fixes for using the FXOS8700, FXAS21002, and MCR20A
drivers on NXP boards were merged.



##### User mode heap access fix when using newlib: 
- User mode heap access was fixed for applications which
use the newlib C library. User mode applications also
no longer allow the stack sentinel debugging feature
to be enabled. This change was made because
CONFIG_USERSPACE implies separate and more robust
stack protection mechanisms.



##### Traffic class fixes: 
- The networking traffic class map from packet
priorities to traffic classes was fixed to comply with
the IEEE 802.1Q specification.



##### Websocket Coverity fixes: 
- The websocket implementation was refactored to avoid
unnecessary tricky calculations, resolving Coverity
warnings.



##### http_client fixes for TLS: 
- The http_client sample was fixed in cases when TLS is
enabled; previously, this application overflowed a
stack in this use case.



##### smp_svr build fixed: 
- The mcumgr smp_svr sample's build was fixed.



##### Network echo fixes: 
- The echo_client and echo_server sample applications
saw a few fixes; echo_server works again to test
OpenThread on frdm_kw41z, and echo_client was fixed on
cc2520.



##### DTS fixups: 
- Various fixes and refactoring patches were merged to
the extract_dts_includes.py script, which generates
code used by Zephyr from the final device tree
produced during an application build.



### hawkBit and MQTT sample application


#### Features

##### Bluetooth identity API change: 
- The sample was updated to use a new bt_set_id_addr()
routine, following the upstream removal of the
bt_settings API.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### Bluetooth identity API change: 
- The sample was updated to use a new bt_set_id_addr()
routine, following the upstream removal of the
bt_settings API.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

OSF Unified Linux Kernel updated to the 4.16.8 stable release.

## Highlights

- OSF Unified Linux Kernel updated to 4.16.8.

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.16.8.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update: 
- New machine configuration for ls1043ardb-be, ls1046ardb-be,
ls1088ardb-be, ls2088ardb-be.


#### Bugs
- Not addressed in this update

### Meta Linaro


#### Features

##### Layer Update: 
- Added optee-examples bitbake recipe, which builds the OPTEE
examples trusted applications.


#### Bugs
- Not addressed in this update

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- Yp-tools updated to 4.2.3.
Added wpan-tools recipe.
Wireshark updated to 2.4.6.
Mbedtls updated to 2.8.0.


#### Bugs
- Not addressed in this update

### Meta Qualcomm


#### Features

##### Layer Update: 
- Updated qmic, qrtr and rmtfs to the latest version available.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update: 
- rpi-config extended to cover more commonly used config
variables.


#### Bugs
- Not addressed in this update

### Meta Updater Layer


#### Features

##### Layer Update: 
- Aktualizr now validates /var/sota file access permission before
initializing the service.
Aktualizr can now publish the target network information to the
OTA+ server.
Garage-sign version now depends on what gets provided by the
remote server available in the sota credentials file.


#### Bugs
- Not addressed in this update
