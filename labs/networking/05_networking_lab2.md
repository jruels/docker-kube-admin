#LAB
## Networking Part 2
*Lab Objectives*  
This lab demonstrates how to create and configure Docker bridge networks.  

Lab Structure - Overview
1.	Build a Bridge Network

### 1. Build a Bridged Network
Step by Step Guide
1.	List the current Docker networks  
`docker network ls`  
There following should be listed:  
    ```
    NETWORK ID          NAME                DRIVER
    bc712029c257        bridge              bridge
    ad32a3782fed        host                host
    e512120ca2ea        none                null
    ```

2.	View the metadata of the network bridge using ‘inspect’ on the network named bridge (Take note of the IPAM settings):  
`docker network inspect bridge`

3.	Review the metadata of the network called none  (Take note of the IPAM settings):  
`docker network inspect none`

4.	Review the metadata of the network called host (Take note of the IPAM settings):  
`docker network inspect host`

5.	Create a new network called wordpress using the --driver bridge:  
`docker network create --driver bridge wordpress`

6.	Validate that the network was created:  
`docker network ls`  
    Output:
    ```
    NETWORK ID          NAME                DRIVER
    bc712029c257        bridge              bridge
    36cc3de6c4aa        wordpress           bridge
    ad32a3782fed        host                host
    e512120ca2ea        none                null
    ```

7.	Review the metadata for the bridge network called wordpress:  
`docker network inspect wordpress`  
Note the IPAM section, the Gateway, and the container section.

8.	Create a new network named webapp:  
`docker network create webapp`

9.	Review the metadata for the bridge network called webapp:  
`docker network inspect webapp`

10.	Attempt to create a network that uses the host driver:  
`docker network create --driver host internet`  
    The machine will respond:  
    ```
    Error response from daemon: only one instance of "host" network is allowed
    Only one "host" network can exist; this is the network that provides access to the host network interfaces.
    ```

11.	Attempt to create a network that uses the null driver:  
`docker network create --driver null nowhere`  
    The machine will respond:
    ```
    Error response from daemon: only one instance of "null" network is allowed
    One one "null" can exist; this is the network that allows for the create of containers with only a loopback interface.
    ```

12.	Launch an instance of alpine:  
`docker run -d --net=wordpress alpine top`

13.	Inspect the wordpress network:  
`docker network inspect wordpress`  
Notice the addition of the container in the Containers section.

14.	Attempt to remove the wordpress network while the container is still running:  
`docker network rm wordpress`  
    The machine will respond with an error:  
    ```
    Error response from daemon: network wordpress has active endpoints
    ```

15.	Using the metadata output of the network wordpress, why does this network delete error?  
`docker network inspect wordpress`  
Remember the containers section.

16.	Using the metadata output of the network wordpress, find the container, and delete the container:  
``docker rm -f <container ID>``

17.	Using the metadata output, validate that the container is deleted:  
`docker network inspect wordpress`

18.	Remove the newly created networks:  
`docker network rm wordpress`  
`docker network rm webapp`

19.  Create a network using a specific subnet:  
`docker network create --driver=bridge --subnet=192.168.0.0/16 wordpress`

20. Create a network using the same subnet:  
    `docker network create --driver=bridge --subnet=192.168.0.0/16 webapp`  
    The machine will respond with an error:  
    ```
    Error response from daemon: cannot create network
    The error resulted from the docker daemon attempting to create a network with a subnet that already exists.
    ```
 
21.	Cleanup our demo networks and remove the wordpress network:  
`docker network rm wordpress`

22.	Create a network using the --driver bridge and name it br0:  
`docker network create --driver=bridge br0`

23.	Using the metadata output, review the IPAM config and note the subnet and gateway sections.  
`docker network inspect br0`

24.	Create a network defining a specific subnet:  
`docker network create --driver=bridge --subnet=172.29.0.0/16 br1`  

25.	Using the metadata output, review the IPAM config and note the subnet and gateway sections.  
`docker network inspect br1`

26.	Create another network defining the subnet and IP address range:  
`docker network create --driver=bridge --subnet=172.30.0.0/16 --ip-range=172.30.5.0/24 br2`

27.	Using the metadata output, review the IPAM config and note the subnet and gateway sections.  
`docker network inspect br2`

28.	Create a network defining a specific subnet, IP address range, and gateway:  
`docker network create --driver=bridge --subnet=172.31.0.0/16 --ip-range=172.31.5.0/24 --gateway=172.31.5.254 br3`

29.	Using the metadata output, review the IPAM config and note the subnet and gateway sections.  
`docker network inspect br3`

30.	Clean up the newly created networks  
`docker network rm br0 br1 br2 br3`

### Lab Complete!

<!-- 
LastTested: 2018-09-28
OS: Ubuntu 18.04
DockerVersion: 18.06.1-ce, build e68fc7a
-->
