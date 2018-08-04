+++
title = "Simplify your life: multi-architecture docker containers"
date = "2018-01-17T13:07:31+02:00"
tags = ["docker","containers", "kubernetes", "k8s", "resin"]
categories = ["docker"]
banner = "img/banners/docker.png"
+++

> “The great thing about Docker is that your developers run the exact same container as what runs in production.”

This is what the Docker hype is about, creating reproducibile environments for applications. The technology enables us to create lightweight, secure microservices which run on an array of SoCs that can be updated over the air in a matter of seconds. We believe that accelerating code delivery will ultimately reduce time to market. Hype aside, Docker has matured and has become a foundational building block of our microPlatforms.
<!--more-->
## Complexity

The microPlatforms are built to be architecture agnostic, meaning we don't favor one over the other. This ensures any user will have the same experience no matter which architecture they may choose. This is a complex problem to solve when it comes to Docker containers, as each image layer is built for a specific architecture. That means to use a Docker container, a user needs to know the architecture they will use, otherwise the container simply won't function at runtime. The basics of the problem we've solved is outlined below:

  * Container base images must be created for each architecture.
  * A per architecture Dockerfile must be created to reference the proper base image.
  * Users must _know_ the right image to pull for the system they are currently using.

On the surface, this doesn't seem so bad. In practice it's painful for users and a nightmare for documentation. Below is an example of how tedious and error prone documenting running a container on the microPlatform is

arm:

```
docker run -dit --net=host --read-only --tmpfs=/var/run -v /home/osf/nginx-lwm2m.conf:/etc/nginx/nginx.conf --add-host=mgmt.foundries.io:127.0.0.1 --name nginx-coap-proxy opensourcefoundries/nginx:latest-arm
```

arm64:

```
docker run -dit --net=host --read-only --tmpfs=/var/run -v /home/osf/nginx-lwm2m.conf:/etc/nginx/nginx.conf --add-host=mgmt.foundries.io:127.0.0.1 --name nginx-coap-proxy opensourcefoundries/nginx:latest-arm64
```

amd64 (x86):

```
docker run -dit --net=host --read-only --tmpfs=/var/run -v /home/osf/nginx-lwm2m.conf:/etc/nginx/nginx.conf --add-host=mgmt.foundries.io:127.0.0.1 --name nginx-coap-proxy opensourcefoundries/nginx:latest-amd64
```

Wouldn't it be nice if one command just worked across all these architectures?

## Manifests

Docker has realized this is a serious problem for the ecosystem, and have taken steps in the right direction to solve it. They have added a image manifest in the v2 specification[0] which includes an `architecture` field to map a image reference to a specific architecture. Now images can be created and linked to a manifest, creating a single point of entry for users to consume multi-architecture images. Lets take another look at our example above, but instead using a manifest.

```
docker run -dit --net=host --read-only --tmpfs=/var/run -v /home/osf/nginx-lwm2m.conf:/etc/nginx/nginx.conf --add-host=mgmt.foundries.io:127.0.0.1 --name nginx-coap-proxy opensourcefoundries/nginx:latest
```

One image reference to rule them all. The tag latest points to our image manifest, which in turn points to the image tags (i.e. latest-arm) for specific architectures. The result is a single entry point for our users, and sanity in our documentation.

## Building

Architecture specific image layers need to be produced before an manifest can be created. Let's quickly dive into what is needed to do this, and discuss some limitations that Docker currently has.

### Base Images

Take a look at your favorite Docker image, chances are the base image (FROM directive) is for a specific architecture. The solution to this problem is to create multi-architecture base images, to allow derivative images to inherit from. Therein lies the rub, most base images are not built for any other architecture other than the incubment amd64. We've solved this problem by building and publishing our own base images for the architectures we support from upstream sources. Using the same manifest concept from above we can create multi-architecture base image based on upstream sources.

#### Minideb

Minideb[1] is a small image based on Debian designed for use in containers. We have created a CI server to rebuild these base images[2] for each architecture as the upstream changes. This allows us to quickly pick up the latest packages and security fixes and deliver them on multiple architectures seamlessly. Of course when the base images change, the dervative images must also be automatically rebuilt to ensure the security fixes flows downward.

#### Alpine

Alpine[3] Linux is a very minimal distribution, which makes it perfect for containers. The base images can be as small as 5MB, which helps keep the attack surfaces small, perfect for embedded hardware. The same principles above apply to our Alpine base images[4].

### Limitations

Multi arch support is on the bleeding edge, so there are a few limitations to note.

  * There is no offical tooling to create manifests.
  * Images must be built on the native architecture[5], bin-fmt and other workarounds do _not_ work.
  * Manifest support requires Docker v1.12.6+


[0] https://docs.docker.com/registry/spec/manifest-v2-1/

[1] https://github.com/bitnami/minideb

[2]https://hub.docker.com/r/opensourcefoundries/minideb/

[3] https://github.com/gliderlabs/docker-alpine

[4] https://hub.docker.com/r/opensourcefoundries/alpine/

[5] https://github.com/docker/cli/issues/327
