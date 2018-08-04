+++
title = "microPlatform update 0.11"
date = "2018-03-20"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.11

This update includes Zephyr's official v1.11 release, along with
some MCUboot changes which are required to keep compatibility with
a Zephyr API change.

The sample applications have turned off some unnecessary Bluetooth
options, saving approximately 4 KB.


## Linux microPlatform changes for 0.11

No changes have gone into the LMP since 0.10.
<!--more-->
# Zephyr microPlatform

## Summary

This update includes Zephyr's official v1.11 release, along with
some MCUboot changes which are required to keep compatibility with
a Zephyr API change.

The sample applications have turned off some unnecessary Bluetooth
options, saving approximately 4 KB.

## Highlights

- Zephyr version 1.11
- Compatibility updates to MCUboot
- Flash savings in the sample applications

## Components


### MCUboot


#### Features

##### Zephyr API change: 
- The main stack pointer on ARM targets is now set with
__set_MSP instead of _MspSet. The latter has been
removed from Zephyr; the former is available from
CMSIS and will work with new and old Zephyr trees.


#### Bugs

##### Arduino 101 build fix: 
- The arduino_101 build was fixed by fixing the .conf
overlay directory on Zephyr targets.



### Zephyr


#### Features

##### Version 1.11.0: 
- This merges the Zephyr v1.11.0 release into the OSF
tree. This is the last commit which will be drawn from
the v1.11 development series. The next commit in this
tree will be a non-fast-forward update to the v1.12
development series. Since the previous mergeup was
based on a v1.11 release candidate, only stabilization
changes and fixes have been merged.


##### FRDM-K64F testing: 
- The ARM based FRDM-K64F board is now build-tested by
default in sanitycheck. This will help avoid build
regressions for more complex features, such as those
used by Zephyr's userspace support.


##### Linux Foundation Bluetooth company ID: 
- Bluetooth Mesh now uses the Linux Foundation company
ID.


##### UART6 for 96b_carbon: 
- UART6 support was added to 96b_carbon.


##### POSIX semaphore API: 
- A POSIX API for semaphores was merged, continuing the
POSIX API compatibility support effort.


#### Bugs
- Not addressed in this update

### hawkBit and MQTT sample application


#### Features

##### Flash savings: 
- Unnecessary Bluetooth options were disabled, saving
approximately 4KB of flash.


#### Bugs
- Not addressed in this update

### LWM2M sample application


#### Features

##### Flash savings: 
- Unnecessary Bluetooth options were disabled, saving
approximately 4KB of flash.


#### Bugs
- Not addressed in this update
# Linux microPlatform

## Summary

No changes have gone into the LMP since 0.10.
## Highlights

- No changes have gone into the LMP since 0.10.

## Components


