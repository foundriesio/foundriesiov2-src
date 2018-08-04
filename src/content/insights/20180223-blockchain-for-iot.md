+++
title = "Blockchain for the Internet of Things"
date = "2018-02-23T13:07:31+02:00"
tags = ["blockchain","crypto", "iot", "decentralized"]
categories = ["blockchain"]
banner = "img/banners/blockchain.png"
+++

It seems every industry is placing bets on how blockchain technologies will revolutionize the way they do business. The internet of things is not immune to this hype, but the fundamental question remains. How can it be useful?

## Centralized vs Decentralized Trust Models

The flow of data, that is what the internet of things is all about. How to retrieve it, where to store it, and who can access it. As an example, cloud solutions like AWS IoT provide a way to send, store, and retrieve data. The service is well built, distributed over multiple regions, and can scale to large amounts of devices. However, this is a centralized solution, as Amazon is entirely in control of the robustness of the infrastructure and storing the data securely. This model requires you to establish trust within a single entity, for better or for worse. In the event that this entity is compromised, do you still trust the data that has been stored to be immutable? More than ever data is being used to drive almost all decisions, thus ensuring the data is kept immutable is critical.

Blockchain technologies are built off the idea of building consenus. Trust in this model is established through consensus among the nodes on the network. Nodes can be setup by anyone, so there is no single entity in control of the flow of data and no single point of failure. To transact on the blockchain, typically you have to perform proof of work to allow you to interact with the network. All nodes on the network must perform these calculations to verify the authenticity of the transaction being presented, i.e. reaching consensus. Once consensus is reached, the transaction is confirmed and added to block. These blocks can never be rewritten, or changed in any way meaning that the contents of the block will always be tamperproof and immutable. This is a very powerful concept which is poised to change the world as we know it.

## Storing Sensor Data on a Blockchain

At Foundries.io we are creating the next generation of IoT platforms, and they need to be ready for blockchain. We've built a proof of concept based on our microPlatforms to consume sensor data from the connected devices and store it on a blockchain. The best part about this implementation is that the sensors do not need to know about the blockchain, as many times these devices have very constrained footprints. The gateway does the heavy lifting, brokering the data stream to the blockchain, making the entire integration seamless to the end devices.

![IoT Blockchain Diagram](../../../../../img/blog/iota.png)

As proof of work is required to transact, this limits the ablility to publish data in aggresive intervals. With the proof of concept we have developed, it takes about a minute on average to publish sensor data onto the Blockchain. Please keep in mind that transaction speed will be determined by the blockchain you use. Below is an example of the published data on the blockchain.

![IoT Data on the Blockchain](../../../../../img/blog/data.png)

Note that the message/signature field contains the JSON sensor data value.

## Proof of Concept

Pictured below is a Minnowboard Turbot running the Linux microPlatform, connected to two BLE Nano2 running the Zephyr microPlatform. Data is transfered from the sensors using 6lowpan over BLE to the gateway. To process and publish the data streams to the blockchain we've simply added two additional containers which run on the gateway. What does this mean? The microPlatforms required no code changes to integrate with blockchain, and that in itself is a testament to the flexibility of these platforms.

![microPlatform PoC](../../../../../img/blog/poc-iota.jpg)

## Next Steps

The Foundries.io team will be leading the "Blockchain of Things" BoF at Embedded Linux Conference / OpenIoT Summit where we will discuss how blockchain based technology can be harnessed in the IoT space. We will have the opportunity to do a live demo of our proof of concept during the week. Please join us if you can, and help spread the word.
