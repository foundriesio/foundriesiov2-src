+++
title = "Zephyr Development News 11 June 2018"
date = "2018-06-11"
tags = ["zephyr"]
categories = ["zephyr-news"]
banner = "img/banners/zephyr.png"
author = "Marti Bolivar"
+++

This is the 11 June 2018 newsletter tracking the latest
[Zephyr](https://www.zephyrproject.org/) development merged into the
[mainline tree on
GitHub](https://github.com/zephyrproject-rtos/zephyr).

**We've renamed the series to "Zephyr Development News" to avoid a
name clash with a publication produced by another entity.**

<!--more-->

As usual, content is broken down as follows:

- **Highlights**
  - Important changes: ABI/API breaks and some features
  - New features: non-exhaustive descriptions of new features
  - Bug fixes: non-exhaustive list of fixed bugs
- **Individual changes**: a complete list of patches, sorted
  chronologically and categorized into areas, like:
  - Architectures
  - Kernel
  - Drivers
  - etc.

Highlights
==========

As announced previously on the mailing lists, Zephyr v1.12.0 has been
tagged. Hurray!

This newsletter covers changes in the following inclusive range, which
closes out the v1.12 release candidate period:

- [6a138977](https://github.com/zephyrproject-rtos/zephyr/commit/6a138977cf9e293205f96bf7e98dc53caacabf00) susbys: disk: Fix misleading menuconfig prompts
- [f58d9cab](https://github.com/zephyrproject-rtos/zephyr/commit/f58d9caba242e52a4e0150dd1be0c99e239a9d42) release: Update VERSION for 1.12.0 release

Important Changes
-----------------

The areas most affected during this period, as might be expected, were
documentation and testing. There were also a fairly large number of
ARC architecture changes.

Features
--------

**Continuous Integration:**

Sanitycheck can now export tests in CSV format.

Bug Fixes
---------

**Arches:**

A variety of ARC fixes were merged. These fix overflows in the
privileged stack, IRQ offloading, the ADC and watchdog timer priority
levels, reset instability, and a couple of issues related to exception
handling.

A bug preventing i.MX RT SoCs from booting correctly was fixed as
well; this also has the nice benefit of eliminating a vast number of
Kconfig warnings emitted when building for other boards.

**Bluetooth:**

A fix for a Coverity bug related to corrupted flash storage of
persistent settings was merged, along with a fix to retransmit
interval handling in the Mesh implementation, and an invalid pointer
access after disconnect in the ATT code.

**Build:**

A fix to the kernel helpers for the GCC toolchain was merged which
resolves unaligned access issues on GCC >= 7.

**Continuous Integration:**

A sanitycheck bug leading to false positive test pass reporting was
fixed.

**Documentation:**

The final batch of documentation patches covered release notes, issues
in the Getting Started guide, initial documentation for the
experimental West meta-tool, updates to the security documentation,
and some watchdog API documentation.

**Kernel:**

Architecture-specific attempts to provide thread arguments using its
initial stack layout were replaced with common code, trading off extra
memory to fix broken and incomplete implementations in some
architectures.

**Libraries:**

A fix was merged for a readdir() buffer out of bounds access
discovered by Coverity.

**Networking:**

An LWM2M bug was fixed which fixes mandatory rate limiting on the
frequency of notifications for observed object instance attributes.
The LWM2M engine thread priority was also lowered, fixing a thread
starvation issue when running LWM2M concurrently with Bluetooth
(e.g. as part of a 6LoWPAN setup).

The IPv4 stack now correctly updates the time-to-live value based on
the received packet header; a similar fix was merged for IPv6 hop
limits.

**Samples:**

Some last-minute changes were merged to crypto and networking samples.

The crypto changes appear to have been merged because
samples/drivers/crypto is in fact being used as a test case in
addition to serving as sample code, so they perhaps could be
considered test fixes.

The networking changes were fixes for bugs discovered by Coverity.

**Testing:**

A variety of patches fixing up and tuning the test cases were merged
in the final days of v1.12 development.

Individual Changes
==================

Patches by area (76 patches total):

- Arches: 11
- Bluetooth: 3
- Boards: 1
- Build: 1
- Continuous Integration: 2
- Documentation: 22
- Firmware Update: 1
- Kernel: 2
- Libraries: 1
- Miscellaneous: 3
- Networking: 5
- Samples: 8
- Scripts: 1
- Storage: 2
- Testing: 13

Arches (11):

- [b423ee5f](https://github.com/zephyrproject-rtos/zephyr/commit/b423ee5f2a8760a661c5ce8b961f10ece25c36c1) nxp_imx: Move i.MX RT PLL selects to Kconfig.soc
- [c5cb8e94](https://github.com/zephyrproject-rtos/zephyr/commit/c5cb8e943c40e997df3794ee2911868ee37f231a) arch/arc: Set the right priority for WDT on quark_se
- [718597fe](https://github.com/zephyrproject-rtos/zephyr/commit/718597fe32cdef56e179f9b60b412c708043902f) arch/arm: Fix THREAD_MONITOR entry struct
- [7f7718a0](https://github.com/zephyrproject-rtos/zephyr/commit/7f7718a09a35b5ff297b9da63e16b86e43f625f3) arch: stm32: remove .hex binary build by default
- [5b6f8605](https://github.com/zephyrproject-rtos/zephyr/commit/5b6f860539d5f31ded42fbbed73dba7f262191be) arch: arc: use a separate stack for exception handling
- [5dd552e6](https://github.com/zephyrproject-rtos/zephyr/commit/5dd552e66bba49fc1a27ac60de53a524f6e95223) arch: arc: STACK_CHECK_FAIL of STACK_CHECK not hang the system
- [fb3d2d37](https://github.com/zephyrproject-rtos/zephyr/commit/fb3d2d3785604f032c3b95885a755dec65afd9ed) arch: arc: remove unused codes
- [c63298ea](https://github.com/zephyrproject-rtos/zephyr/commit/c63298ea65214430aa06f90170b74ce4b6d05679) arch: arc: improve the reset code
- [1c4fe3ed](https://github.com/zephyrproject-rtos/zephyr/commit/1c4fe3edc036461042407637ad3c8ba0002cac65) arch/arc: Set the right priority for ADC/AON on quark_se
- [97d04364](https://github.com/zephyrproject-rtos/zephyr/commit/97d043648690eeb7ea0164d8f228075adbcc8cb9) arch: arc: use top of isr stack as exception stack and bug fixes
- [d5bc9d7b](https://github.com/zephyrproject-rtos/zephyr/commit/d5bc9d7beea14aafbbbcbdd80156ad4a68b2bd97) arch: arc: adjust privileged stack size of arc to 384 bytes

Bluetooth (3):

- [ae829b26](https://github.com/zephyrproject-rtos/zephyr/commit/ae829b269db87e91bbf4b81e5649de62fa8bc53d) Bluetooth: Fix unchecked settings value lengths
- [ed5fb3ff](https://github.com/zephyrproject-rtos/zephyr/commit/ed5fb3ff379603530e0522d22c4127b55a15b966) Bluetooth: Mesh: Fix (re)transmit interval handling
- [1218648e](https://github.com/zephyrproject-rtos/zephyr/commit/1218648ed1758f288c6a8e47cbc0af6e18dd35fb) Bluetooth: ATT: Fix clearing context at disconnect

Boards (1):

- [f0bafc30](https://github.com/zephyrproject-rtos/zephyr/commit/f0bafc307b62390eb6c71afded997e8d53591474) boards: make em_starterkit_em7d default test platform

Build (1):

- [a37e0372](https://github.com/zephyrproject-rtos/zephyr/commit/a37e037264164738da2984b14fa206157c3abb7b) toolchain: gcc: Add compiler barrier at the end of UNALIGNED_PUT()

Continuous Integration (2):

- [5d6e7eb7](https://github.com/zephyrproject-rtos/zephyr/commit/5d6e7eb7c6cb5119af308cb33fa681ee787e7583) sanitycheck: export list of tests as CSV
- [b20c4846](https://github.com/zephyrproject-rtos/zephyr/commit/b20c4846dd5eb916827ae1cb69de4f9e1fc7dffa) sanitycheck: fail on faults/panics/oopses

Documentation (22):

- [65e191fa](https://github.com/zephyrproject-rtos/zephyr/commit/65e191fa7a84f4263ef867c8d77b11d276ae87af) api: watchdog: fix wdt_install_timeout doxygen comment
- [265f502b](https://github.com/zephyrproject-rtos/zephyr/commit/265f502b8e48ba3299bfbbef7814cbab196af0b3) releasenotes: update with doc issues addressed
- [72d4d8bc](https://github.com/zephyrproject-rtos/zephyr/commit/72d4d8bce1642b0e6779b8989654fd478bf3b898) doc: release notes: Fill in summary, arch, and kernel sections for 1.12
- [d04a7efd](https://github.com/zephyrproject-rtos/zephyr/commit/d04a7efd8d55c5054dbae45edabe27ad47e83e2a) releasenotes: updated documentation changes
- [59027fb6](https://github.com/zephyrproject-rtos/zephyr/commit/59027fb689aaa3d9509ac7bde768199336060fcd) doc: relnotes: Correct a couple of headline items
- [b0abf365](https://github.com/zephyrproject-rtos/zephyr/commit/b0abf365af9d5ddb23ba265a5d0c59a676d390d0) doc: relnotes: 1.12 Bluetooth release notes
- [2825f79a](https://github.com/zephyrproject-rtos/zephyr/commit/2825f79a2c5b6a17ed1700653a78a7c12da2b5a6) doc: security: Update security overview for recent features
- [8b9042c4](https://github.com/zephyrproject-rtos/zephyr/commit/8b9042c4192e1625744eb3b7fe60bc82ac6f336d) doc: security: Remove revision history
- [3fc206fa](https://github.com/zephyrproject-rtos/zephyr/commit/3fc206fa5387aa0bb0dc0a89755cafdaba0cde0f) getting_started: fix UNIX-ism
- [9ca4d840](https://github.com/zephyrproject-rtos/zephyr/commit/9ca4d840791f5f5a08d40c2a76afbfe189b9cd39) getting_started: fixes for intro section
- [64ab1326](https://github.com/zephyrproject-rtos/zephyr/commit/64ab13264ae3ba14d2140217e02e875cab93b7b2) getting_started: fixes and cleanups for installation_linux
- [c6c15013](https://github.com/zephyrproject-rtos/zephyr/commit/c6c15013553bbd0d0b5db2bf09e7f776a9670aa8) getting_started: building: fix inaccuracies
- [e8d0e72a](https://github.com/zephyrproject-rtos/zephyr/commit/e8d0e72adf62bf3dedf6a9e1901a9c9bc1fdb36b) doc: extensions: fix :app: behavior for zephyr-app-commands
- [e802d8de](https://github.com/zephyrproject-rtos/zephyr/commit/e802d8de35819d3d7e2f7e54ab8e597188aed567) doc: conf.py: remove unused import
- [1c852ddf](https://github.com/zephyrproject-rtos/zephyr/commit/1c852ddf5ca0107ee903c5811e7e7c288ca74f6b) doc: conf.py: make sure west is importable from Python
- [3a766aed](https://github.com/zephyrproject-rtos/zephyr/commit/3a766aedf0c2c3c48312f6514f9ee4f673cff5ef) doc: conf.py: add sphinx.ext.autodoc extension
- [869e9cce](https://github.com/zephyrproject-rtos/zephyr/commit/869e9cce013ac1ae6da707c42fb931127eff8d63) doc: add initial west documentation
- [f8251693](https://github.com/zephyrproject-rtos/zephyr/commit/f8251693bb150041fad4b200a4e823f097fc004d) conf.py: clean up exit if ZEPHYR_BASE is unset
- [d6f2858a](https://github.com/zephyrproject-rtos/zephyr/commit/d6f2858a142a936cf806c139461eaa976223226f) doc: relnotes: Add security vulnerability information
- [8e892068](https://github.com/zephyrproject-rtos/zephyr/commit/8e89206815acdfceed5b059f2cdb8aca8b360273) doc: release notes: Update 1.12 release notes with GitHub issues
- [d3afa353](https://github.com/zephyrproject-rtos/zephyr/commit/d3afa353a805fc5d3ef45515837c8609871a484d) doc: release notes: Update 1.12 release notes with more GitHub issues
- [51ae306b](https://github.com/zephyrproject-rtos/zephyr/commit/51ae306b59f806fea1d2b81286f7775af56f14aa) doc: release notes: Finalize 1.12 release notes and docs

Firmware Update (1):

- [2cba7017](https://github.com/zephyrproject-rtos/zephyr/commit/2cba701703d03816f208c159e4fe8f3bec01964d) subsys: mgmt: Remove unnecessary comparison

Kernel (2):

- [0e23ad88](https://github.com/zephyrproject-rtos/zephyr/commit/0e23ad889ee683f6a52bc71163b938e45d67a944) kernel: k_work: k_work_init() should initialize all fields
- [2dd91eca](https://github.com/zephyrproject-rtos/zephyr/commit/2dd91eca0e25e35ab00567461ff4f3d773db24db) kernel: move thread monitor init to common code

Libraries (1):

- [bf1e0198](https://github.com/zephyrproject-rtos/zephyr/commit/bf1e0198a78b7e1a51306a1fe24c73c3cdc5ab9a) lib: posix: fix out-of-bound write

Miscellaneous (3):

- [eb9df85f](https://github.com/zephyrproject-rtos/zephyr/commit/eb9df85f8412cddd49ef1ab5fa3c9264322cb31a) release: Move version to 1.12.0-rc3
- [3b1fb7f9](https://github.com/zephyrproject-rtos/zephyr/commit/3b1fb7f9a927da0936d81d4778fe6f3d89eae704) release: update footprint data
- [f58d9cab](https://github.com/zephyrproject-rtos/zephyr/commit/f58d9caba242e52a4e0150dd1be0c99e239a9d42) release: Update VERSION for 1.12.0 release

Networking (5):

- [95555221](https://github.com/zephyrproject-rtos/zephyr/commit/955552210eed6c6c62cd0672dfaa56e5f82bb7cf) net: shell: Correct help text for "mem" command
- [a957107d](https://github.com/zephyrproject-rtos/zephyr/commit/a957107d50baef45dd406fe2ec8e6a851e33f9e9) net: lwm2m: lower priority of engine thread
- [d9a14f5a](https://github.com/zephyrproject-rtos/zephyr/commit/d9a14f5a27eec75d2d8f64d810fc7200e4edcbc1) net: ipv6: Set hop limit in net_pkt according to IPv6 header
- [e72dcf02](https://github.com/zephyrproject-rtos/zephyr/commit/e72dcf02901efe48c60bc528a9f44ff00f92db03) net: ipv4: Set TTL in net_pkt according to IPv4 header
- [ed3ea06f](https://github.com/zephyrproject-rtos/zephyr/commit/ed3ea06f8801f1445d243c11420b972d7b11d572) net: lwm2m: fix observer attribute update logic

Samples (8):

- [cf3da3c6](https://github.com/zephyrproject-rtos/zephyr/commit/cf3da3c6c48fbeec88b02a6f273372126004b82f) samples: crypto: Ensure cap_flags is always initialized
- [858cd199](https://github.com/zephyrproject-rtos/zephyr/commit/858cd199edb2ef3bbe74f85c9ec3095f930a480c) samples: drivers: crypto: Do not show colors in logs
- [d06eecbe](https://github.com/zephyrproject-rtos/zephyr/commit/d06eecbe29c6513b8aa208854da966d88ec59c43) samples: drivers: crypto: Update expected sample output
- [d05442ee](https://github.com/zephyrproject-rtos/zephyr/commit/d05442ee9ce583c583e934d0a3933f5f7fa353be) samples: crypto: adapt harness
- [fd561dd5](https://github.com/zephyrproject-rtos/zephyr/commit/fd561dd596f4c52aed64b3b78a46b0e297ee0d58) samples: net: Check the return value of nats_publish
- [e7a3d01d](https://github.com/zephyrproject-rtos/zephyr/commit/e7a3d01dc5ec18bd3994684a7657245460df7453) samples: net: dumb_http_server: Handle recv() errors
- [b7ad50b4](https://github.com/zephyrproject-rtos/zephyr/commit/b7ad50b47346e334f3f7a333df936bb5a4500fe5) samples: net: rpl_border_router: Fix out-of-bounds write
- [7cfd5a41](https://github.com/zephyrproject-rtos/zephyr/commit/7cfd5a4184bcb1d44db8ed1d248d4267240c0a96) samples: net: hrpl_border_router: Fix NULL pointer dereference

Scripts (1):

- [c6c856bc](https://github.com/zephyrproject-rtos/zephyr/commit/c6c856bc60d6954d97db30e31c5d850f04d85905) scripts: west: cherry-pick upstream 321ab2e17

Storage (2):

- [6a138977](https://github.com/zephyrproject-rtos/zephyr/commit/6a138977cf9e293205f96bf7e98dc53caacabf00) susbys: disk: Fix misleading menuconfig prompts
- [bfdb6aca](https://github.com/zephyrproject-rtos/zephyr/commit/bfdb6acaf691dc6ec3a542787c29b8edd593f3a7) subsys: settings: Fix file exist error.

Testing (13):

- [9cefce81](https://github.com/zephyrproject-rtos/zephyr/commit/9cefce816824c80791ca8a1967bc413f1634f690) tests: remove obsolete k_thread_cancel
- [a803af2f](https://github.com/zephyrproject-rtos/zephyr/commit/a803af2fa74706f54786d3b72561c36981d92253) tests/kernel/preempt: Add yield and sleep cases
- [a026b9ea](https://github.com/zephyrproject-rtos/zephyr/commit/a026b9eacaca4634c2b711967851e01baebd6d21) tests: crypto: Fully initialize variables using named initializers
- [a07d0731](https://github.com/zephyrproject-rtos/zephyr/commit/a07d0731c7e4e10694ce2f2d6a2780d20997ed21) tests: mbox_api: Fully initialize k_box_msg struct
- [a803335a](https://github.com/zephyrproject-rtos/zephyr/commit/a803335a7c54fb6245be7f7d733debe05173e49c) tests: net: Increase the stack size of frdm-k64f
- [b43000f5](https://github.com/zephyrproject-rtos/zephyr/commit/b43000f5eba943425f03c5ee8fff847727ae84d7) tests: net: trickle: Fix running on frdm-k64f
- [59bf65f4](https://github.com/zephyrproject-rtos/zephyr/commit/59bf65f481205c0171a0665845f7eb520fa65a56) tests: net: Fix tests so they can be run in real hw
- [3057da07](https://github.com/zephyrproject-rtos/zephyr/commit/3057da079ab4fe498eeb6965ed6638804c6f38fe) tests: logger-hook: increase ztest stack size
- [bb631076](https://github.com/zephyrproject-rtos/zephyr/commit/bb631076f63347fdd33e98bd276cf0c5f4fbd384) tests: arm: irq_vector_table: Fix Kconfig override
- [fb2e142b](https://github.com/zephyrproject-rtos/zephyr/commit/fb2e142b0e6cb7faa2f1c8dc9060f641193ba31f) tests: fix test identifiers
- [33aa9053](https://github.com/zephyrproject-rtos/zephyr/commit/33aa90539a48325e6813f039ff0f68f4baeb0fb2) tests: kernel: fifo_timeout: Do not potentially dereference NULL ptrs
- [144a4390](https://github.com/zephyrproject-rtos/zephyr/commit/144a4390b5736900b28c1ddad4be258b1addcb08) tests: fix the bug of sentinel.conf
- [a91f1e5e](https://github.com/zephyrproject-rtos/zephyr/commit/a91f1e5e142a223b7408858465c0012bd89dc1be) tests: modify the test conditions for emsk_em7d_v22

