+++
author = "Alan Bennett"
banner = "/uploads/2018/05/08/portainer.png"
categories = ["lmp"]
date = "2018-05-07T06:00:00+00:00"
tags = ["portainer", "container", "docker", "management"]
title = "Portainer Container Management on Linux microPlatform "

+++
At Foundries.io, we are constantly looking across the ecosystem  for the best projects to complement the microPlatforms.  One such project is [Portainer](https://portainer.io "Portainer"). "Portainer is an open-source lightweight management UI which allows you to easily manage your Docker hosts or swarm clusters."

<!--more-->

You can easily try out portainer and some of our experimental containers by ssh'ing into a system running the Linux microPlatform and running

    docker run -d -p 9000:9000 --restart always --name portainer  -v $PWD/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --logo https://foundries.io/static/img/logo.png --templates https://raw.githubusercontent.com/OpenSourceFoundries/ez/master/templates.json

![](/uploads/2018/05/08/runportainer.png "Run portainer on LmP Device")

After you get the service running, you can access the portainer UI.  In this example, the IP of my LmP device is 192.168.1.80, so I open a browser and put the following address in the go box: http://192.168.1.80:9000

First step is to create an administrative username and password.

![](/uploads/2018/05/08/create-account.png)

Next, Connect to the Local device:

![](/uploads/2018/05/08/connect-local.png)

After Local is selected, click "Connect"

![](/uploads/2018/05/08/connect-locally.png)

Now you have access to the Portainer UI.  From here you can create, refresh, stop, start re-create, inspect all of the containers running on your device.

![](/uploads/2018/05/08/front-page.png)

You can also try out some sample 'experimental' apps that we are compiling to demonstrate the ease of using containers on the Linux microPlatform.  Though these efforts come out of our forge / (our test Labs) efforts, we use them for demonstrations and other setups

![](/uploads/2018/05/08/experimental-apps.png)
