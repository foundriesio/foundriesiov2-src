+++
title = "microPlatform update 0.21"
date = "2018-06-18"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.21

Zephyr v1.12, MCUboot changes for v1.2.0, minor sample adjustments


## Linux microPlatform changes for 0.21

OSF Unified Linux Kernel updated to the 4.16.15 stable release.
U-Boot-Fslc updated to the 2018.05-based release.
Core layer updates based on the latest Yocto master changes.

<!--more-->
# Zephyr microPlatform

## Summary

Zephyr v1.12, MCUboot changes for v1.2.0, minor sample adjustments

## Highlights

- Zephyr v1.12 is merged; this is the last update from this development tree.
- Various MCUboot updates from v1.2.0, including new dependency on click
- No changes to the sample applications

## Components


### MCUboot


#### Features

##### Click is now mandatory:
- The Python click package is now mandatory to use
MCUboot. Users must install it on their development
workstations.


##### New --slot-size imgtool flag:
- The imgtool script has changed incompatibly to require
a --slot-size option for ensuring images fit in their
slots without explicitly padding them with --pad. If
you're calling this script manually, you will need to
use this argument. Users of the zmp script are not
affected, as it has been kept up to date.


##### New logging platform abstraction:
- A new mechanism has been added to abstract out the
platform-specific logging mechanism. This is the final
piece of the core bootutil library that was not behind
a proper platform abstraction.


##### Kconfig for key management:
- A new, mandatory, CONFIG_BOOT_SIGNATURE_KEY_FILE knob
was added. This specifies a key file in .PEM format to
use when building MCUboot. This replaces hard-coded
keys formerly found in the MCUboot source code,
allowing MCUboot users to manage keys without having
to change the MCUboot source code.

If you're building MCUboot by hand, you will need to
either build MCUboot with a CONF_FILE overlay that
specifies the path to the key file you would like to
use, or edit the prj.conf to uncomment the examples in
there. If you're using the zmp tool, the default
demonstration key is specified using an overlay
generated at runtime; you can use your own keys with
the -K / --signing-key option to "zmp build".


#### Bugs

##### Miscellaneous fixes:
- Miscellaneous fixes and cleanups include clearing out
old image header format cruft from v1 in the
assemble.py script, a trailer size calculation fix
elsewhere, and more.



### Zephyr


#### Features

##### Continuous Integration:
- Sanitycheck can now export tests in CSV format.


#### Bugs

##### Arches:
- A variety of ARC fixes were merged. These fix
overflows in the privileged stack, IRQ offloading, the
ADC and watchdog timer priority levels, reset
instability, and a couple of issues related to
exception handling.

A bug preventing i.MX RT SoCs from booting correctly
was fixed as well; this also has the nice benefit of
eliminating a vast number of Kconfig warnings emitted
when building for other boards.



##### Bluetooth:
- A fix for a Coverity bug related to corrupted flash
storage of persistent settings was merged, along with
a fix to retransmit interval handling in the Mesh
implementation, and an invalid pointer access after
disconnect in the ATT code.



##### Build:
- A fix to the kernel helpers for the GCC toolchain was
merged which resolves unaligned access issues on GCC
>= 7.



##### Continuous Integration:
- A sanitycheck bug leading to false positive test pass
reporting was fixed.



##### Documentation:
- The final batch of documentation patches covered
release notes, issues in the Getting Started guide,
initial documentation for the experimental West meta-
tool, updates to the security documentation, and some
watchdog API documentation.



##### Kernel:
- Architecture-specific attempts to provide thread
arguments using its initial stack layout were replaced
with common code, trading off extra memory to fix
broken and incomplete implementations in some
architectures.



##### Libraries:
- A fix was merged for a readdir() buffer out of bounds
access discovered by Coverity.



##### Networking:
- An LWM2M bug was fixed which fixes mandatory rate
limiting on the frequency of notifications for
observed object instance attributes. The LWM2M engine
thread priority was also lowered, fixing a thread
starvation issue when running LWM2M concurrently with
Bluetooth (e.g. as part of a 6LoWPAN setup).

The IPv4 stack now correctly updates the time-to-live
value based on the received packet header; a similar
fix was merged for IPv6 hop limits.



##### Samples:
- Some last-minute changes were merged to crypto and
networking samples.

The crypto changes appear to have been merged because
samples/drivers/crypto is in fact being used as a test
case in addition to serving as sample code, so they
perhaps could be considered test fixes.

The networking changes were fixes for bugs discovered
by Coverity.



##### Testing:
- A variety of patches fixing up and tuning the test
cases were merged in the final days of v1.12
development.



##### Foundries.io patches: 
- A minor change to the WCN14A2A LTE-M modem's Kconfig
was merged, fixing what is currently a Kconfiglib
warning that upstream has subsequently upgraded to an
error.



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

OSF Unified Linux Kernel updated to the 4.16.15 stable release.
U-Boot-Fslc updated to the 2018.05-based release.
Core layer updates based on the latest Yocto master changes.

## Highlights

- OSF Unified Linux Kernel updated to 4.16.15.
- U-Boot-Fslc updated to the 2018.05-based release.

## Components


### Meta Freescale


#### Features

##### Layer Update:
- U-boot-fslc updated to the 2018.05-based release.
New i.MX fork for gstreamer1.0, gstreamer1.0-plugins-base,
gstreamer1.0-plugins-good and gstreamer1.0-plugins-bad.
Imx-codec, imx-parser, imx-vpuwrap and imx-gst1.0-plugin
updated to v4.3.4.
Imx-usb-loader updated to the e539461 revision.


#### Bugs
- Not addressed in this update

### Meta Freescale 3rdparty


#### Features

##### Layer Update:
- Device tree name updated for imx7d-pico.
Updated u-boot configuration for imx7s-warp.


#### Bugs
- Not addressed in this update

### Meta Intel


#### Features

##### Layer Update:
- New WKS file enabling grub-efi bootloader.
Thermald updated to 1.7.2.


#### Bugs
- Not addressed in this update

### Meta Qualcomm


#### Features

##### Layer Update:
- Updated bootr and bootrr to the latest revision available.


#### Bugs
- Not addressed in this update

### Meta RaspberryPi


#### Features

##### Layer Update:
- Support for the at86rf233 device tree overlay.


#### Bugs
- Not addressed in this update

### Meta Virtualization


#### Features

##### Layer Update:
- Lxc updated to 3.0.1.
Libvirt updated to v4.3.0.
Added tini 0.18.0 recipe to provide docker-init.


#### Bugs
- Not addressed in this update

### Meta Updater Layer


#### Features

##### Layer Update:
- HTTP basic auth added to the garage-sign task.
Aktualizr updated to the latest revision available,
including support to log the ostree update process.


#### Bugs
- Not addressed in this update

### Meta OSF Layer


#### Features

##### Layer Update:
- OSF Unified Linux Kernel updated to 4.16.15.
Added lmp-device-register recipe, used to register an LMP
device with OSF OTA+.
Haveged included in lmp-mini-image and lmp-gateway-image
to remedy low-entropy during boot.
Fbdev MXS driver removed from linux-osf in favor of the
drm driver.
Python3-requests removed from lmp-mini-image as device
registration is now done via lmp-device-register.


#### Bugs
- Not addressed in this update
