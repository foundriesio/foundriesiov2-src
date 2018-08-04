+++
title = "microPlatform update 0.5"
date = "2018-01-04"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.5

The major change in this update is a non-fast-forward Zephyr
repository tree based on the upstream 1.11 development tree.


## Linux microPlatform changes for 0.5

Raspberry Pi 3 kernel was updated to use the same OSF distro configuration
fragment as used by the other machines.

<!--more-->
# Zephyr microPlatform

## Summary

The major change in this update is a non-fast-forward Zephyr
repository tree based on the upstream 1.11 development tree.

## Highlights

- **Non-fast-forward** Zephyr update to 1.11 development tree

## Components


### MCUBoot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features

##### Memory security improvements for ARC: 
- The ARC architecture has gained additional memory
security support.


##### I2C for STM32F0: 
- The STM32F0 SoC family gained I2C support.


##### New Bluetooth testing API and cases: 
- Bluetooth grew a new testing API, and several test cases
were merged.


##### Board support and peripheral enablement: 
- Various fixes and peripheral enablement in the boards,
across architectures.


##### Ethernet improvements for mcux driver: 
- The mcux ethernet driver now disables promiscuous mode
by default, and also implements IPv6 multicast group
joining/leaving.


##### Device tree bindings for sensors and I2C: 
- A generic yaml description for some sensors and I2C
devices was added to device tree, along with other
sensor- and I2C-related fixes.


##### Legacy cleanups: 
- Thread groups were removed from the kernel, along with
other cleanups in clocks and timers.


##### Flashing/debugging changes: 
- The flash and debug infrastructure has been reworked to
largely eliminate the use of environment variables. All
board files were affected. Out-of-tree boards will need
to be updated. Users of in-tree boards have been
updated. User workflows that use the old environment
variables will need updates.


##### size_report changes: 
- Similarly to the flashing and debugging changes, the
size_report script now uses command-line arguments
instead of environment variables. User workflows that
use the old environment variables will need updates.


#### Bugs

##### STM32F0 flash fixes: 
- The STM32F0 SoC family has fixes for the flash driver



##### LWM2M fixes: 
- Several network fixes were merged for the LWM2M library.



##### IEEE 802.15.4 fixes: 
- Fixes were merged for IEEE 802.15.4.



##### Some BT Mesh fixes: 
- A few fixes and improvements were made to the Bluetooth
Mesh app. The pace of fixes on this new feature appears
to be slowing down, indicating greater maturity.



### Zephyr FOTA Samples


#### Features
- Not addressed in this update

#### Bugs

##### Fixes for blockages in the TCP stack: 
- The dm-hawkbit-mqtt sample reduced the TCP retry count,
which prevents the TCP stack from blocking due to low
memory conditions when many retry packets are in flight.
This is a tradeoff between compliance with RFC
recommendations for retry time and a working system with
tight memory constraints.


# Linux microPlatform

## Summary

Raspberry Pi 3 kernel was updated to use the same OSF distro configuration
fragment as used by the other machines.

## Highlights

- Raspberry Pi 3 kernel configuration now uses the OSF config fragment

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- Raspberry Pi 3 kernel updated to use the OSF distro config
fragment.
Power off bluetooth interface during shutdown if enabled via
the btattach service.


#### Bugs
- Not addressed in this update
