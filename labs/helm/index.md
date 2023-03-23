# Helm walkthrough
In this lab you will learn how to how to write your first Chart, and deploy a containerized application. 

## Install Helm

Confirm if `helm` is installed: 
```sh
helm version
```

You should see output showing a Helm 3 version.

Sample output:
```
Version:"v3.7.1"
```

If you do not have Helm installed install it with the following commands.
```sh
export VERIFY_CHECKSUM=false
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
sudo mv /usr/local/bin/helm $HOME/.local/bin
```

Helm  simplifies installing, managing, updating and removing applications on your Kubernetes cluster. 

To search the `artifact repo` for a chart you can simply run `helm search hub package`, for example if you want to search for wordpress run:
```
helm search hub wordpress
```

## Create a new Helm chart 
Now let's create a new chart `app-demo`
```
helm create demo-app
```

You will now see a new `demo-app` directory created. 
Look inside this directory and you will see something like below: 
```
demo-app
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│      └── test-connection.yaml
└── values.yaml
```

As described in the slides the main files we are interested in are: 

* Chart.yaml
	* Contains chart information (Chart version, App version, description etc..) 
* templates
	* Contains Kubernetes manifest templates which combined with the `values.yaml` will generate valid Kubernetes manifest files
	* values.yaml
		* Default values used in Kubernetes manifest templates. 

## Deploy `demo-app`
When you run `helm create demo-app` it will create a default chart to deploy `nginx`. 

Deploy chart 
```
helm install demo-app ./demo-app --set service.type=LoadBalancer
```

Now confirm the chart was deployed successfully. 
```
helm ls 
```

You should see something similar to: 
```
NAME    	REVISION	UPDATED                 	STATUS  	CHART         	APP VERSION	NAMESPACE
demo-app	1       	Wed Nov  6 20:43:48 2019	DEPLOYED	demo-app-0.1.0	1.0        	default
```

We can see that the `demo-app` chart was deployed in the `default` namespace. 

Now confirm everything is running: 

Check that Pods are running:
```
kubectl get pods -l app.kubernetes.io/name=demo-app
``` 

You should see one replica running 
```
NAME                      READY   STATUS    RESTARTS   AGE
demo-app-8b9c4f6d-bxk48   1/1     Running   0          55m
```

Confirm the Service is running and type `LoadBalancer`
```
kubectl get svc -l app.kubernetes.io/name=demo-app
```

Should show:
```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
demo-app     LoadBalancer   10.15.246.153  ae2ca48fd000...  80:31075/TCP   2m51s
```

## Confirm app is running 
To access the app follow the instructions from the `helm install` command:

This will show the URL to load in a browser to access the application. 


## Update Chart with our application values 
Now that we've run through deploying the default `nginx` app we need to update the files to deploy our own application. 

Start by updating `demo-app/Chart.yaml` so it contains: 
```yaml
apiVersion: v2
name: helm-demo-app
description: A demo Helm chart
type: application
version: 0.0.1
appVersion: "0.0.1"
```

The following has been updated:    
`appVersion`: This is the version of application that will be deployed   
`description`: Description of Chart    
`version`: Version of the Chart   

### Update values
Now in `demo-app/values.yaml` update the following values:
* image.repository: the url where our Docker image can be found
* image.tag: the tag of the Docker image we want to deploy
* service.type: we change it to LoadBalancer instead of ClusterIP in order to expose it outside our cluster
* service.port: we set it to 8080, the port our application is using


The `values.yaml` has the following content after our changes
```yaml
image:
    repository: aslaen/helm-demo
    tag: v1 

service:
    type: LoadBalancer
    port: 8080
```

We also need to update `targetPort` in `demo-app/templates/service.yaml` so it will point to port we defined in `values.yaml`


```yaml
spec:
    type: {% raw %} {{ .Values.service.type }} {% endraw %}
    ports:
        - port: {% raw %} {{ .Values.service.port }} {% endraw %}
          targetPort: {% raw %} {{ .Values.service.port }} {% endraw %}
```

We now need to update `demo-app/templates/deployment.yaml` and remove the `liveness` and `readiness` probe sections. 
```yaml
<snip..>
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
<..snip>
```

### Check syntax 
Now we need to confirm the changes we made are valid

Rename the `demo-app` to `helm-demo-app` to match our `Chart.yaml`
```
mv demo-app helm-demo-app
```

Run `lint` to check syntax
```
helm lint helm-demo-app
```

```
==> Linting helm-demo-app
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

If there were no errors continue with the lab.

### Package Helm chart 
Now that we have adapted the chart configuration to our needs and it is time to package our Helm Chart. Execute the following command, it will search for a directory with the name of the Helm Chart from where it is issued:
```
helm package helm-demo-app
```

The package is being created (a `tar.gz` file) and the following response is shown:
> Successfully packaged chart and saved it to: /home/<user>/helm/helm-demo-app-0.0.1.tgz  

## Deploy newly created Chart
After all the preparation work we have done so far it is finally time to install our application.   
```
helm install helm-demo-app ./helm-demo-app
```

Run the commands in the output to set environment variables to access service.

Confirm pod is in a `RUNNING` state 
```
kubectl get pods -l app.kubernetes.io/name=helm-demo-app
```

```
NAME                             READY   STATUS    RESTARTS   AGE    LABELS
helm-demo-app-5f84b5b8c6-jkqkh   1/1     Running   0          6m6s   app.kubernetes.io/instance=helm-demo-app,app.kubernetes.io/name=helm-demo-app,pod-template-hash=5f84b5b8c6
```

Confirm the service is available 
```
kubectl get svc -l app.kubernetes.io/name=helm-demo-app
```

```
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)          AGE
helm-demo-app   LoadBalancer   10.31.244.161   104.197.184.61   8080:30099/TCP   2m18s
```

Now let's access our application 
```
curl http://$SERVICE_IP:8080/hello
```

Output should show the hostname of the Pod we connected to. 
```
Hello Kubernetes! From host: helm-demo-app-5f84b5b8c6-jkqkh/10.36.0.1
```

Great! We've deployed an application using Helm. 

## Upgrade Helm chart 
Now let's upgrade the Helm chart to run 2 replicas 

In `values.yaml` change `replicaCount` from `1` to `2`

We also need to change the Chart version number from `0.0.1` to `0.1.0` in the `Chart.yaml` to show we have made a significant change. 

Redeploy the Helm chart so it reads the new value. 
```
helm upgrade helm-demo-app helm-demo-app
```

Confirm there are now 2 Pods running 
```
kubectl get pods -l app.kubernetes.io/name=helm-demo-app
```

Run the same `curl` command from above and confirm you now see two different hostnames. 

Check the information for our deployed chart 
```
helm ls 
```

You will now see there are 2 revisions and we are running chart `helm-demo-app-0.2.0` 

```
NAME         	REVISION	UPDATED                 	STATUS  	CHART              	APP VERSION	NAMESPACE
helm-demo-app	2       	Wed Nov  6 23:07:42 2019	DEPLOYED	helm-demo-app-0.2.0	v1         	default
```

To see more about the chart you can run 
```
helm history helm-demo-app
```

```
REVISION	UPDATED                 	STATUS    	CHART              	APP VERSION	DESCRIPTION
1       	Wed Nov  6 22:51:14 2019	SUPERSEDED	helm-demo-app-0.1.0	v1         	Install complete
2       	Wed Nov  6 23:07:42 2019	DEPLOYED  	helm-demo-app-0.2.0	v1         	Upgrade complete
```

## Rollback release
What if we notice that we made a mistake after upgrading? We can easily rollback the Chart to a previous revision. We need to provide the release name and the revision number we want to rollback to:
```
helm rollback helm-demo-app 1
```

It will return that rollback was successful and you can confirm that by checking only 1 Pod is running. 

You can also check by looking at the `helm history helm-demo-app` 

You should now see 3 releases and the current one has a description of "Rollback to v1" 

If you would like to see more information about a revision you can run:  

```
helm status helm-demo-app --revision 1 
```

## Congratulations!
