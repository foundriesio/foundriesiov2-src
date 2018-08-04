+++
title = "microPlatform update 0.6"
date = "2018-01-10"
tags = ["linux", "zephyr", "update", "cve", "bugs"]
categories = ["updates", "microPlatform"]
banner = "img/banners/update.png"
+++

# Summary

## Zephyr microPlatform changes for 0.6

The most significant change in this update follows the Linux
microPlatform switch to a Linux v4.14-based tree. This impacts
compatibility with any gateways relying on the old Bluetooth
behavior, and also will cause changes to the MAC addresses reported
by the Zephyr microPlatform sample applications. Users of the
bt-joiner container whitelist feature in the Linux microPlatform
will need to update their whitelists. Specifically, the leading
D6:E7 in the MAC addresses must be changed to D4:E7.


## Linux microPlatform changes for 0.6

OSF Unified Linux Kernel was updated to the 4.14 series. The Linux Kernel
update also includes changes required to properly implement RFC 766 (IPv6 over
Bluetooth Low Energy), causing incompatibilities with Zephyr devices using the
NET_L2_BT_ZEP1656 Zephyr workaround (required for kernels older than 4.12).

<!--more-->
# Zephyr microPlatform

## Summary

The most significant change in this update follows the Linux
microPlatform switch to a Linux v4.14-based tree. This impacts
compatibility with any gateways relying on the old Bluetooth
behavior, and also will cause changes to the MAC addresses reported
by the Zephyr microPlatform sample applications. Users of the
bt-joiner container whitelist feature in the Linux microPlatform
will need to update their whitelists. Specifically, the leading
D6:E7 in the MAC addresses must be changed to D4:E7.

## Highlights

- Bluetooth behaviors impacting MAC addresses are changed following Linux microPlatform update

## Components


### MCUBoot


#### Features
- Not addressed in this update

#### Bugs
- Not addressed in this update

### Zephyr


#### Features
- Not addressed in this update

#### Bugs

##### LWM2M packet fix: 
- The LWM2M stack includes a fix which prevents a packet
which may need to be retransmitted from being freed
until after this retransmission has completed, if necessary.



### Zephyr FOTA Samples


#### Features

##### CONFIG_NET_L2_BT_ZEP1656 disabled: 
- This obscure option was used to preserve compatibility
contrary to the Bluetooth specification with
implementation characteristics in the Linux kernel. Now
that the upstream Linux microPlatform was updated to
v4.14, which has fixes for these characteristics, the
option can be disabled.


##### dm-hawkbit-mqtt cleanups and optimizations: 
- Various confusing implementation details in this
application have been fixed and otherwise cleaned
up. The resulting application now requires less memory.


#### Bugs

##### Packet pool workaround for MQTT: 
- The dm-hawkbit-mqttt sample now uses an extra packet
pool when the underlying link layer is Bluetooth. This
keeps the network stack working in the face of IPv6
packet header compression.


# Linux microPlatform

## Summary

OSF Unified Linux Kernel was updated to the 4.14 series. The Linux Kernel
update also includes changes required to properly implement RFC 766 (IPv6 over
Bluetooth Low Energy), causing incompatibilities with Zephyr devices using the
NET_L2_BT_ZEP1656 Zephyr workaround (required for kernels older than 4.12).

## Highlights

- OSF Unified Linux Kernel updated to the 4.14 series (4.14.7)

## Components


### Meta OSF Layer


#### Features

##### Layer Update: 
- OSF Unified Linux Kernel updated to the 4.14 series (4.14.7).


#### Bugs
- Not addressed in this update
