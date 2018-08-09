+++
title = "Using AT&T's IoT Dev Kit"
date = "2018-04-11"
tags = ["lwm2m", "LTE", "AT&T", "ota", "update", "open source"]
categories = ["FOTA", "demos", "Zephyr mP"]
banner = "img/banners/lwm2m.png"
+++

In the Zephyr microPlatform update 0.13, we have released support for the
[AT&T IoT Starter Kit (LTE-M)](https://marketplace.att.com/products/att-iot-starter-kit-lte-m).

With the following instructions, you can start using Zephyr and the IoT Starter Kit with LWM2M in a matter of minutes.
<!--more-->

## Hardware Requirements

* [AT&T IoT Starter Kit (LTE-M)](https://marketplace.att.com/products/att-iot-starter-kit-lte-m)

## AT&T device setup

To provision your device for use on AT&T's network, you will need to follow the AT&T guide available here:

https://marketplace.att.com/products/att-iot-starter-kit-lte-m

Key items include:

* Update the firmware on the WCN14A2A modem: https://s3-us-west-2.amazonaws.com/starterkit-assets/LTE-M.Firmware.Upgrade.Guide.pdf

* Register your AT&T IoT Starter Kit:
  http://cloudconnectkits.org/. Note that the "SERIAL KIT NUMBER"
  requested by Avnet is the "S/N" field printed on the sticker of
  board identifiers on the IOT Starter Kit (for pictures, refer to the
  Getting Started Guide linked to below).

* Register your AT&T SIM: https://marketplace.att.com/app/register-sims. You may need to create a standalone account with AT&T rather than using OAuth login with one of your existing logins.

* Assemble and power the device, using instructions in the Getting Started Guide: https://marketplace.att.com/tutorials/starter-kit-guide (login required).

* Download any additional documentation you are interested in: http://cloudconnectkits.org/product/att-cellular-iot-starter-kit#tabs-related_parts_and_documentation-middle

## Zephyr microPlatform Software Requirements

* As this support is part of a subscriber update, you'll need to set up a subscription account on https://app.foundries.io.
* [Install the Zephyr microplatform](https://app.foundries.io/docs/latest/tutorial/installation-zephyr.html). You're using FRDM-K64F instead of BLE Nano 2, but you must still install PyOCD. Make sure to use `-b frdm_k64f` instead of `-b nrf52_blenano2` in any `zmp` command lines.

__Enable Logging and network subsystem__

In your Zephyr microlatform installation directory, create the file zephyr-fota-samples/dm-lwm2m/boards/frdm_k64f-local.conf with the following contents:

```
# This setting is not important, it is used to configure the network subsystem
# For this application's default configuration, which isn't what you're using here.
CONFIG_NET_APP_MY_IPV4_ADDR="192.168.0.99"

# Optional configuration options, uncomment to show more debug output:
#CONFIG_SYS_LOG_EXT_HOOK=n
#CONFIG_SYS_LOG_MODEM_LEVEL=4
```

__Build and flash the sample to the Freedom K64F board (from the IoT Dev Kit)__

Connect the FRDM-K64F to the workstation where you have installed the
Zephyr microPlatform, and connect to its console device at 115200 baud, 8N1.

Now, run these commands from its installation directory:

```
./zmp build --board frdm_k64f --overlay-config "boards/wcn14a2a.conf" zephyr-fota-samples/dm-lwm2m
./zmp flash --board frdm_k64f zephyr-fota-samples/dm-lwm2m
```

The console may pause for about a minute after the bootloader starts
the application, during modem initialization. (A future Zephyr
microPlatform update will modify the application to print debug output
earlier.)

After modem initialization, the board will register via LWM2M to the
public Eclipse Leshan server at http://leshan.eclipse.org.

__Find your device id__

In the future we will provide an update that uses the modem IMEI as an
identifier, so the device is easier to see in the cloud Leshan server
it will register with.

For now, you will need to look for the `Registration Done (EP='')`
line in your board's console output:

```
[0731130] [lib/lwm2m_rd_client] [INF] do_registration_reply_cb: Registration Done (EP='A1ENFQxI3j')
```

This will be the "Registration ID" on the Leshan client list at
http://leshan.eclipse.org/#/clients.

__Confirm that Leshan UI displays your connected device__

Find your device in the Leshan client list, and select it.

Find the board under the "Client Endpoint" list.  The endpoint is
generated semi-randomly using unique data from the device to ensure
that each endpoint name is unique.

![Leshan Demo Server client list](../../../../../img/blog/leshan-client-list.png)

You can now interact with the device using LWM2M, as described in https://app.foundries.io/docs/latest/tutorial/basic-system.html#use-the-system.

**CAUTION: If you do not have good LTE signal, the device will not stay on-line for very long.**
