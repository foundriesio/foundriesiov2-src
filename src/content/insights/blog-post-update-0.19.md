+++
title = "microPlatform update 0.19"
date = "2018-05-25"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.19

Zephyr hits 1.12 feature freeze; this will not be the LTS, but
carries many important new features.


## Linux microPlatform changes for 0.19

No changes have gone into the LMP since 0.18.
<!--more-->
# Zephyr microPlatform

## Summary

Zephyr hits 1.12 feature freeze; this will not be the LTS, but
carries many important new features.

## Highlights

- Zephyr 1.12 rc 1
- No MCUboot changes
- Minor application updates

## Components


### MCUboot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### OpenAMP: 
- OpenAMP (and its libmetal dependency) was merged to
enable message-based cross-core communication. This
carries BSD-3-Clause and BSD-2-Clause licenses.

A usage sample is in samples/subsys/openamp:

http://docs.zephyrproject.org/samples/subsys/ipc/openamp/README.html


##### New Zephyr SDK: 
- Zephyr SDK version 0.9.3 has been released. Linux
users should upgrade using the updated installation
instructions:

http://docs.zephyrproject.org/getting_started/installation_linux.html


##### Non-volatile Storage (NVS): 
- A long-running pull request to add a new storage
mechanism for persistent data was merged. The new Non-
Volatile Storage (NVS) subsystem is meant as an
alternative to the existing FAT and NFFS file systems,
as well as the Flash Circular Buffer (FCB) library
which was ported to Zephyr from the MyNewt RTOS.

For more details, refer to the NVS subsystem documentation:

http://docs.zephyrproject.org/subsystems/nvs/nvs.html

This would seem to pair well with the storage API
changes discussed in the previous newsletter, which
introduced greater abstraction over the storage
backend.


##### k_call_stacks_analyze() deprecated: 
- The k_call_stacks_analyze() API was deprecated. Users
are recommended to switch to using k_thread_foreach():

http://docs.zephyrproject.org/api/kernel_api.html#_CPPv216k_thread_foreach18k_thread_user_cb_tPv

(Perhaps re-implementing or calling into a stack usage
dumping routine for each thread.)


##### Userspace changes: 
- Numerous userspace-related features and optimizations
were merged.

New API was merged for memory management from
specified memory pools. The main functions are:

- k_mem_pool_malloc():
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_mem_pool_mallocP10k_mem_pool6size_t
- k_mem_pool_free():
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv215k_mem_pool_freeP11k_mem_block

This is used to allow dynamic allocation of kernel
objects from userspace.

Cleanup functions defined on a per-kernel-object-type
basis can now be invoked when an object loses all
permissions. This is used as a framework for automatic
resource release for dynamically-allocated userspace
objects.

New APIs were added for userspace allocation and
freeing of kernel objects of various types:

- k_pipe_alloc_init() and k_pipe_cleanup() for pipes:
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_pipe_alloc_initP6k_pipe6size_t
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv214k_pipe_cleanupP6k_pipe
- k_msgq_alloc_init() and k_msgq_cleanup() for message queues:
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv217k_msgq_alloc_initP6k_msgq6size_t5u32_t
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv214k_msgq_cleanupP6k_msgq
- k_stack_alloc_init() and k_stack_cleanup() for stack objects:
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv218k_stack_alloc_initP7k_stackj
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv215k_stack_cleanupP7k_stack

Additional APIs for allowing userspace access to queues includes:

- k_queue_alloc_append() and k_queue_alloc_prepend()
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv220k_queue_alloc_appendP7k_queuePv
  http://docs.zephyrproject.org/api/kernel_api.html#_CPPv221k_queue_alloc_prependP7k_queuePv
- k_fifo_alloc_put():
  http://docs.zephyrproject.org/api/kernel_api.html#c.k_fifo_alloc_put
- k_lifo_alloc_put():
  http://docs.zephyrproject.org/api/kernel_api.html#c.k_lifo_alloc_put

The k_poll Polling API is now also accessible from user mode:

http://docs.zephyrproject.org/kernel/other/polling.html

An optimization was merged which avoids executing
user/supervisor boundary checks when invoking system
calls from privileged code in translation units
defined under arch/.

Access to the k_object_access_revoke() routine from
userspace was itself revoked, closing a hole where one
thread could inappropriately revoke another's access
to a kernel object. Userspace threads may revoke
access to their own objects with k_object_release().


##### TCP TIME_WAIT config changes: 
- Configuration for how long the Zephyr TCP stack remains
in the TIME_WAIT state during connection closure is
now managed through the single
CONFIG_NET_TCP_TIME_WAIT_DELAY option:

http://docs.zephyrproject.org/reference/kconfig/CONFIG_NET_TCP_TIME_WAIT_DELAY.html

This replaces the previous CONFIG_NET_TCP_TIME_WAIT
and CONFIG_NET_TCP_2MSL_TIME options. Applications
using the old options will need updates.


##### Architectures: 
- Support for Arm's v8-M cores continues, with support
for secure fault handling on Cortex-M23 along with
other behind-the-scenes work on memory access
privilege checks.

There is a new CONFIG_PLATFORM_SPECIFIC_INIT available
on Arm targets. When enabled, the user must provide a
_PlatformInit routine, which will be called at Zephyr
startup before anything else happens.

Support was added to enable a Zephyr image running on
an NXP LPC-based SoC to boot a slave Cortex M0+ core.
(Board support was added for the slave core as
lpcxpresso54114_m0.)


##### Bluetooth: 
- The Mesh shell now supports the recently-merged
persistent storage mechanism.


##### Device Tree and Drivers: 
- Zephyr now supports the automobile Controller Area
Network (CAN) protocol. The API is specified in
include/can.h. The new API is userspace-aware.
GPIO bindings were added for QMSI (Intel Quark) based
devices, with nodes added for quark_se_c1000_ss.

Device tree bindings were added for real-time clocks
(RTCs), as well as NXP Kinetis and QMSI based RTCs.
SoC support was added for KW41Z and quark_se_c1000_ss.

Additional patches continuing the work migrating LED
and buttons definitions to device tree were merged for
mimxrt1050_evk and lpcxpresso54114. Device tree
support for sensors on the argonkey board was also
merged, along with em_starterkit device tree
optimizations, and bindings for LSM6DSL sensors and
Kinetis watchdogs.

A shim driver using the newly-stabilized watchdog API
was added for NXP MCUx devices. SOC support is
provided for K64 and KW2XD.

USBD (USB device) and USBFSOTG (USB full-speed On-the-
Go) support was added for NXP Kinetis SoCs. USB
support was also enabled for STMicro nucleo_f413zh.

WiFi support for the WINC1500 network controller was
merged. This chip can be used to add networking via
SPI. This is the first user of the new WiFi API which
was merged during the v1.12 development cycle. Support
can be enabled using CONFIG_WIFI_WINC1500.  A driver
was added for ILI9340 LCD displays.


##### External Libraries: 
- The OpenThread library version was bumped to db4759cc,
to pull in some bug fixes.

The Atmel WINC1500 WiFi driver was merged as part of
enabling WiFI on that chip. This is a BSD-3-Clause
licensed HAL.


##### Kernel: 
- In a highly significant but (hopefully mostly) behind-
the-scenes change, the scheduler was rewritten:

https://github.com/zephyrproject-rtos/zephyr/commit/1acd8c2996c3a1ae0691247deff8c32519307f17

A new k_thread_foreach() API was merged, which allows
iterating over threads:

http://docs.zephyrproject.org/api/kernel_api.html#_CPPv216k_thread_foreach18k_thread_user_cb_tPv

This requires CONFIG_THREAD_MONITOR to be enabled.
Creation and termination of existing threads is
blocked via irq_lock() while the routine is executing.


##### Libraries: 
- The red-black tree implementation in include/misc/rb.h
now has RB_FOR_EACH() and RB_FOR_EACH_CONTAINER()
macros, for iterating over red-black tree nodes and
the structs which contain them.

The POSIX compatibility layer has additional file
system support APIs. Pulling in the POSIX headers
defines macros which map POSIX names to Zephyr-
specific file system APIs appropriately. This includes
support for basic syscalls such as open(), read(),
write(), close(), and friends, and also allows for
directory operations such as rename(), stat(), and
mkdir(). Refer to the headers in include/posix for
more information.

There is also now support for the POSIX mutex APIs.


##### Miscellaneous: 
- A new API was added for a singly-linked-list like type
which allows storing two flags in each node, by
relying on 4-byte pointer aligment. For details, refer
to include/misc/sflist.h.


##### Networking: 
- The LWM2M subsystem now includes support for marking
resources as optional. Any resources so marked are not
initialized by the core LWM2M subsystem; applications
must initialize them using lwm2m_engine_set_res_data()
and lwm2m_engine_get_res_data(). This enables
remote administration of these resources by the LWM2M
server through CREATE operations. It also enables
future work where BOOTSTRAP operations will behave
differently when encountering optional resources. As
part of these changes, various object resources
throughout the LWM2M core and in supported IPSO
objects were marked optional appropriately.

The 802.15.4 subsystem now supports source address
filtering and performing energy detection scans when
OpenThread is in use.


##### Samples: 
- New samples include:

- a RPL border router application, samples/net/rpl_border_router:
  http://docs.zephyrproject.org/samples/net/rpl_border_router/README.html
- A WiFi shell sample, samples/net/wifi:
  http://docs.zephyrproject.org/samples/net/wifi/README.html
- An OpenAMP usage sample, samples/subsys/openamp:
  http://docs.zephyrproject.org/samples/subsys/ipc/openamp/README.html
- An MCUX IPM mailbox example, samples/subsys/ipc/ipm_mcux:
  http://docs.zephyrproject.org/samples/subsys/ipc/ipm_mcux/README.html
- A sample for the 96Boards ArgonKey, samples/boards/96b_argonkey:
  http://docs.zephyrproject.org/samples/boards/96b_argonkey/README.html
- A CAN sample, samples/can, tested on stm32f072b_disco:
  http://docs.zephyrproject.org/samples/can/README.html


##### Scripts: 
- The flash, debug, and debugserver handlers now use a
new meta-tool called "west". This is still a behind-
the-scenes change; further work expected before the
v1.12 release will add documentation for this tool.


##### Testing: 
- The effort adding descriptions, cleanups, and other
improvements to Zephyr's test cases to use them from a
higher-level test management system continues.


#### Bugs

##### Drivers: 
- Numerous drivers cleanups and bug fixes went in,
affecting various devices.



##### ARM SoCs: 
- Various Arm-specific fixes went in as part of the v8-M
work.



##### Bluetooth: 
- A new CONFIG_BT_MESH_IVU_DIVIDER went in, which fixes
an issue related to re-initializing initialization
vectors. Various other Bluetooth cleanups and fixes
went in, including removals of deprecated APIs and
unused variables and documentation fixes.



##### Documentation: 
- Numerous fixes and additional Doxygen descriptions
went into the test cases.



##### Networking: 
- Networking fixes include net-app fixes for TLS
warnings, source IPv4 address selection, build fixes
with TCP disabled, and byte order handling; ethernet
MAC address setting; LWM2M port handling fixes;
dropping of invalid packets; and a couple of ICMPv6
fixes.



##### Build system: 
- Various build fixes, error handling and Kconfig
dependency management improvements,
k_call_stacks_analyze() removals, and more were added
to the samples.



### hawkBit and MQTT sample application


#### Features

##### Minor Kconfig updates: 
- The application-specific Kconfig file was updated to
follow along with upstream changes removing 'option
env' symbols.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### Minor Kconfig updates: 
- The application-specific Kconfig file was updated to
follow along with upstream changes removing 'option
env' symbols.


##### Optional values changes: 
- Minor changes were made following upstream API breaks
which added optional resources to LWM2M objects.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

No changes have gone into the LMP since 0.18.
## Highlights

- No changes have gone into the LMP since 0.18.

## Components


