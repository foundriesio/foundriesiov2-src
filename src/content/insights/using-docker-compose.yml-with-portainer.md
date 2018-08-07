+++
author = "Alan Bennett"
banner = "/uploads/2018/05/09/p-d-dc.png"
categories = ["linux microplatform", "mp containers"]
date = "2018-05-08T06:00:00+00:00"
tags = ["portainer", "container", "docker", "docker-compose"]
title = "Using docker-compose.yml with Portainer"

+++
Portainer has been a great asset and we have started to rely on it for single-container image management.  Unfortunately, Portainer has been designed for 2 key use-cases.  single containers and "stacks" that are meant to be deployed onto Kubernetes or Swarm orchestrators.  For many of our demos we want to manage a suite of containers and orchestrate their startup so we can manage large container suites like the 9+ container-based micro-services that comprise the Edge-X project.  For remote control we initially started with Ansible, and though it's great for a controlled container management system, it doesn't demo as well as Portainer does.  In this blog we'll describe about how we use Portainer and docker compose to deploy and coordinate multiple containers at Foundries.io.

<!-- More -->

## Overview

1. Docker-compose in Docker
2. Storing docker-compose compose files
3. Custom launch scripts for docker-compose files
4. Portainer templates
5. See it all work

For an introduction on running portainer on the microplatform, check out the [How to run Portainer on the Linux microPlatform Blog]({{< relref "/insights/20180508-portainer-container-management-on-linux-microplatform-.md" >}}).

## Docker-compose in a docker container

I created a simple Docker container to run docker-compose.

    FROM alpine
    RUN apk add --no-cache python3 py3-pip
    RUN pip3 install docker-compose

And to run docker-compose you simply bind-mount the docker lock file.

    docker build -t simple-compose .
    docker run -v /var/lock/docker.sock:/var/lock/docker.sock simple-compose

Using this container we could now launch Portainer and launch docker-compose on a docker-compose file.  But how do we get the docker-compose file somewhere where it can be referenced by portainer.

## Where do we store compose files?

1. on the network (http?), using some fetch logic and use a environment variable to reference the URL?
2. in git?, using git clone logic and use a environment variable to locate the git repo?
3. in the container? 1 compose file and 1 container?
4. put a suite of compose files in the container and just reference the one you want with an environment variable

I'm sure there could be a better option, but after a review, I opted to store all of my compose files into a single container and put some lose command scripts around them (more or less option 4).

The container:

    FROM alpine

    RUN apk add --no-cache python3-dev py3-pip docker git bash curl
    RUN pip3 install --upgrade pip docker-compose
    COPY compose-files/* /
    COPY compose-launcher/start.sh /
    RUN chmod +x /*.sh
    CMD /start.sh

And then by default I simply use the environment variable $TARGET to bring up the docker-compose services as daemons in the order they are written with no special logic.

The start.sh script

    #/bin/sh

    set -x

    docker-compose -H unix:///var/run/docker.sock -f /$TARGET up -d

So now I can describe a template process in Portainer, add an environment variable that points to a specific compose file that lives in our compose-launcher docker image(s).

## Docker-compose custom launch scripts

Ah, but then there are challenges.  What about projects that mandate the order and timing that containers can come up in?  like Edge X.  There is promise in the future that the EdgeX micro-services will not be order dependent, but for now they still are, so we want to script the order the files are brought up.

To do this, we add the use of Portainer's Container "CMD" override option to run a script that we can use to refine the deployment steps of a docker compose file.

    set -x
    COMPOSE_FILE=/edgex.yml

    echo "Starting mongo"
    docker-compose -f $COMPOSE_FILE up -d mongo
    echo "Starting consul"
    docker-compose -f $COMPOSE_FILE up -d config-seed

    echo "Sleeping before launching remaining services"
    sleep 15

    echo "Starting support-logging"
    docker-compose -f $COMPOSE_FILE up -d logging
    echo "Starting core-metadata"
    docker-compose -f $COMPOSE_FILE up -d metadata
    echo "Starting core-data"
    docker-compose -f $COMPOSE_FILE up -d data
    echo "Starting core-command"
    docker-compose -f $COMPOSE_FILE up -d command
    echo "Starting core-export-client"
    docker-compose -f $COMPOSE_FILE up -d export-client
    echo "Starting core-export-distro"
    docker-compose -f $COMPOSE_FILE up -d export-distro

    echo "Starting device-virtual"
    docker-compose -f $COMPOSE_FILE up -d device-virtual

## The Portainer template samples.

Here is a simple case.  just run all the containers described in a docker-compose file.

    {
        "type": "container",
        "title": "The OSF Gateway",
        "description": "A demonstration set of containers to create a BLE IoT gateway",
        "platform": "linux",
        "restart_policy": "no",
        "image": "opensourcefoundries/compose-launcher:latest",
        "categories": [
          "IoT",
          "Gateway",
          "Demonstration"
        ],
        "env": [
          {
            "name": "TARGET",
            "description": "Docker compose file to run",
            "set": "simple-gateway.yml"
          },
          {
            "name": "ACCOUNT",
            "description": "Docker hub account",
            "set": "opensourcefoundries"
          }
        ],
        "volumes": [
          {
            "container": "/var/run/docker.sock",
            "bind": "/var/run/docker.sock"
          }
        ]
      },

Here we want to control the order that the docker compose files are being brought up and add a delay, so we create s simple bash script and execute it using the command override feature in Portainer.

    {
        "type": "container",
        "title": "EdgeX pre-release",
        "description": "EdgeX - x86 only - ALPHA quality, Work in progress upstream",
        "platform": "linux",
        "image": "opensourcefoundries/compose-launcher:latest",
        "restart_policy": "no",
        "categories": [
          "IoT",
          "Gateway",
          "Demonstration"
        ],
        "command": "/bin/bash -c /edgex-docker-launch.sh",
        "volumes": [
          {
            "container": "/var/run/docker.sock",
            "bind": "/var/run/docker.sock"
          }
        ]
      }

## Deploying multiple containers in only a few clicks

As an initial implementation there are likely many ways we can improve this scenario, but it works for now and we get to use Portainer and docker-compose to orchestrate single-node demos all with only a couple of button clicks.

![](/uploads/2018/05/09/Selecttemplate.png)

![](/uploads/2018/05/09/deployIoTGateway.png)

![](/uploads/2018/05/09/Itsagateway.png)
