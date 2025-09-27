# MetalLB
This chart installs MetalLB into my own cluster so I can expose ingress resources properly without having to use DNS to point directly to my node's IP.

## Prerequisite
Setup a namespace for MetalLB
```shell
kubectl create namespace metallb-system
```

## How to Install
To install this chart, use the following:
```shell
helm dependency update .

# Note: Due to CRD install by dependency chart, I haven't tested a one shot deployment.
# It may fail even with the hooks in place for the manifests in `./templates`
helm upgrade --install metallb \
  --namespace metallb-system \
  --dependency-update \
  .
```

## Validation
Check the resources provisioned.
```
$ kubectl get all -n metallb-system
NAME                                     READY   STATUS    RESTARTS   AGE
pod/metallb-controller-758987bc5-bpctr   1/1     Running   0          20m
pod/metallb-speaker-dwv76                4/4     Running   0          20m
pod/metallb-speaker-sngb9                4/4     Running   0          20m

NAME                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/metallb-webhook-service   ClusterIP   10.107.219.244   <none>        443/TCP   20m

NAME                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/metallb-speaker   2         2         2       2            2           kubernetes.io/os=linux   20m

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/metallb-controller   1/1     1            1           20m

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/metallb-controller-758987bc5   1         1         1       20m
```

Metal LB Configurations
```
$ kubectl get ipaddresspools.metallb.io -n metallb-system
NAME           AUTO ASSIGN   AVOID BUGGY IPS   ADDRESSES
default-pool   true          false             ["192.168.0.40-192.168.0.49"]

$ kubectl get l2advertisements.metallb.io -n metallb-system
NAME                         IPADDRESSPOOLS     IPADDRESSPOOL SELECTORS   INTERFACES
default-pool-advertisement   ["default-pool"]
```

Check Ingress Controller now has an external IP
```
$ kubectl get -n ingress svc ingress-ingress-nginx-controller
NAME                               TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
ingress-ingress-nginx-controller   LoadBalancer   10.103.78.181   192.168.0.40   80:30650/TCP,443:32540/TCP   323d
```