+++
title = "180 days"
date = "2018-03-30"
tags = ["General"]
categories = ["Newsletter", "Corporate"]
banner = "img/banners/180days.png"
+++

It's March 30, 2018, Good Friday, and it has been 180 days since we started Foundries.io.  In this time, we established our initial infrastructure, created the first microPlatform products and, on March 27, we produced our 12th update to the microPlatforms, roughly 1 update every 2 weeks.  When we started the microPlatforms, we wanted to get our systems and processes running smooth enough to provide meaningful software updates that could be integrated into products by our subscribers.

You may think that consuming software updates every 2 weeks is daunting, however, the upstream projects are ever-evolving and in this same period, Zephyr has seen 3,385 commits and the Linux Kernel has seen 28,876 commits and we aren’t even listing the changes of the other software projects.  Long story short, with all this activity, there are new features and fixes that affect all aspects of computing that your products may have missed out on.  With the microPlatforms we have created a product that not only keeps you close to the latest software, but standards-based and fully tested end-to-end for use within connected IoT products.
<!--more-->

Additional Technology
---------------------

During this time the team has also participated in extending the upstream projects and enabling new technologies.  Note: You can always review release notes and technical summaries of every microPlatform update on our blog at: https://opensourcefoundries.com/tags/update/

__microPlatforms__

* Go and Docker updates
* Support for the MCUboot 1.0 release
* KBuild → CMake build system transition
* Open-sourcing our OE layers for building the Linux microPlatform
* Added support for x86 (Minnowboard Turbot and Intel NUC)
* Zephyr 1.10 and Zephyr 1.11 releases
* Adding support for all LmP boards in a single Unified Linux Kernel (now on 4.14.19)
* IPv6 over Bluetooth Low Energy improvements in Linux and Zephyr
* Continuing to add features and work with upstream Zephyr on LwM2M compliance
* Toolchain updates from GCC 7.1 to GCC 7.3
* Open Embedded updates to 7.2 (We base our work on OE Master)
* Zephyr project integrates Open Thread support
* Linux microPlatform integration of UsrMerge (for OTA Compatibility)
* IBM Bluemix integration
* Azure IoT Edge integration and proof-of-concept for container creating and management

__Features nearing release__

* TUF / Uptane compliant (OTA) ‘over the air’ updates enabled by OTA+ Community Edition
* EdgeX integration with the Linux microPlatform on x86, including the latest California pre-release with Go containers
  * _NOTE: We have Edge-X running on ARM, but some cpu/memory constrained devices struggle with the requirements of the early EdgeX services; the California release (June 2018), promises new Go-based services that make EdgeX close to a reality_
* Cellular modem support and specifically the WNC M14A2A module paired with a NXP K64F freedom board to provide LTE/LTE-M connectivity on AT&T’s network

__Experiments__

* Publishing IoT sensor data onto the blockchain, specifically the IOTA tangle and researching zcash possibilities and benefits
* Providing a complete Open Source LwM2M light project
* X.org and direct framebuffer graphics enablement from within containers

__Board Support__

* Raspberry PI 3 x64
* Compulab IoT Gate
* Intel Core i7 / x86_64 *
* Toradex Colibri i.mx7 *
* Beaglebone Black / Beaglebone Black Wireless *
* Lemaker Hikey *
* Qualcomm Dragonboard 410c * & Dragonboard 820c *
* Solidrun Hummingboard *

_* we make a best effort to support these new boards, but may or may not have full automation testing running_

Testing and CI / Automation tools
---------------------------------

None of what we have accomplished, or will in the future, could have been remotely possible without the infrastructure and tooling we have established during this critical period.

__Jobserv - a horizontally scalable CI job runner__

We built Jobserv after years of struggling to extend, evolve and leverage other Build and CI systems and needed a build system that was easy to use, extensible and was built to be horizontally scalable from the ground up.

__Linaro LAVA__

We continue to use LAVA for our testing and automation needs.  Note: We did encounter some upstream resistance during development and were unable to achieve our quality goals while keeping in-line to the upstream project and much of our testing is on a branch of LAVA that can be used within containers for scalable testing.  We continue conversations with upstream maintainers, and hope to upstream these features and other capabilities we’ve enabled in the near future.

Testing
-------

Arguably, you can never test every feature at the rate the projects are changing, but we have built a substantial system to help protect the microPlatforms from regressions that we run during our development.  This testing, primarily automated, allows us to produce our updates for subscribers to use with confidence.

__MCUBoot__

_Upstream Testing on every upstream commit_

* Target Compilation Tests [MCUBoot, MCUBoot+Zephyr and MCUBoot+Zephyr+FOTA tests]
* Functional Tests [Qemu Boot Simulation, FOTA testing on bare metal]

_OSF MCUBoot Testing_

* Target compilation Tests [Zephyr+FOTA tests]
* Functional Tests [MCUBoot Simulator, FOTA testing on bare metal]

__Zephyr__

_Upstream testing on every upstream Zephyr_

* Compilation [Sanitycheck, FOTA compile tests]

_Internal testing on every OSF commit_

* Target Compilation [Checkpatch, Sanity check, FOTA Samples]
* Functional Tests [Drivers, IPM, Kernel Alert API, Kernel ARM Runtime, Kernel ARM NMI Runtime, Kernel Common, Kernel Context, Kernel Critical, Kernel Fatal Stack Sentinel, Kernel FIFO API, Kernel Generate ISR Table, Kernel Threads Custom Data API, Kernel Threads Lifecycle API, Kernel XIP, Bare Metal FOTA]

_FOTA Sample Application Testing on every commit_

* Compilation tests [Checkpatch, FOTA Samples]
* OSF MCUBoot on target

__End to End Testing__

* Currently triggered for each update candidate
* Zephyr and Linux Devices from bare metal
  * 90 LwM2M roll outs across 2 gateways and 2 zephyr device types and a minimum of 9 devices
  * 90 HTTP / Hawkbit roll outs across 2 gateways and 2 zephyr device types and a minimum of 9 devices

__Linux microPlatform Testing__

* Build and boot testing using KernelCI.org
* Netperf, Docker, more tests coming online
* Exploratory testing by engineers
* OTA/OSTree testing
* Stress and soak testing

Though the focus has been on end to end testing on each commit both up and downstream, we are starting to analyze testing efficiency and also moving to add more stress/soak testing and increasing depth testing.

Subscriber Dashboard
--------------------

__Delivery__

With https://app.foundries.io, we have established a simple interface as the foundation of our initial product offering.  Our dashboard is a simple front-end built on Kubernetes-powered and scalable APIs that can support our next phases as we work on evolving our dashboard to provide an industry leading level of code inspection to support our code inference goals.

__Support__

A suite of business critical applications including front-end website, Slack discussion board, Mailing lists and Forums; Social media accounts, issue/ticket tracking systems and comprehensive product documentation systems are all in place
