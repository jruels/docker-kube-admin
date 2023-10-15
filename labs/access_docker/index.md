# Lab Setup 
At the top of this page, right-click the "GitHub" button, and choose "open in new tab". In the new tab, in the top right corner, click the green “Code” button, then click “Download as zip”. Once the download is done, extract the zip file to somewhere you can easily access it.

## MacOS 

In the folder extracted from above, go to the `keys` folder and set the permissions of lab.pem`.

### Set permission on SSH key 
```
chmod 600 /path/to/lab.pem
```

### SSH to lab servers 
Log into the servers provided by the instructor sing the `lab.pem` key file.

The username for SSH is `ubuntu`

```
ssh -i /path/to/lab.pem ubuntu@<LAB IP> 
```


## Windows 
The username for SSH is `ubuntu`

Open Putty and configure a new session for the VM.

![img](https://jruels.github.io/adv-ansible/labs/access_lab/images/putty-session.png)

Expand Connection -> SSH -> Auth -> Credentials, click “Browse”, and then choose the `lab.ppk` file from the `keys` directory

![image-20230918185300995](https://jruels.github.io/adv-ansible/labs/access_lab/images/putty-auth.png)

Remember to save your session.
