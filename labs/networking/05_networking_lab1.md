# LAB
## Networking

*Lab Objectives*

This lab demonstrates the major networking models for Docker containers, through configuration of networking in a series of examples. 

Lab Structure - Overview
1.	Isolated Container Network
2.	Bridged Container Network
3.	DNS Search and Host Records
4.	Expose and Map Ports
5.	Shared Container Network
6.	Open Container Network

### 1. Isolated Container Network
Step by Step Guide
1.	Run the following command to create a container using the the none network, this container will automatically delete itself after it outputs the Ethernet configurations.  
`docker run --rm --net none alpine:latest ip addr`  
The output should look like the following:  
    ```
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft preferred_lft forever
        inet6 ::1/128 scope forever host 
        valid_lft forever preferred_lft forever
    ```
    Take note that the above container has no eth0; proceed to the next step and try to ping a public IP address.

2.	Run the following command to create a container using the none network, this container will automatically delete itself after attempting to ping the Internet address 8.8.4.4 twice.  
    `docker run --rm --net none alpine:latest ping -w 2 8.8.4.4`  
The output should look like the following:
    ```
    ping: sendto: Network is unreachable
    PING 8.8.4.4 (8.8.4.4): 56 data bytes
    ```
    The container is unable to reach the outside network because the container has no connection to the host or docker bridge network.



### 2. Bridged Container Network
Step by Step Guide
1.	Run the following command to create a container using the docker bridge, this container will automatically delete itself after it outputs the Ethernet configurations.  
`docker run --rm --net bridge alpine:latest ip addr`  
The output should look like the following:  
    ```
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
        valid_lft forever preferred_lft forever
    27: eth0@if28: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue 
        link/ether 02:42:ac:11:00:05 brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.5/16 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::42:acff:fe11:5/64 scope link tentative 
        valid_lft forever preferred_lft forever
    ```
    Take note that the above container has an assigned eth0; proceed to the next step and try to ping a public IP address.

2.	Run the following command to create a container using the docker bridge, this container will automatically delete itself after it pings the Internet address 8.8.4.4 twice.  
    `docker run --rm --net bridge alpine:latest ping -w 2 8.8.4.4`  
The output should look like the following:
    ```
    PING 8.8.4.4 (8.8.4.4): 56 data bytes
    64 bytes from 8.8.4.4: seq=0 ttl=61 time=39.776 ms
    64 bytes from 8.8.4.4: seq=1 ttl=61 time=37.873 ms

    --- 8.8.4.4 ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    ```
    Unlike the container using the network none, this container is able to successfully access the Internet through the docker bridge and the docker host’s network.

3.	Run the following command to create a container using the docker bridge, this container will automatically delete itself after it ping www.google.com twice. This demonstrates that the container leverages the docker host’s /etc/resolv.conf.  
    `docker run --rm --net bridge alpine:latest ping -w 2 www.google.com`  
The output should look like the following:
    ```
    PING www.google.com (172.217.1.132): 56 data bytes
    64 bytes from 172.217.1.132: seq=0 ttl=61 time=115.687 ms
    64 bytes from 172.217.1.132: seq=1 ttl=61 time=89.327 ms

    --- www.google.com ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    round-trip min/avg/max = 89.327/102.507/115.687 ms
    ```
    The container is also able successfully access the Internet through the docker bridge and the docker host’s network using a DNS name.

4.	Run following command and don’t use a --net option.   
    `docker run --rm alpine:latest ip addr`  
The output should look like the following:
    ```
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
        valid_lft forever preferred_lft forever
    35: eth0@if36: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue 
        link/ether 02:42:ac:11:00:05 brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.5/16 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::42:acff:fe11:5/64 scope link tentative 
        valid_lft forever preferred_lft forever
    ```
    The container is automatically assigned eth0 and assigned an IP Address. This is the default behavior of docker. By default, docker will assign containers to the default bridge network.

5.	Run following command and statically assign a dns server to the containers /etc/resolv.conf  
`docker run --rm --dns 8.8.8.8 aslaen/nslookup nslookup google.com`  
The output should look like the following:
    ```
    Server:    8.8.8.8
    Address 1: 8.8.8.8 google-public-dns-b.google.com

    Name:      google.com
    Address 1: 2607:f8b0:4005:804::200e sfo07s13-in-x0e.1e100.net
    Address 2: 216.58.217.206 lax17s05-in-f206.1e100.net
    ```
    The container’s /etc/resolv.conf will resolve the IP Addess for the DNS name google.com (similar to most Linux systems).
### 3. DNS Search and Host Record
Step by Step Guide
1.	Run following command and assign a DNS search suffix to the container.  
`docker run --rm --dns 8.8.8.8 --dns-search docker.com aslaen/nslookup nslookup docs`  
The output should look like the following:
    ```
    Server:    8.8.8.8
    Address 1: 8.8.8.8

    Name:      docs
    Address 1: 205.251.215.192 server-205-251-215-192.sfo5.r.cloudfront.net
    Address 2: 205.251.215.83  server-205-251-215-83.sfo5.r.cloudfront.net
    Address 3: 205.251.215.241 server-205-251-215-241.sfo5.r.cloudfront.net
    Address 4: 205.251.215.138 server-205-251-215-138.sfo5.r.cloudfront.net
    Address 5: 205.251.215.191 server-205-251-215-191.sfo5.r.cloudfront.net
    Address 6: 205.251.215.136 server-205-251-215-136.sfo5.r.cloudfront.net
    Address 7: 205.251.215.137 server-205-251-215-137.sfo5.r.cloudfront.net
    Address 8: 205.251.215.125 server-205-251-215-125.sfo5.r.cloudfront.net
    ```
    Adding a dns-server suffix to container allows the container to append the search suffix to the containers DNS name resolution. In the above example, searching for docs, resulting in entire DNS lookup being docs.docker.com (similar to most Linux systems).


3.	On the command line, enter  
```
    docker run --rm --hostname containerA --add-host docker.com:127.0.0.1 --add-host test:10.10.10.1 alpine:latest cat /etc/hosts  
```
The output should look like the following:
    ```
    127.0.0.1	localhost
    ::1	localhost ip6-localhost ip6-loopback
    fe00::0	ip6-localnet
    ff00::0	ip6-mcastprefix
    ff02::1	ip6-allnodes
    ff02::2	ip6-allrouters
    127.0.0.1	docker.com
    10.10.10.1	test
    172.17.0.5	containerA
    ```

	
### 4. Expose and Map Ports
Step by Step Guide
1.	Run the following command and set the container’s docker name to demo1, expose ports 5000 and 5001, and dynamically map the exposed ports to the container.  
`docker run -d --name demo1 --expose 5000 --expose 5001 -P alpine:latest top`  
The output will be a container  ID:
    ```
    3426691e4bf
    ```
    Display the port assignments and their dynamic mappings.  
    `docker port demo1`  
    The output should look like the following:
    ```
    5000/tcp -> 0.0.0.0:32773
    5001/tcp -> 0.0.0.0:32772
    ```

2.	Run the following command and set the container’s docker name to demo2, map container TCP port 80 to host’s ephemeral TCP port range.  
    `docker run -d --name demo2 -p 80 alpine:latest top`  
The output will be a container  ID:  
    ```
    9661024a8265
    ```
    Enter  
    `docker port demo2`  
    The output should look like the following:
    ```
    80/tcp -> 0.0.0.0:32774
    ```

3.	Run the following command and set the container’s docker name to demo3, map container TCP port 80 to the host’s TCP port 80.  
`docker run -d --name demo3 -p 80:80 alpine:latest top`  
The output will be a container  ID:  
    ```
    548a5f3b1ddd9
    ```
    Enter  
    `docker port $(docker ps -lq)`  
    The output should look like the following:
    ```
    80/tcp -> 0.0.0.0:80
    ```

4.	Run the following command and set the container’s docker name to demo4, map container TCP port 80 to the host’s ephemeral port range, and bind it to the host’s loopback interface.  
`docker run -d --name demo4 -p 127.0.0.1::80 alpine:latest top`  
    The output will be a container  ID:
    ```
    47f43d89c6240e
    ```
    Enter  
    `docker port demo4`  
    The output should look like the following:
    ```
    80/tcp -> 127.0.0.1:32775
    ```

5.	Run the following command and set the container’s docker name to demo5, map container TCP port 80 to the host’s TCP port 81 and bind it to the host’s loopback interface.  
`docker run -d --name demo5 -p 127.0.0.1:81:80 alpine:latest top`  
    The output will be a container  ID:
    ```
    b045c4cdf420a6077
    ```
    Enter  
    `docker port demo5`  
    The output should look like the following:  
    ```
    80/tcp -> 127.0.0.1:81
    ```

6.	Clean up the lab environment:  
`docker rm -f demo1 demo2 demo3 demo4 demo5`

### 5. Shared Container Network
Step by Step Guide
1.	In the command line, enter  
`docker run -d --name secret alpine top`  
The output should look like the following:  
    ```
    Unable to find image 'alpine:latest' locally
    latest: Pulling from library/alpine
    e110a4a17941: Pull complete 
    Digest: sha256:3dcdb92d7432d56
    Status: Downloaded newer image for alpine:latest
    57f74d410cb10
    ```

2.	In the command line, enter  
`docker run -d --name shared --net container:secret alpine top`  
    The output will be a container  ID:
    ```
    b045c4cdf420a6077
    ```

3.	Log into the container shared and run ifconfig.  
`docker exec -it shared /bin/ash`  
`/ # ifconfig`  

    The output should look like the following:  
    ```
    eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:03
            inet addr:172.17.0.3  Bcast:0.0.0.0  Mask:255.255.0.0
            inet6 addr: fe80::42:acff:fe11:3%32533/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:8 errors:0 dropped:0 overruns:0 frame:0
            TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:648 (648.0 B)  TX bytes:648 (648.0 B)
    lo        Link encap:Local Loopback
    ```

    Note the container’s eth0 MAC Address  

    To leave the container type  
    `exit`

4.	Log into the container secret and run ifconfig.  
`docker exec -it secret /bin/ash`  
`/ # ifconfig`

    The output should look like the following:
    ```
    eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:03
            inet addr:172.17.0.3  Bcast:0.0.0.0  Mask:255.255.0.0
            inet6 addr: fe80::42:acff:fe11:3%32533/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:8 errors:0 dropped:0 overruns:0 frame:0
            TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:648 (648.0 B)  TX bytes:648 (648.0 B)
    lo        Link encap:Local Loopback
    ```
    Note the container’s eth0 MAC Address; the MAC address is identical to the shared container. The eth0 resides with the "shared" container; however, the "secret" container accesses the network through the "shared" container. This isolates the "secret" container from the network.

Type "exit" to leave container
5.	Clean up the lab environment:  
`docker rm -f shared secret`




### 6. Open Container Network
Step by Step Guide
1.	Run the following command and deploy a container using the --net host  
`docker run --rm --net host alpine:latest ip addr`  
    The output should look like the following:
    ```
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
        valid_lft forever preferred_lft forever
    2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop qlen 1000
        link/ether 76:99:f4:98:44:dd brd ff:ff:ff:ff:ff:ff
    3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 08:00:27:88:da:a5 brd ff:ff:ff:ff:ff:ff
        inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fe88:daa5/64 scope link 
        valid_lft forever preferred_lft forever
    4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
        link/ether 08:00:27:68:de:1a brd ff:ff:ff:ff:ff:ff
        inet 192.168.99.100/24 brd 192.168.99.255 scope global eth1
        valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fe68:de1a/64 scope link 
        valid_lft forever preferred_lft forever
    6: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue 
        link/ether 02:42:89:0a:5b:6d brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.1/16 scope global docker0
        valid_lft forever preferred_lft forever
        inet6 fe80::42:89ff:fe0a:5b6d/64 scope link 
        valid_lft forever preferred_lft forever
    22: veth6c92100@if21: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue master docker0 
        link/ether 96:f7:a0:7c:55:95 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::94f7:a0ff:fe7c:5595/64 scope link 
        valid_lft forever preferred_lft forever
    ```
    Using the --net host method gives the container access to the docker host’s network interfaces and should be used only as a last resort. Although the container does have access to the host’s network interfaces, it does not have access to the host’s resources outside of its namespace (cpu, ram, storage, etc).

### Lab Complete!

<!-- 
LastTested: 2018-09-28
OS: Ubuntu 18.04
DockerVersion: 18.06.1-ce, build e68fc7a
-->
