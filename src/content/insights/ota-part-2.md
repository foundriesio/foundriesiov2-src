+++
title = "What Is OTA Community Edition"
date = "2018-06-14"
tags = ["ota", "open source"]
categories = ["FOTA"]
banner = "img/banners/ota.png"
+++

Continuing with the [OTA blog series]({{< ref "ota-part-1.md" >}}), this article will explain what [OTA Community Edition](https://github.com/advancedtelematic/ota-community-edition) is and how it implements the TUF/Uptane/OSTree specifications.
<!--more-->

OTA Community Edition is open-source server software that supports devices compatible with [Aktualizr](https://github.com/advancedtelematic/aktualizr/). It has a micro-service architecture that's designed to be deployed inside Kubernetes. This article will explain the main micro-services, how they are related, and how easy they'd be to replace with another implementation. The services described are:

 * [TreeHub](https://github.com/advancedtelematic/treehub)
 * [Repo Server](https://github.com/advancedtelematic/ota-tuf/tree/master/reposerver)
 * [Director](https://github.com/advancedtelematic/director)
 * [Device Registry](https://github.com/advancedtelematic/ota-device-registry/)
 * [OTA+ Web](https://github.com/advancedtelematic/ota-plus-server)
 * Gateway

Take a look at [part 1]({{< ref "ota-part-1.md" >}}) of this blog series if you'd like a little more background on TUF and Uptane.

### TreeHub

The TreeHub is the easiest component to understand. It mostly operates like a web server handling static content. The server is responsible for returning the contents of objects request by a client. The default configuration deployed by OTA Community Edition uses a persistent storage volume. This means only one copy of the service can run and is thus a single point of failure. However, it also has support for [S3](https://github.com/advancedtelematic/treehub/blob/master/src/main/scala/com/advancedtelematic/treehub/object_store/S3BlobStore.scala) and could be configured to use S3 or a Google Storage Bucket in an HA friendly manner.

This server has no built-in HTTP security. If it's exposed publicly, anyone can push OSTree images to it. In order to host this securely, you'll want to put a reverse HTTP proxy in front of it. The garage-push tool supports three forms of authentication: [HTTP Basic, OAuth2, and SSL client certs](https://github.com/advancedtelematic/aktualizr/blob/master/src/sota_tools/authenticate.cc). So any server that honors those options will work seamlessly.

***Replaceability SWAG***: *Medium* - Most OSTree implementations are geared for static HTTP hosting on a single system or servers rsynced with each other. It wouldn't be too hard to write your own Kubernetes friendly web service that could do this.

### Repo Server

The Repo Server is part of the [OTA-TUF project](https://github.com/advancedtelematic/ota-tuf/) and handles TUF metadata files that describe the contents of the TreeHub. In terms of the Foundries.io Linux microPlatform, this means it's responsible for securely providing a list of known [good images](https://api.foundries.io/lmp/repo/release/api/v1/user_repo/targets.json). This service is stateless and can be scaled out horizontally to provide high availability.

The security model is almost identical to TreeHub. In fact the garage-sign tool that interacts with the Repo Server uses the same credentials.zip used by garage-push. There is one [notable difference](https://github.com/advancedtelematic/ota-tuf/issues/162) in that garage-sign does not have support for HTTP Basic authentication.

***Replaceability SWAG***: *Hard* - There's the [TUF reference](https://github.com/theupdateframework/tuf) project could probably be extended, but their on-disk format is slightly different and cryptography is never easy.

### Director

The Director implements the server side Uptane logic. It uses online keys to sign metadata that tells the device (Aktualizr) what image from the Repo Server it should be running. The /var/sota/metadata/director/targets.json is generated from the Director. This service is stateless and can be scaled out horizontally to provide high availability.

The Director sits behind the Gateway service so it doesn't require any built-in authentication logic.


***Replaceability SWAG***: *Hard* - The [Uptane reference implementation](https://github.com/uptane/uptane/) would be a good starting point, but Uptane is complex.

### Device Registry

The Device Registry handles the management of device status and configuration information. Aktualizr reports packages installed, hardware and IP information, and the results of `lshw` to the registry. This service is stateless and can be scaled out horizontally to provide high availability.

The Device Registry sits behind the Gateway service so it doesn't require any built-in authentication logic.

***Replaceability SWAG***: *Medium* - There's nothing quite like it to start from, but mostly it's an effort of mapping REST API calls to a database.

### OTA+ Web

OTA+ Web provides a web front-end to the OTA Community Edition components. The web interface shows information about devices and images and allows a user to update a device. This service is stateless and can be scaled out horizontally to provide high availability.

The default configuration supports no authentication and is single-user only. However, there are a few [authentication options](https://github.com/advancedtelematic/ota-plus-server#authentication).

***Replaceability SWAG***: *Easy/Medium* - It depends on how fancy the UI should be. Foundries.io implemented its own custom interface in less than a week that suited our specific needs.

### Gateway

The Gateway isn't really a component, but implements an NGINX reverse proxy that authenticates requests from Aktualizr and routes them to the proper internal micro-service. The service is stateless and is connected to a publicly exposed Kubernetes load balancer service.

This service uses SSL client [certificates](https://github.com/advancedtelematic/ota-community-edition/blob/master/scripts/start.sh#L109) to authenticate all incoming traffic.

***Replaceability SWAG***: *Easy* - You basically customize this to suite your [deployment needs](https://github.com/OpenSourceFoundries/ota-community-edition/commit/f6b80d34b46001f25ed68f7d89e49dc835e0d612).

## Putting It All Together
The Gateway and OTA+ Web are responsible for securely proxying requests from devices and the browser to the Device Registry, Director, Repo Server, and TreeHub. The garage-push and garage-sign tools used by OE builds require access to the TreeHub and Repo Server respectively. These have no built-in authentication, so a custom proxy must be created if you want to host these securely on the Internet.
~~~
     +-----+  +-----+       +---------+    +-------------+ +-------------+
     |     |  |     |       |         |    |             | |             |
     | LMP |  | LMP |       | Browser |    | garage-push | | garage-sign |
     |     |  |     |       |         |    |             | |             |
     +---+-+  +-+---+       +---+-----+    +----+--------+ +---+---------+
         |      |               |               |              |
    +----|------|---------------|---------------|--------------|---+
    |    |      |  Internet     |               |              |   |
    +----|------|---------------|---------------|--------------|---+
         |      |               |               |              |
+--------|------|---------------|---------------|--------------|---------+
|        |      |               |               |              |         |
|        |      |               |               |              |         |
|        |      |               |             +-v--------------v------+  |
|      +-v------v----+     +----v---------+   |                       |  |
|      |             |     |              |   | Your Custom Proxy to  |  |
|      |   Gateway   |     |   OTA+ Web   |   | TreeHub / Repo Server |  |
|      |             |     |              |   |                       |  |
|      +-------------+     +--------------+   +-----------------------+  |
|                                                                        |
|                                                                        |
|  +----------+   +----------+         +-------------+   +---------+     |
|  |          |   |          |         |             |   |         |     |
|  | Registry |   | Director |         | Repo Server |   | TreeHub |     |
|  |          |   |          |         |             |   |         |     |
|  +----------+   +----------+         +-------------+   +---------+     |
|                                                                        |
|        Kubernetes                                                      |
+------------------------------------------------------------------------+
~~~
