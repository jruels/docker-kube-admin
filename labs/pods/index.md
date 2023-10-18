# Pods
## Lab Objectives 
In this lab we will configure a Kubernetes Pod hosting a mysql database from the command-line. We’ll also log into the container we deploy into this lab using the mysql-client. 

## Lab Structure - Overview 
1. Run a command to deploy a pod from the command-line
2. Run a command to deploy a pod sourced from a YAML file
3. Run a command to exec a shell into a Kubernetes hosted container
4. Run a command to exec directly into the mysql-client from the command-line

### Deploy a Pod from the command-line 
1. Show the nodes of the cluster 
```
kubectl get nodes 
```

2. Show information about the cluster
```
kubectl cluster-info
```

3. Dump information about the cluster
```
kubectl cluster-info dump
```

4. Show all Pods in the `kube-system` namespace 
```
kubectl get pods -n kube-system
```

5. Deploy `nginx` Pod
```
kubectl run nginx-pod-lab --image=nginx:alpine --port=80
```

6. Confirm Pod is running'
```
kubectl get pods 
```

7. Get information about Pod in `json` format 
```
kubectl get pod nginx-pod-lab -o json 
```

8. Now get info about it in `YAML` syntax
```
kubectl get pod nginx-pod-lab -o yaml
```

9. Delete everything! 
```
kubectl delete all --all
```



### Clone the GitHub repository

The lab files live in a GitHub repository. Clone it to the AWS CloudShell.

```bash
git clone https://github.com/jruels/docker-kube-admin.git
```

To determine which lab directory you should work from, look at the lab page URL in the browser. For example, this lab has a URL of `https://jruels.github.io/docker-kube-admin/labs/pods/`. This tells you the lab files are in GitHub repo directory `docker-kube-admin/labs/pods`

### Create Pod from manifest

1. In the lab's manifests directory, you will find  `nginx-kube.yml` . This will launch a simple nginx server. Deploy it with following:
```
kubectl apply -f manifests/nginx-kube.yml
```

2. Show the deployed Pods
```
kubectl get pods 
```

You should see something like this: 
```
NAME                            READY   STATUS    RESTARTS   AGE
nginx-web                       1/1     Running   0          15s
```

3. Cleanup everything 
```
kubectl delete pods --all
```

### Create a Pod with 2 containers 
1. In the manifests directory you will find `two-containers.yml`. Review the manifest and see if you can figure out what it is doing, then deploy it: 
```
kubectl apply -f manifests/two-containers.yml
```

2. Show the deployed Pods
```
kubectl get pods 
```

3. Look at the details of the Pod 
```
kubectl describe pod two-containers 
```

Sample output: 
```
Name:         two-containers
Namespace:    default
Priority:     0
Node:         ip-192-168-29-163.us-west-2.compute.internal/192.168.29.163
Start Time:   Tue, 27 Aug 2019 22:38:37 -0700
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"two-containers","namespace":"default"},"spec":{"containers":[{"image"...
              kubernetes.io/psp: eks.privileged
Status:       Running
IP:           192.168.22.118
Containers:
  nginx-container:
    Container ID:   docker://d5f34b906d03eddc2521c3860558d14174d2e63b786a22471a3c818cb5e5ad73
<snip>...
```

4. Log into the `nginx` container of the `two-containers` Pod:
```
kubectl exec -it two-containers -c nginx-container -- bash
```

5. Validate `nginx` is running in the container: 
```
apt-get update && apt-get install -y procps && ps aux
```

Sample output:
```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  10624  5412 ?        Ss   05:38   0:00 nginx: master process nginx -g daemon off;
nginx        7  0.0  0.0  11096  2604 ?        S    05:38   0:00 nginx: worker process
root         8  0.0  0.0   3868  3244 pts/0    Ss   05:49   0:00 bash
root       338  0.0  0.0   7640  2672 pts/0    R+   05:49   0:00 ps aux
```

6. Check the default nginx page is loading using curl. 
```
curl localhost 
```

Output: 
```
Hello from the debian container
```

7. Exit the `nginx` container 
```
exit
```

### Deploy MySQLDB and connect to the client
1. Deploy a MySQL DB image
```
kubectl run mysql-demo --image=mysql --port 3306 --env="MYSQL_ROOT_PASSWORD=password"
```

2. Show all of the running Pods, note the name of the Pod you just created
```
kubectl get pods 
```

Sample output:
```
NAME             READY   STATUS     RESTARTS   AGE
mysql-demo       1/1     Running    0          83s
two-containers   1/2     NotReady   0          13m
```

3. Log into the new MySQL container: 
```
kubectl exec -it mysql-demo -- mysql -ppassword
```

4. Show databases
```
SHOW databases;
```

5. Exit container
```
exit
```

6. Cleanup everything 
```
kubectl delete pods --all
```

## Lab complete
