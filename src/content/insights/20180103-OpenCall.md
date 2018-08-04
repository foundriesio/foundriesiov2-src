+++
title = "Jan 3, 2018 - microPlatform OpenCall meeting minutes"
date = "2018-01-03"
tags = ["linux", "zephyr", "update", "microplatform", "ble"]
categories = ["minutes", "microPlatform"]
banner = "img/banners/opencall010318.png"
+++

OSF is now 3 months old and the microPlatforms are reaching full speed.  We are working on a few final work items before we move from limited beta to a public beta state for the Zephyr and Linux microPlatforms.
<!--more-->
## New BLE Dongle efforts

For our initial radio technology, we have chosen BLE (Bluetooth Low Energy) as it is the most mature and public radio technology that is available in both Linux and Zephyr projects.  On most of the boards we have used we have found critical bugs with the proprietary BLE radio code, but with the UART/ACHI sample code already in Zephyr and a capable Nordic NRF52 module available on the BLE Nano 2, we now have a fully functional and surprisingly stable BLE Dongle that we can use with our host.

Todo:
* Integrate sample code with MCUBOOT so we can use 'zmp build' and 'zmp flash' commands
* Release documentation to use the BLE Nano 2 + BLE Nano 2 programmer board as a peripheral BLE dongle

## Linux microPlatform

__Kernel:__

Current efforts are working on preparing and releasing an update for the microPlatforms that transitions to the Linux microPlatform to use the 4.14 Linux Kernel.  This effort is in final testing and integration and we expect a microPlatform update to be released in a matter of days.

__Source code mirrors:__

The microPlatform is based on software and source code made available by upstream projects and hardware manufacturers.  To ensure that the microPlatform can always be built from source we have created some OSF mirrors that will provide a higher level of service so that OSF subscribers will always be able to build the microPlatforms from source, even in the event that the upstream repositories may not be reachable.

Recent issues addressed:

* We have found that enabling the UART on the Raspberry PI 3 causes significant system instability, including BLE performance.  We are now recommending doing no system validation with UART enabled on the Raspberry PI 3.  This causes some problems with automation as a LAVA-based automation requires UART for controlling the device under test.  We are working on enabling Raspberry PI 3 testing by using a combination of UART and SSH rather than just UART.

## Zephyr microPlatform

__Grove sensor troubleshooting:__

We have done some initial preparation work to enable generic analog to digital sensor integration into Zephyr.  We are currently working to propose some fixes to Zephyr to fix some of the infrastructure problems upstream, but we expect to have a Zephyr microPlatform demo that has a minimal set of out of tree patches available soon.

__Encrypted communication:__

When we build connected devices we want to have reference samples that are securable, and a fundamental requirement is to support encrypted communication protocols.  Of course on a constrained device, the memory limits make this quite a challenge and we are working on how to best enable Zephyr TCP (TLS) and UDP (DTLS) encryption.

__Key storage:__

As we work towards a reference design for secure communication,  we are working with FCB / Flash Circular Buffer (https://mynewt.apache.org/latest/os/modules/fcb/fcb/) integration within Zephyr.  There is an initial patch in review and we hope to enable our sample applications to use FCB for key storage soon.

## Upcoming Events

* January Engineering Sprint - Austin TX, January 15 - 17
* Embedded World 2018 - February 27 - March 1
* Embedded Linux Conference - March 12 - 14
