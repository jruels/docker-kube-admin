# lab setup

## Lab Setup
In this lab, you will log into the AWS Console and start a CloudShell session. We will be using this for all future labs. 

### Log into the AWS Cloud Console
Log into the [AWS Console](https://d-916729713a.awsapps.com/start/) in a browser using the credentials provided by the instructor.

Once you have logged in, select **AWS Account (1)** -> **User Account** -> **Management console**

In the console, on the top right side, select the `US-East-2` region.

![region](images/region.png)

### Start the CloudShell 
After selecting the `US-East-2` region, use the search bar at the top of the page to search for `CloudShell`. Click on the result shown in the screenshot.
![cloudshell](images/cloudshell.png)

## Cleanup
Remove any files from previous training sessions.
```bash
rm -rf * && rm -rf $HOME/.local
```

## Congratulations
You are now logged into the AWS CloudShell, and ready for future labs. 
