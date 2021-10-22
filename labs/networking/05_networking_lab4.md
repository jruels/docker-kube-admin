# LAB
## Networking Part 4
*Lab Objectives*  
This lab demonstrates how to deploy multiple instances of the WordPress All-In-One application.

Lab Structure - Overview
1.	Deploy Three WordPress All-In-Ones

 
### 1. Deploy Three WordPress All-In-Ones
Step by Step Guide
1.	Locate the IP address of the Master machine in lab folder.

2.	If on a Mac, or using Linux:  
In a command line, enter  
`ssh -i </Users/…/>docker.pem ubuntu@<IP>`
The .pem file will be provided by the instructor for this lab. This command will connect the console to the Docker machine.  

*If using Windows: Open Putty and connect to the session you saved earlier.*
 

3.	Deploy multiple WordPress all-in-one applications and dynamically map their exposed ports using the dynamic port mapping switch (-P).  
`for i in {1..3}; do docker run -d -P s5atrain/wordpress:aio; done`

4.	Using past techniques, answer the following questions:   
    - What ports are mapped to the Docker host by each container? (Hint: docker port <container ID>)

    - How would a user access these three applications? 

5.	Test your solution and access the WordPress deployments with the method identified in the previous step. 
6.	Clean up the lab environment by stopping and deleting all three of the WordPress all-in-one containers. Can you execute a single command to list all three containers from all of the running containers on the host?

### Lab Complete!

<!-- 
LastTested: 2018-09-28
OS: Ubuntu 18.04
DockerVersion: 18.06.1-ce, build e68fc7a
-->