+++
title = "Zephyr microPlatform, Zephyr OTA via DFU/mcumgr"
date = "2018-04-17"
tags = ["zmp", "ota", "open source"]
categories = ["zmp", "FOTA"]
banner = "img/banners/ota.png"
+++

In this blog we describe how to use the Zephyr microPlatform and the in-tree
Zephyr samples to build, flash and perform an over the air (OTA) update of a
Zephyr application over Bluetooth Low Energy (BLE).  This demonstration uses the
DFU support within Zephyr provided by
[mcumgr](http://docs.zephyrproject.org/subsystems/mgmt.html).

<!--more-->

# Overview

Before getting started, some of the features described in this blog require
accessing features released to subscribers of the Zephyr microPlatform.  You can
find out more about subscriptions at:
[https://app.foundries.io](https://app.foundries.io).

In this blog, we will prepare will prepare developer's workstation to use the
Zephyr microPlatform; deploy our initial code to an
[nRF52840-DK](https://www.nordicsemi.com/eng/Products/nRF52840-DK) dev board,
and then deploy new code to the device using an OTA update.


## Install the Zephyr microPlatform:

   Please refer to our documentation to install the Zephyr microPlatform at:
   [https://app.foundries.io/mp/zmp/latest/docs/tutorial/installation-zephyr.html](https://app.foundries.io/mp/zmp/latest/docs/tutorial/installation-zephyr.html)

   __NOTE:__ in this blog, we use the nRF52840-DK board instead of the BLE Nano
   2 used by default in the documentation. To use the nRF52840-DK, the following
   changes are needed:

   - Use "-b nrf52840_pca10056" instead of "-b nrf52_blenano2" when running ZMP

   - Install the [nRF5x command line
     tools](http://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.tools%2Fdita%2Ftools%2Fnrf5x_command_line_tools%2Fnrf5x_nrfjprogexe.html),
     instead of PyOCD.

## Install mcumgr on your development workstation

  Install the mcumgr application using "go get" (requires Go 1.7 or later):

     $ go get github.com/apache/mynewt-mcumgr-cli/mcumgr

   Make sure ~/go/bin is on the PATH of the user that runs the "mcumgr"
   commands.

## Build and flash the smp_svr application

   With your device console connected (115200 baud, 8N1), build and flash the
   smp_svr application, which allows DFU firmware update via BLE:


     $ ./zmp build -b nrf52840_pca10056 zephyr/samples/subsys/mgmt/mcumgr/smp_svr/
     $ ./zmp flash -b nrf52840_pca10056 zephyr/samples/subsys/mgmt/mcumgr/smp_svr/

   If the flash step fails, make sure your NRF52840-DK is connected via USB. One
   way to check is to make sure running "nrfjprog --ids" lists the board's ID.

   The console output should look like this:

       ***** Booting Zephyr OS v1.1.0-52-g5bac42f *****
       [MCUBOOT] [INF] main: Starting bootloader
       [MCUBOOT] [INF] boot_status_source: Image 0: magic=unset, copy_done=0xff, image_ok=0xff
       [MCUBOOT] [INF] boot_status_source: Scratch: magic=unset, copy_done=0x0, image_ok=0xff
       [MCUBOOT] [INF] boot_status_source: Boot source: slot 0
       [MCUBOOT] [INF] boot_swap_type: Swap type: none
       [MCUBOOT] [ERR] main: Unable to find bootable image
       ***** Booting Zephyr OS v1.1.0-52-g5bac42f *****
       [MCUBOOT] [INF] main: Starting bootloader
       [MCUBOOT] [INF] boot_status_source: Image 0: magic=unset, copy_done=0xff, image_ok=0xff
       [MCUBOOT] [INF] boot_status_source: Scratch: magic=unset, copy_done=0x0, image_ok=0xff
       [MCUBOOT] [INF] boot_status_source: Boot source: slot 0
       [MCUBOOT] [INF] boot_swap_type: Swap type: none
       [MCUBOOT] [INF] main: Bootloader chainload address offset: 0xc000
       [MCUBOOT] [INF] main: Jumping to the first image slot
       ***** Booting Zephyr OS v1.11.0-633-g973b01a68 *****
       Zephyr Shell, Zephyr version: 1.11.99
       Type 'help' for a list of available commands
       shell> Bluetooth initialized
       Advertising successfully started

## Manage the device using mcumgr

In this section you will connect, update and query the device using mcumgr.

__Connect to the device using mcumgr__

   These commands generally have to be run as root (commands run as root instead
   of your normal user are prefixed with `#` instead of `$` in this blog post).
   First make sure mcumgr is in root's PATH.

     $ sudo -s
     # export PATH=$PATH:/home/YOUR_USERNAME/go/bin

   Now verify you can connect to your device.

   __Note:__ In this demo we are referencing hci0 which may be different on
   your system.  For the demo to work, you will need a Bluetooth 4.0
   compatible adapter and a recent Linux distribution (we performed this demo
   with Ubuntu 17.10) with 'bluez' installed.  Once you install bluez, you can
   identify your device using the 'hciconfig' utility.

     # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' echo hello
     hello

   If that doesn't work, make sure a 'Zephyr' device shows up in your 'hcitool
   lescan' output and try again.

   If you get errors like "Error: NMP timeout" when running mcumgr, reset your
   device and try again using nrfjprog:

     $ nrfjprog --reset

__Verify that only one application image is installed.__

   Use the following command to check the set of available Zephyr images on your
   device.

    # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' image list
    Images:
    slot=0
       version: 0.0.0
       bootable: true
       flags: active confirmed
       hash: c7567dd9b84d15ddb4345e38435822ef102f5d1683e8425d5447bafd5cb15c11

__Modify the sample application and perform an OTA update__

   Edit the file zephyr/samples/subsys/mgmt/mcumgr/smp_svr/src/main.c, adding
   a printline to the main() function:

    printk("This application has been updated\n");

   Now re-build it with a different version number using zmp.

   *Important: do this from a __non-root__ shell*:

    $ ./zmp build -b nrf52840_pca10056 --imgtool-version 0.1.0 zephyr/samples/subsys/mgmt/mcumgr/smp_svr

   From the root shell, upload the modified image to your device:

    # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' image upload outdir/zephyr/samples/subsys/mgmt/mcumgr/smp_svr/nrf52840_pca10056/app/zephyr/smp_svr-nrf52840_pca10056-signed.bin

__Query the device and make sure 0.1.0 is visible:__

    # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' image list
    Images:
    slot=0
       version: 0.0.0
       bootable: true
       flags: active confirmed
       hash: c7567dd9b84d15ddb4345e38435822ef102f5d1683e8425d5447bafd5cb15c11
    slot=1
       version: 0.1.0
       bootable: true
       flags:
       hash: 7806e0a1239aa772f3c1c9ea121c8c95d485fc38b2b3bb930275b63a7962f938
    Split status: N/A (0)

   Note the presence of an update image in slot 1 with updated image version
   `0.1.0`, which corresponds to the value of the `--imgtool-version` argument
   you passed to `zmp build` earlier.

__Confirm the update__

   "Confirm" the slot 1 image by SHA. This will make the bootloader, MCUboot,
   install it during the next boot. From the above example,

    # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' image test 7806e0a1239aa772f3c1c9ea121c8c95d485fc38b2b3bb930275b63a7962f938
    Images:
    slot=0
       version: 0.0.0
       bootable: true
       flags: active confirmed
       hash: c7567dd9b84d15ddb4345e38435822ef102f5d1683e8425d5447bafd5cb15c11
    slot=1
       version: 0.1.0
       bootable: true
       flags: pending
       hash: 7806e0a1239aa772f3c1c9ea121c8c95d485fc38b2b3bb930275b63a7962f938
    Split status: N/A (0)

   Note how the `flags` field now says `pending`. This means the update image
   will be used at the next device reset.

__Reboot the device using DFU:__

    # mcumgr --conntype ble --connstring ctlr_name=hci0,peer_name='Zephyr' reset

   You will see bootloader output confirming MCUboot is swapping into the new
   image, then see the new printline with the string `This application has been
   updated`:

     ***** Booting Zephyr OS v1.1.0-52-g5bac42f *****
     [MCUBOOT] [INF] main: Starting bootloader
     [MCUBOOT] [INF] boot_status_source: Image 0: magic=unset, copy_done=0xff, image_ok=0xff
     [MCUBOOT] [INF] boot_status_source: Scratch: magic=unset, copy_done=0x0, image_ok=0xff
     [MCUBOOT] [INF] boot_status_source: Boot source: slot 0
     [MCUBOOT] [INF] boot_swap_type: Swap type: test
     [MCUBOOT] [INF] main: Bootloader chainload address offset: 0xc000
     [MCUBOOT] [INF] main: Jumping to the first image slot
     ***** Booting Zephyr OS v1.11.0-633-g973b01a68 *****
     Zephyr Shell, Zephyr version: 1.11.99
     Type 'help' for a list of available commands
     shell> This application has been updated
     Bluetooth initialized
     Advertising successfully started

   Since the updated application also supports the mcumgr protocol, you can make
   additional changes and update it with a third version using the above steps.
