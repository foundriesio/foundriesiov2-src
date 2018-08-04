+++
title = "Open Source Bluetooth Low Energy (BLE) USB dongle"
date = "2018-01-08"
tags = ["ble", "radio", "open source", "bugs"]
categories = ["Bluetooth", "Radio"]
banner = "img/banners/ble-dongle.png"
+++

Foundries.io has released binaries and source code for a Zephyr-based Bluetooth Low Energy USB dongle to the public.

<!--more-->

If you've ever had to ship a product, you know how frustrating a critical bug can be when your only driver is proprietary.  Many times, the problem may be in your code and not the vendor blob, but it is often a difficult journey to find the root cause.  Vendors have many customers, and finding the right technical contact takes time. At times, without a compelling business case, you may ultimately find that your use of the device is not "standard", putting your issue at the back of the line. This can even sometimes force you to source and integrate a different component.

With [Zephyr](https://www.zephyrproject.org/), we have taken a step forward where Bluetooth is concerned. We now have a completely open source, Apache 2.0 Licensed BLE solution from the host to the client, with vendors discussing nearly _ready for certification_ Bluetooth low energy radio stacks based on Zephyr.

Foundries.io has integrated this code for use with the [RedBear BLE Nano 2 Kit](https://redbear.cc/product/ble-nano-kit-2.html), which we use internally as a standalone USB Bluetooth dongle. We welcome the community to try out the sources and binaries provided below!

## Hardware Requirements

We currently use the RedBear BLE Nano v2 kit, which is based on an nRF52 chip and a companion DAPLink programmer. However, any nRF51/nRF52 board can be used, as long as you have a separate UART to USB converter that supports hardware flow control.  These include:

* Nordic [nRF51 DK](https://www.nordicsemi.com/eng/Products/nRF51-DK)
* Nordic [nRF52 DK](https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF52-DK)
* Nordic [nRF52840 Preview DK](https://www.nordicsemi.com/eng/Products/nRF52840-Preview-DK)
* RedBear [BLE Nano v1](http://redbearlab.com/blenano/) (nRF51-based)
* RedBear [BLE Nano v2](https://redbear.cc/product/ble-nano-kit-2.html) (nRF52)

## Unsupported / Pre-Release Binaries

For binaries, please see:

https://github.com/OpenSourceFoundries/zephyr-ble-dongle/releases

## Source and Setup Instructions

You will need to:

- Load updated firmware to the DAPLink board (this is the board that attaches to your computer via USB and is used to reprogram the nRF5 chip, as well as provide UART access. Don't worry; the updated firmware still provides the usual DAPLink functionality).
- Flash a Zephyr-based BLE dongle application to the nRF5 device which is plugged into the DAPLink programmer.
- Configure a Linux host to use the combined DAPLink/Nano as a BLE dongle.

### DAPLink Firmware Update

The stock DAPLink firmware provided with the BLE Nano 2 kit has several issues with the USB CDC UART interface. To use this with the dongle, a firmware update is required.

To update to the latest DAPLink firmware just follow the guide available at https://github.com/redbear/nRF5x/tree/master/USB-IF#daplink-usb-interface-daplink-v15 and enable flow control. (Note that we've provided a prebuilt version that we've used internally above.)

To install the firmware update:

- Press the button on the DAPLink board while plugging in your board. Make sure the button is pressed the entire time, from before you plug it in until it is mounted.
- The DAPLink will boot in a firmware update mode; the mount point will be named "MAINTENANCE".
- Drag and drop the updated DAPLink binary to the "MAINTENANCE" mount point.
- Your DAPLink device will then reboot in its usual mode; the mount point will be named "DAPLINK".

### Zephyr Application

The source code is simply the hci_uart sample within the Zephyr tree. However, you'll need to add a few configuration options.

Add the following to the file $ZEPHYR_BASE/samples/bluetooth/hci_uart/nrf5.conf.

```
 CONFIG_BT_CTLR_RX_BUFFERS=18
 CONFIG_BT_CTLR_TX_BUFFERS=19
 CONFIG_BT_CTLR_TX_BUFFER_SIZE=251
 CONFIG_BT_CTLR_DATA_LENGTH_MAX=251
 CONFIG_BT_HCI_CMD_COUNT=20
 CONFIG_BT_RX_BUF_COUNT=20
 CONFIG_BT_RX_BUF_LEN=264
```

You can also increase the number of connections above the default of 16 parallel bluetooth connections by changing CONFIG_BT_MAX_CONN in the same file.  We've had some success testing as many as 24 devices concurrently, but you'll want to verify this for your use cases. Additional RX/TX buffers and larger data lengths should also used for better performance, if sufficient RAM is available on your device.

Now build the hci_uart application using the modified nrf5.conf as the CONF_FILE. (Check out the Zephyr [Getting Started Guide](http://docs.zephyrproject.org/getting_started/getting_started.html) for build instructions if you're new to Zephyr.)

You can now drag and drop the hci_uart binary to the "DAPLINK" mount point. The nRF5 device will automatically reboot and act as a BLE dongle.

### Linux Host Configuration

To use the BLE dongle with a Linux computer, you need to configure the btattach service.

Instructions for systemd-based installations:

```
# Create bluetooth attach configuration file
cat << EOF > /etc/bluetooth/btattach.conf
HCITTY=/dev/ttyACM0
HCISPEED=1000000
HCIPROTO=h4
EOF

# restart btattach service
systemctl restart btattach.service
```

You may need to adjust HCITTY to another serial port if you have multiple available on your system.

And that's it. Enjoy!
