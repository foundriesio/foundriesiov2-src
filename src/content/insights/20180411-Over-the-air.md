+++
title = "Linux microPlatform, now with OTA updates (beta)"
date = "2018-04-11"
tags = ["lmp", "ota", "open source"]
categories = ["lmp", "FOTA"]
banner = "img/banners/ota.png"
+++

Starting with Linux microPlatform update 0.13, we are including support for over-the-air (OTA) updates.

<!--more-->

After extensive research, discussion in the embedded Linux community and a review of
the current Linux OTA solutions, we concluded that update systems should be protected
by comprehensive update frameworks that are designed to protect against known exploits
at a minimum.

Through advanced key management practices, [TUF](https://theupdateframework.github.io/)
(the update framework) and [UPTANE](https://uptane.github.io/) (TUF principles adapted
to safety critical / automotive embedded systems) provide solid foundations against
many of today's most malicious attacks.

* Arbitrary installation attacks.
* Endless data attacks.
* Extraneous dependencies attacks.
* Fast-forward attacks.
* Indefinite freeze attacks.
* Malicious mirrors preventing updates.
* Mix-and-match attacks.
* Rollback attacks.
* Slow retrieval attacks.
* Vulnerability to key compromises.
* Wrong software installation.

During our investigations we started working with the team at Advanced Telematics
(acquired by [HERE technologies](https://www.here.com/en) in 2018) and started learning
about their update platform that was used in Automotive Grade Linux,
["ATS Garage"](https://app.atsgarage.com/login).  In January 2018, the team released their
platform as an open source project, [OTA Community Edition](https://github.com/advancedtelematic/ota-community-edition)
and we went to work integrating with the system as it provides, what we believe is
the highest level of security for embedded system software updates.

We won't go into all of the details right now, but you can find out more from the following links:

* Documentation available at: https://docs.atsgarage.com/usage/devices.html
* Source code available at: https://github.com/advancedtelematic/ota-community-edition

## Overview

* As this support is part of a subscriber update, you'll need to setup a
subscription account on [https://app.foundries.io](https://app.foundries.io)
* Get a supported hardware development platform (Raspberry Pi 3, DragonBoard-410c,
DragonBoard-820c, Toradex Colibri iMX7D, Solidrun HummingBoard 2, Compulab IoT Gate,
Beaglebone Black Wireless, x86)
* Download the latest system image: https://app.foundries.io/mp/lmp/latest/artifacts/
(0.13 and later will be OTA ready)
* Install the Linux microPlatform
* Upload an OS to ATS Garage for deployment
* Provision your device
* Upload a second OS to ATS Garage
* Deploy the new OS to your device(s)
* Reboot to activate the new image

## ATS Garage

To get started updating your Linux microPlatform devices follow these instructions:

__Install the Linux microPlatform__

    NOTE: You must use update 0.13 or newer builds with the OSTree repo

Follow the documentation to [install the Linux microPlatform](https://app.foundries.io/docs/latest/tutorial/installation-linux.html).
With a running Linux microPlatform system, follow the next steps to provision your device on ATS Garage.

__Create an ATS Garage Account__

Create an ATS Garage account at https://app.atsgarage.com/ .

__Create your ATS Garage credentials__

Generate your auto provisioning credentials at https://app.atsgarage.com/#/profile/access-keys

Once you generate your credentials you can use the same credentials on many
devices. These credentials are used to generate device-specific keys during
initial device provisioning and to sign the OSTree repository when you upload
the repo to ATS garage.

__Push the Linux microPlatform image to ATS garage__

You can use a command line tool to sign and publish the artifacts of a build to
ATS Garage (e.g. for Raspberry Pi 3)

* Create a clean directory with your credentials.zip file and the OSTree Repo

    ```
$ mkdir lmp
$ cd lmp
    ```

* Download your ATS Garage credentials file (https://app.atsgarage.com/#/profile/access-keys) and make it available in a local folder

* Download and extract microPlatform OSTree repository tarball from a specific LMP build number (e.g. https://app.foundries.io/mp/lmp/0.13/artifacts/supported-raspberrypi3-64/other/raspberrypi3-64-ostree_repo.tar.bz2)

    ```
$ tar -jxvf raspberrypi3-64-ostree_repo.tar.bz2
    ```

* Identify the image version ID from the running LMP system if provisioning your device for the first time
  - This is required to avoid a version mismatch between the running system and the uploaded image
  - In a future update this step will not be required

    ```
raspberrypi3-64:~$ sed -e "s/.*lmp-//" -e "s/\"}//" /var/sota/installed_versions
283
    ```

* Set the version ID for the uploaded image
  - Same as described in the previous step if provisioning for the first time
  - When uploading additional image updates just use the microPlatform update version instead (e.g. 0.14)

    ```
$ VERSION=283
    ```

* Run our image publishing script using a docker container in order to sign and push the image to ATS Garage

    ```
$ docker run --rm -it -v $PWD:/build --workdir=/build opensourcefoundries/aktualizr \
      ota-publish -m raspberrypi3-64 -c credentials.zip -r ostree_repo -v $VERSION
    ```

In case of upload errors (e.g. OSTree fetch error: 502), please make sure to retry a few more times as the server might be overloaded.

__Verify the Package can be viewed on the ATS Garage__

Browse to: https://app.atsgarage.com/#/packages/raspberrypi3-64-lmp

## Device configuration

Now that we have an update loaded into ATS garage, we will provision the device, we
are using the Raspberry Pi 3 for demonstration purposes, though the other boards can
also be used.

__Copy and start the Aktualizr client daemon__

on your host machine:
```
$ scp credentials.zip osf@raspberrypi3-64.local:~/
```

on your target machine: (ssh to the system)
```
$ sudo mv credentials.zip /var/sota/sota_provisioning_credentials.zip
$ sudo cp /usr/lib/sota/sota_autoprov.toml /var/sota/sota.toml

# Note: Aktualizr will start automatically once it finds /var/sota/sota.toml
```

__Browse to your ATS Garage account and manage the device's root filysystem__

If everything goes right, your device will auto-register to the ATS Garage system.
This may take a few minutes.

You can begin managing the system the moment you upload the next update.  At
Foundries.io we produce OS updates about every 10 days, so one will be
available soon.

Once you upload a second image to ATS Garage, you can initiate an OS upgrade from
the ATS web system and then reboot the target device to activate the image.

Further documentation will be available soon.

# Issues and observations

## Watching the aktualizr logs

If you are having a problem with the device connecting to ATS garage, you can
watch the client logs with the following commands

```
sudo journalctl -f -u aktualizr.service
```

## Device fails to show up on ATS garage

We have recently noticed a variety of timeouts when communicating with ATS
garage.  From our experience, most of these timeouts and communication failures
will self-recover.  If you notice a delay in device communication or
registration you can review the aktualizr client logs (see above).

A sample set of errors that seem to be recoverable may look like:

```
Apr 26 17:15:18 raspberrypi3-64 aktualizr[592]: curl error 28 (http code 0): Timeout was reached
Apr 26 17:15:19 raspberrypi3-64 aktualizr[592]: curl error 35 (http code 0): SSL connect error

```


## Device fails to sync and kRejectAll observed

We have noticed that from time to time, the aktualizr client delivered in
update 0.13 is susceptible to an issue that has been fixed in 0.14 and later
microPlatform updates.

The issue, which has been fixed in the upstream aktualizr client, puts the
device into a state where it can not take an update.

To work around this issue you can use the following commands to modify the
SQLite database.

```
# stop the aktualizr service
sudo systemctl stop aktualizr.service

# remove the 'meta' table from the sqlite database
docker run -v /var/sota/sql.db:/sql.db opensourcefoundries/utilities sqlite3 /sql.db "drop table meta;"

# start the aktualizer service
sudo systemctl start aktualizr.service

# OPTIONAL: you can watch the aktualizr logs to verify the connection
sudo journalctl -f -u aktualizr.service
```
