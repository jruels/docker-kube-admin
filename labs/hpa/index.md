# Horizontal Pod Autoscaling

In this lab you will: 

* Deploy the Kubernetes Metrics Server
* Deploy a stateless application
* Configure a Horizontal Pod Autoscaling policy
* Trigger the HPA and confirm Pods are scaled to handle the load

Autoscaling is a common practice used to dynamically scale up or down resources based on the workload requirements.
In Kubernetes there are three types of autoscaling: Horizontal, Vertical and Cluster. 
The Horizontal Pod Autoscaler increases or decreases the number of Pods in a Deployment based on resource utilization. 
While the Cluster Autoscaler is highly dependent on the underlying capabilities of the cloud provider, the Horizontal and Vertical autoscalers 
are cloud agnostic.

## Install Kubernetes Metrics Server
Install the Metrics server
```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Confirm the server was installed correctly.

To view nodes metrics run:

```bash
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq .
```

To view pods metrics run:

```bash
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods" | jq .
```

### Auto Scaling based on CPU and memory usage


You will use a small Golang-based web app to test the Horizontal Pod Autoscaler (HPA).   

Deploy the demo app:   

```bash
kubectl create -f ./podinfo/podinfo-svc.yaml,./podinfo/podinfo-dep.yaml
```

To access the application we need to find the `EXTERNAL_IP`    
```
kubectl get svc podinfo
```

You should see something similiar to:    
```
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)          AGE
podinfo   LoadBalancer   10.15.243.98   35.226.204.150   9898:30813/TCP   3h20m
```

Now in a browser load http://[EXTERNAL-IP]:9898   

Next create a new HPA that maintains a minimum of two replicas and max of ten. The replicas are dynamically
adjusted, if the average CPU is over 80% or if the memory goes above 200Mi:   

Review below
```yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: podinfo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: podinfo
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 80
  - type: Resource
    resource:
      name: memory
      targetAverageValue: 200Mi
```

Create the new HPA:

```bash
kubectl create -f ./podinfo/podinfo-hpa.yaml
```

After a few seconds the HPA controller queries the metrics server and then fetches the CPU 
and memory usage:

```bash
kubectl get hpa

NAME      REFERENCE            TARGETS                      MINPODS   MAXPODS   REPLICAS   AGE
podinfo   Deployment/podinfo   2826240 / 200Mi, 15% / 80%   2         10        2          5m
```

To run the app we must install Go
```sh
sudo yum install -y golang
```

In order to increase the CPU usage, install and run a load test with `rakyll/hey`:

```bash
go get -u github.com/rakyll/hey
```

Execute 10,000 requests **Replace EXTERNAL_IP**
```bash
~/go/bin/hey -n 10000 -q 10 -c 5 http://[EXTERNAL_IP]:9898/
```

Open a new terminal and monitor the HPA events by running:

```bash
$ kubectl describe hpa

Events:
  Type    Reason             Age   From                       Message
  ----    ------             ----  ----                       -------
  Normal  SuccessfulRescale  7m    horizontal-pod-autoscaler  New size: 4; reason: cpu resource utilization (percentage of request) above target
  Normal  SuccessfulRescale  3m    horizontal-pod-autoscaler  New size: 8; reason: cpu resource utilization (percentage of request) above target
```

Delete resources

```bash
kubectl delete -f ./podinfo/podinfo-hpa.yaml,./podinfo/podinfo-dep.yaml,./podinfo/podinfo-svc.yaml
```
## Congrats!

