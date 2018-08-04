+++
title = "How We Chose a Software Update System"
date = "2018-05-25"
tags = ["ota", "open source"]
categories = ["FOTA"]
banner = "img/banners/ota.png"
+++

One of the first big decisions we had to make for the Linux microPlatform was our Over-The-Air Update (OTA) strategy. This decision required a lot of time, meetings, beer, and coffee. This article is the first of a small series explaining our recommended approach to OTA for the LMP. This article explains how and why we ultimately chose [OTA Community Edition](https://github.com/advancedtelematic/ota-community-edition).
<!--more-->

Everyone had thoughts on what they wanted from an OTA system. This was no surprise, as most of us have backgrounds in traditional embedded Linux, Android, and Linux distros. We also firmly believe in using open source software that's secure by design. With all that in mind, we established a list of things we wanted in an OTA solution.

### Self-Hosted and Open Source

Foundries.io believes in providing open source software with no vendor lock-in. We also hope to help contribute to and grow a healthy community working on an OTA solution.

### OSTree

[OSTree](https://ostree.readthedocs.io/en/latest/) can be thought of as Git for system images. An OSTree client can "pull" down a specific image from an OSTree server by telling it which SHA it wants. Each update to a system will have a new SHA and the "pull" operation will only pull down a delta between the two images. The project has nice comparison to other projects that describes the [pros and cons](https://ostree.readthedocs.io/en/latest/manual/related-projects/) of the OSTree approach.


### TUF

If you think of OSTree as a repository hosting a bunch of images that can be downloaded, [The Update Framework](https://theupdateframework.github.io/)(TUF) is a cryptographically sound way of describing what images are valid for a device. It's in use by several [high profile](https://theupdateframework.github.io/adoptions.html) projects to achieve similar goals. A great feature of TUF is its belief that a private key will eventually get compromised, but that recovery is possible because of their multi-level key management strategy where signing [keys are kept offline and can be rotated](https://docs.atsgarage.com/prod/rotating-signing-keys.html).

### Uptane

[Uptane](https://uptane.github.io/) goes a step beyond TUF to provide a really secure update system that's trusted by the automobile industry. With OSTree and TUF providing and describing what can be installed, Uptane has the ability for an operator to tell a device what it *should* have installed.

## The Solution

We found a project called [Aktualizr](https://github.com/advancedtelematic/aktualizr/) that is basically an open source implementation of an OSTree and Uptane daemon for a managed device. The maintainers of the project are responsive. They've taken [trivial patches](https://github.com/advancedtelematic/aktualizr/pull/606) from us when we were strangers, helped [guide us](https://github.com/advancedtelematic/aktualizr/pull/767) through adding more complex functionality, and are open to [new feature requests](https://github.com/advancedtelematic/aktualizr/issues/771). They've also been patient and helpful working through [difficult bugs](https://github.com/advancedtelematic/ota-tuf/issues/184).

The company behind Aktualizr also makes an open source project out of their commercial ATS Garage offering called OTA Community Edition. There's nothing technically binding Aktualizr to this service. However, it's the only integrated solution that handles OSTree and Uptane we've found.

In following articles, we'll delve into what OTA Community Edition is and how to deploy it.
