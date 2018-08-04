+++
title = "microPlatform update 0.20"
date = "2018-06-08"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.20

Zephyr v1.12 rc2, sample support for nRF52832 DK.


## Linux microPlatform changes for 0.20

OSF Unified Linux Kernel updated to the 4.16.12 stable release.
Initial support for QEMU RISC-V 64 and SiFive Freedom Unleashed U540 targets.
New image lmp-mini-image for minimal OTA+ compatible images, currently used
by RISC-V targets due lack of Golang support.
Core layer updates based on the latest changes for the Yocto Thud (2.6) release.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr v1.12 rc2, sample support for nRF52832 DK.

## Highlights

- Zephyr between v1.12 rc2 and rc3
- No MCUboot changes
- Sample board support for nrf52_pca10040, other fixes

## Components


### MCUboot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### Schedule(r) wrangling: 
- As may have been expected, rewrites of central and
notoriously tricky areas like kernel schedulers
inevitably result in bugs which need shaking out. Most
noticeably, boot hangs and increasingly lengthy
context switch times have been observed in a variety
of circumstances, and some significant bug fixes have
been flowing in following the rewrite, notably
affecting pre-emption, scheduling of dummy threads,
and SMP scheduling.

The dust appears to be settling for v1.12, but more
changes are in the works for v1.13. Hold on to your
hats.


##### CONFIG_TOOLCHAIN_VARIANT removed: 
- This legacy Kconfig option is gone now. Any remaining
users must switch to the ZEPHYR_TOOLCHAIN_VARIANT
CMake or environment variable, as documented in the
Getting Started guide:

http://docs.zephyrproject.org/getting_started/getting_started.html


##### Kconfig cleanup: 
- In a valiant tree-wide cleanup effort, a number of
stale or incorrect Kconfig symbols were updated and
fixed. This affected essentially every subsystem.
Merge conflicts for out-of-tree patches seem likely.


##### zephyr_library_ifdef() removed: 
- The build system's zephyr_library_ifdef() macro was
that evil type which modifies the control flow of the
caller. In-tree uses were replaced with safer
alternatives and the macro was removed; any out of
tree users will need updates.


##### Architectures: 
- Nordic SoCs have their instruction cache enabled.
Users who don't want their code to run faster can
disable the new CONFIG_NRF_ENABLE_ICACHE, which is on
by default.

Precious, precious MPU regions were freed up on
various ARM SoCs by deleting existing entries for
memory-mapped peripheral buses and other such areas in
SoC configuration files. Access privileges for these
areas are now determined by the special "background
region", or default configuration, which allows RWX
access for supervisor mode, and prevents user mode
access. This frees up these scarce resources for use
defining restrictions on other areas of memory, such
as thread stacks.


##### Boards: 
- Support was added for the NUCLEO-L053R8 board, which
features an STM32L053R8 SoC.


##### Drivers: 
- Some new features were added here, in some cases to
enable bug fixes, and in others as late-breaking
exceptions to the freeze.

In order to address issues with entropy gathering, a
new interrupt-safe source of entropy,
entropy_get_entropy_isr(), was added to the API in
include/entropy.h. An implementation is provided for
nRF devices. This was aided by other initialization
order changes which collectively allow the kernel to
safely collect entropy earlier in its initialization.

Users of the w25qxxdv SPI flash driver have new
Kconfig options allowing them to control chip select
pins, which can be enabled and set using
CONFIG_SPI_FLASH_W25QXXDV_GPIO_SPI_CS.

A new status_cb field was added to struct
netusb_function, allowing such functions to define
status callbacks. This new API was needed to fix some
issues causing kernel crashes.

Driver support was added for STM32 low power UARTs
(LPUARTs); this can be enabled with
CONFIG_UART_STM32_LPUART_1.


##### Kernel: 
- A new "meta-IRQ" feature was added to control
scheduling for a new type of thread. A meta-IRQ is not
a true interrupt, but pending threads with meta-IRQ
priority will be scheduled before any other threads,
even cooperative ones or those which have the
scheduler lock. This has the flavor of the "softirq"
mechanism present in the Linux kernel, and appears to
have similar goals. Like softirqs, these must be used
with care, and are likely not good targets for
application developer use. See the Meta-IRQ Priorities
section in the threads documentation for more details
on their design and goals:

http://docs.zephyrproject.org/kernel/threads/scheduling.html#meta-irq-priorities

A patch was merged which enables ongoing work
producing a requirements traceability matrix from
requirements to test cases in APIs exposed by the main
include/kernel.h. This adds Doxygen comments with
requirement IDs to individual APIs, so it's
technically documentation.

A simple deadline scheduling policy was implemented.
See CONFIG_SCHED_DEADLINE for details.


##### Scripts: 
- The Python menuconfig implementation has new features
for showing a symbol's name when 'c' is pressed, along
with improvements to searching, saving, and loading.

Kconfiglib now warns if a string symbol's default
value is not quoted.


#### Bugs

##### Arches: 
- The majority of the fixes applied to the x86 and ARM
architectures. These cover typos and coding style,
scheduling, stack management, IRQ management,
scheduling, and MPU management, as well as SoC
specific fixes mostly targeting STM32 and x86 chips.

Optional mitigation was added for Spectre variant v4
on Intel chips; see CONFIG_DISABLE_SSBD for details.



##### Bluetooth: 
- It was quiet, but not too quiet.

Beyond the Kconfig cleanup, a small number of fixes
were merged, including a compiler-version specific fix
for Mesh and a fix for non-priority event handling in
the core controller code. Missing checks were also added
for settings value reads.

The Bluetooth subsystem is one of Zephyr's best
tested, and the small size of the change list in this
period reflects this.



##### Boards: 
- Beyond the tree-wide Kconfig fixes, a general fix was
merged for "make flash" for boards using the "bossac"
flashing tool. A variety of patches were merged fixing
board-specific issues and enabling some missing
features. See the Boards list of commits in the
Individual Changes section below to learn if boards
you use were affected.



##### Continuous Integration: 
- An arguable misconfiguration in sanitycheck related to
job parallelism was addressed, resulting in a 24%
speed improvement. Other miscellaneous fixes to
sanitycheck were merged as well.

External libraries are no longer tracked in code
coverage measurements, improving the accuracy of the
code coverage output for Zephyr-specific code.



##### Device Tree: 
- A variety of fixes went in for warnings generated by
the new dtc v1.4.6 compiler which was part of the new
Zephyr 0.9.3 SDK, with a handful of fixes in other
areas.



##### Documentation: 
- The effort preparing the documentation for release is
picking up steam.

Missing documentation was added covering system calls
and userspace, kernel and threading APIs, POSIX
compatibility, VLANs, network traffic classification,
the sanitycheck script used by CI, and more.

Numerous spelling errors were corrected in a series of
commits, each targeting specific areas.



##### Drivers: 
- About fifteen percent of the total patches in this
period affected Zephyr's device drivers.

Apart from the Kconfig cleanup, STM32-specific driver
fixes featured prominently, affecting SPI, UART,
Ethernet, and GPIO. Fixes for drivers needed by the
new intel_s1000_crb board were merged affecting I2S
and DMA.



##### External: 
- The build system integration for OpenAMP and libmetal
was fixed to avoid recursive builds, which the Zephyr
build system (maintainer) abhors. May other developers
tempted down that dark way be warned, and stay along
the straight path.

mbedTLS was updated to version 2.9.0 from 2.8.0; this
brings security fixes along with other improvements.

A subtle power-related USB fix for STM32 was merged,
adding a patch to Zephyr's copy of the STM32L4 HAL.



##### Kernel: 
- Various fixes were merged apart from the scheduler
rodeo. It looks like the dust is settling on these
issues for v1.12, but the opening of the v1.13 merge
window will include additional refactoring of the
scheduler to better consolidate flags associated with
non-running threads, so the list of incoming scheduler
changes won't be empty anytime soon.

A race was fixed in the mempool allocator. Some
architecture-specific fixes were made that the meta-
IRQ addition exposed. The kernel now uses the new ISR-
safe entropy source during early initialization,
before threads are available, and uses the entropy API
directly to initialize stack canaries.



##### Libraries: 
- A bug making the clock_gettime() implementation non-
monotonic when called with CLOCK_MONOTONIC was fixed.



##### Networking: 
- Not much was merged; the networking developers are
hard at work with the ongoing rewrite of Zephyr's TLS
implementation to use a new and nonstandard
setsockopt()-based API. Since that's feature work, it
will have to wait for v1.13 to be merged.

Fixes went in around the subsystem addressing problems
where incorrect timeouts were set due to use of MSEC()
or raw numbers instead of K_MSEC(), and other related
issues.

A boot hang related to invalid use of a receive queue
was fixed.

A security session initialization bug affecting
802.15.4 was fixed.

Most of the other fixes appear to be of the usual
variety: a null pointer dereference, packet management
and checksumming issues, edge cases and error
handling, etc.



##### Samples: 
- Other than the Kconfig cleanup, the samples didn't
seem to need too many changes since rc1, which is
good.

The coap_server sample properly handles the case where
the client no longer wishes to receive notifications
following an initial observe operation. The
coap_client application also saw general improvements
and fixes.

The OpenAMP sample has improved documentation and
comments.



##### Scripts: 
- Not much happened here.

The elf_helper.py library used by the build system to
manipulate Zephyr binaries got some cleanup and an
architecture-specific corner case fix.

Issues in west preventing "make flash" etc. from
working on certain boards, as well as running as root
on Unix, were fixed.

Fixes were made to genrest.py, which generates
Zephyr's Kconfig symbol documentation.



##### Storage: 
- This subsystem was fairly quiet as well.

As might be expected with new code, a variety of bug
fixes went in to the non-volatile storage (NVS) layer.
These are mostly related to buffer management and
padding, and also include a fix related to device
addressing.

A pile of issues in the disk subsystem discovered by
Coverity were fixed with extra NULL pointer checks.

Some misleading menuconfig prompts related to flash
parameters were fixed.



##### Testing: 
- Test, test, one, two, three, ... eighty commits have
gone in to improving Zephyr's tests. These break down
into the following rough categories:

- tons of test descriptions added as Doxygen comments
  (see GitHub issue 6991,
  https://github.com/zephyrproject-rtos/zephyr/issues/6991,
  for details on how this is part of a larger strategy)
- other restructuring and refactoring to make 6991
  infrastructure work better
- fixes to problems in the sources for the test case
  themselves
- fixes and improvements related to testing user mode
- Kconfig cleanup
- new tests



### hawkBit and MQTT sample application


#### Features

##### Network shell enabled for nRF52840 DK: 
- CONFIG_NET_SHELL is now enabled on nrf52840_pca10056,
which has the resources to support this useful tool.


##### Support for nRF52832 DK: 
- Board support was added for nrf52_pca10040 (nRF52832 DK).
This enforces a flash partition layout identical to BLE
Nano 2.


#### Bugs

##### Work queue fix: 
- NULL work returned early from k_queue_get() is now handled.



##### Don't force Bluetooth just because it is available: 
- The sample no longer selects NET_L2_BT on hardware with
Bluetooth support. This fix is preparatory work for supporting
additional network media supported by such hardware, like
802.15.4.



### LWM2M sample application


#### Features

##### Network shell enabled for nRF52840 DK: 
- CONFIG_NET_SHELL is now enabled on nrf52840_pca10056,
which has the resources to support this useful tool.


##### Support for nRF52832 DK: 
- Board support was added for nrf52_pca10040 (nRF52832 DK).
This enforces a flash partition layout identical to BLE
Nano 2.


#### Bugs

##### nRF52840 LED polarity fix: 
- The inverted polarity of the LED on this board is now respected.



##### Work queue fix: 
- NULL work returned early from k_queue_get() is now handled.



##### Don't force Bluetooth just because it is available: 
- The sample no longer selects NET_L2_BT on hardware with
Bluetooth support. This fix is preparatory work for supporting
additional network media supported by such hardware, like
802.15.4.



##### Remove obsolete Kconfig: 
- Obsolete Kconfig options removed upstream are cleaned up.


# Linux microPlatform

## Summary

OSF Unified Linux Kernel updated to the 4.16.12 stable release.
Initial support for QEMU RISC-V 64 and SiFive Freedom Unleashed U540 targets.
New image lmp-mini-image for minimal OTA+ compatible images, currently used
by RISC-V targets due lack of Golang support.
Core layer updates based on the latest changes for the Yocto Thud (2.6) release.

## Highlights

- OSF Unified Linux Kernel updated to 4.16.12.
- U-Boot updated to the 2018.05 release.
- Hikey now uses the upstream Grub 2.02 EFI recipe.
- New layer Meta RISC-V added to LMP (RISC-V BSP support).
- Initial support for QEMU RISC-V 64 and SiFive Freedom Unleashed U540.

## Components


### OpenEmbedded-Core Layer


#### Features

##### Layer Update: 
- Autoconf-archive updated to 2018.03.13.
Bash updated to 4.4.18.
Bash-completion updated to 2.8.
Bluez5 updated to 5.49.
Boost updated to 1.67.0.
Curl updated to 7.59.0.
Dbus updated to 1.12.8.
Dbus-glib updated to 0.110.
Distcc updated to 3.3.
Dropbear updated to 2018.76.
Gawk updated to 4.2.1.
Gdb updated to 8.1.
Glib-2.0 updated to 2.56.1.
Gnutls updated to 3.6.2.
Go 1.10.x updated to 1.10.2.
Go 1.9.x updated to 1.9.6.
Gobject-introspection updated to 1.56.1.
Hdparm updated to 9.55.
Icu updated to 61.1.
Iproute2 updated to 4.15.0.
Less updated to 530.
Libaio updated to 0.3.111.
Libgpg-error updated to 1.31.
Libidn updated to 1.34.
Libsolv updated to 0.6.34.
Libusb1 updated to 1.0.22.
Libxml2 updated to 2.9.8.
Logrotate updated to 3.14.0.
Ncurses updated to 6.1.
Python3-pip updated to 9.0.3.
Python3-setuptools updated to 39.0.1.
Sqlite3 updated to 3.23.1.
Strace updated to 4.22.
Sudo updated to 1.8.23.
Time updated to 1.9.
Tzcode-native updated to 2018e.
Tzdata updated to 2018e.
U-Boot updated to the 2018.05 release.
Util-linux updated to 2.32.
Util-macros updated to 1.19.2.
Vala updated to 0.40.4.


#### Bugs

##### qemu: 
- During Qemu guest migration, a destination process invokes ps2
post_load function. In that, if rptr and count values were
invalid, it could lead to OOB access or infinite loop issue.

 - [CVE-2017-16845](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-16845)

##### util-linux: 
- Multiple issues.

 - [CVE-2018-7738](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-7738)

### Meta OpenEmbedded Layer


#### Features

##### Layer Update: 
- New recipe broadcom-bt-firmware added for Broadcom Bluetooth
firmwares.
Gpsd updated to 3.17.
Htop updated to 2.1.0.
Python3-cython updated to 0.28.2.
Python3-Websockets updated to 4.0.1.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update: 
- Ixgbe updated to v5.3.7.
Ixgbevf updated to v4.3.5.


#### Bugs
- Not addressed in this update

### Meta 96boards


#### Features

##### Layer Update: 
- Grub2 now based on the upstream grub-efi 2.02 recipe.


#### Bugs
- Not addressed in this update

### Meta Freescale


#### Features

##### Layer Update: 
- New machine configuration for p5040ds-64b, t1024rdb-64b,
t2080rdb-64b and t4240rdb-64b.
Added utp-com recipe.
Imx-uuc updated to the latest revision.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update: 
- Firmware updated to 20180417.
Rpi-config now does not force device tree selection for
raspberrypi3-64.


#### Bugs
- Not addressed in this update

### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to 4.16.12.
Support for RISC-V qemuriscv64 and freedom-u540.
Removal of alsa, irda, pcmcia, nfc and pulseaudio from distro
features, as they should be provided via containers.
Added new lmp-mini-image for minimal OTA+ compatible images,
currently used by RISC-V targets due lack of Golang support.


#### Bugs

##### linux-osf: 
- Kernel update to the 4.16.x series broke overlay support for
Raspberry PI 3 64 targets, which is now fixed as part of the
4.16.12 update (device-tree not exporting __symbols__).



### Meta Updater Layer


#### Features

##### Layer Update: 
- OSTree recipe updated to generate additional packages and
improve the runtime dependency list.


#### Bugs
- Not addressed in this update
