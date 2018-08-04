+++
title = "How To Manage LMP Containers"
date = "2018-01-17T13:50:46+02:00"
tags = ["linux", "docker", "microPlatform"]
categories = ["quickstart","linux","microPlatform"]
banner = "img/banners/docker.png"
+++

The Linux microPlatform uses a set of Docker containers to provide end-to-end
services used by the Zephyr microPlatform. The containers and their
configurations are deployed using a simple [shell script]
(https://github.com/OpenSourceFoundries/gateway-ansible) that wraps
[Ansible](https://www.ansible.com/). The scripts require a version of Ansible
with Docker support. Some distro packages such as Ubuntu 16.04 don't have this,
so make sure you install Ansible from a [proper source](http://docs.ansible.com/ansible/latest/intro_installation.html)
before continuing.
<!--more-->
```
		+------------+      +-------------+
		|            |      |             |
		| LMP Device |      | Host System |
		|  10.10.0.10|      |  10.10.0.12 |
		|            |      | (eg laptop) |
		+------------+      +-------------+

```

## The Simple Case

In the most simple scenario, your device management system ([Hawkbit](https://app.foundries.io/docs/latest/iotfoundry/hawkbit-howto.html) or [Leshan](https://app.foundries.io/docs/latest/iotfoundry/lwm2m-howto.html))
will be running on your host system. In this case the script only needs to know
the IP address of your LMP device to set it up:
```
REGISTRY=hub.docker.com GW_HOSTNAME=10.10.0.10 ./iot-gateway.sh
```

## Specifying The Device Management Server's IP

The previous script works by trying to guess the externally routable IP of your
host system. If this probing is guessing your IP incorrectly or you run this
service on another system, it can explicitly set it with:
```
REGISTRY=hub.docker.com GW_HOSTNAME=10.10.0.10 MGMT_SERVER=10.10.0.10 ./iot-gateway.sh
```

## Using an Alternative Docker Registry

The script also supports passing a username and password to authenticate with
a secured Docker registry when needed:
```
REGISTRY=YOUR_SECURE_REGISTRY GW_HOSTNAME=10.10.0.10 REGISTRY_USER=<USER> REGISTRY_PASSWD=<PASS> ./iot-gateway.sh
```
