---
title: "Deploying WordPress and MySQL on Kubernetes using Helm Chart"
description: >-
  This is part 2 of 3 in my "how I built this blog" series.
pubDate: 2021/09/27
heroImage: "../../assets/images/K8s-Helm-WP-MYSQL.png"
category: Building this Blog
tags:
  - "helm"
  - "kubernetes"
  - "mysql"
  - "wordpress"

---

**Update as of March 2024**: I have migrated my blog from AWS to self-hosted k8s cluster. The site is fronted via Cloudflare. Check out this [blog post](https://lexdsolutions.com/2024/03/migrating-my-blog-from-aws-to-self-hosting-with-cloudflare-tunnel/) or my recent blogs for more details. The chart has been modified slightly to suit my new requirements.

This is part 3 of 3 to my “how I built this blog” series. If you haven't seen the first 2 parts of this series yet, you can find them here:

- Part 1 - [Using CloudFormation and Terraform on my Brand New AWS Account](https://lexdsolutions.com/2021/09/using-cloudformation-and-terraform-on-my-brand-new-aws-account/)

- Part 2 - [Ansible to Setup MicroK8s and a NFS Server on Ubuntu 20.04](https://lexdsolutions.com/2021/09/setting-up-microk8s-and-a-nfs-server-using-ansible/)

In the previous 2 posts, I've talked about how I built the cloud infrastructure on AWS and configured the OS (Ubuntu 20.04) with MicroK8s. It is now time to deploy WordPress and the backend database onto Kubernetes by using Helm.

## What is Helm and Helm Charts?

The definition from the official Helm website.

> Helm helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

There are plenty of pre-built Helm charts online to deploy WordPress on Kubernetes, however the chart I used to deploy this blog is developed from scratch by myself. By doing so, it enables me to have full control of all the resources and to keep everything to the minimal.

Another benefit here is that I am able to then create my own TLS certificate renewal bot which you can read more about it on my post here:

https://lexdsolutions.com/2021/10/how-i-created-my-own-tls-certificate-renewal-bot-on-kubernetes/

## My WordPress Helm Chart

Each of the Kubernetes manifests used in this chart is be explained below.

This section references the Helm chart my [GitHub page](https://github.com/88lexd/lexd-solutions/tree/main/wordpress/3-app-configuration/wordpress-helm).

**Minimum Requirements**

Before digging into the code, it is good to know that the following is the minimum requirements to build out a Helm chart

- Chart.yaml - Contains the metadata about the chart. e.g. name of the chart, version, maintainers etc.

- values.yaml - While is not a requirement, it is a good practice to use this file to control the values for the templates. This file contains the default values, but it can be overwritten if the user supplies a different value file during deployment.
    - values-dev.yaml / values-prod.yaml - These are passed into helm by using --values parameter to overwrite the default values.

- templates directory - Contains the manifests which Helm will deploy. The manifest/template files will reference the values supplied by "values.yaml".

**WordPress and MySQL Deployment**

This section references the 2 following files:

- [deployment-wordpress.yaml](https://github.com/88lexd/lexd-solutions/blob/main/aws-wordpress/3-app-configuration/wordpress-helm/templates/deployment-wordpress.yaml)

- [deployment-mysql.yaml](https://github.com/88lexd/lexd-solutions/blob/main/aws-wordpress/3-app-configuration/wordpress-helm/templates/deployment-mysql.yaml)

These 2 templates will deploy 3 different resources each and these are:

**_Kind: Deployment_**

The deployment resource is responsible for creating the pods. The number of pods, the image to use and the k8s secret for the MySQL password is referencing to what is defined in the "values.yaml" file.

For the MySQL deployment, due to the nature of being a "stateful" application, we can only deploy a single replica. Although is a single replica, because it is using a persistent volume which uses NFS as the backend, this pod can be recreated on a different nodes in the cluster and the data will still be the same. Essentially this deployment creates a highly available MySQL instance that can be run on different nodes. (_note: this is currently not the case because I am only using a single server running NFS, this will be highly available once I start using AWS EFS_).

_**Kind: PersistentVolumeClaim **(PVC)****_

By using the storage class "nfs-client" which was deployed by using Ansible from part 2 of this series. The "_nfs-subdir-external-provisioner_" is able to dynamically provision persistent volumes for the pods to use.

As all the pods are referencing to the PVC, they will share the same persistent volume which is mounted to /var/www/html for WordPress and /var/lib/mysql for MySQL.

Note: The pods itself don't mount to the NFS directly. It is the node itself that mounts to the NFS and then is passed this down to the pod. Example:

```raw
ubuntu@ip-10-0-10-xxx:~$ kubectl describe pv -n prod pvc-3761c4b3-dbef-4cc3-a6cc-xxxxxx
Name:            pvc-3761c4b3-dbef-4cc3-a6cc-xxxxxx
Labels:          <none>
Annotations:     pv.kubernetes.io/provisioned-by: cluster.local/nfs-subdir-external-provisioner
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    nfs-client
Status:          Bound
Claim:           prod/wordpress-pvc
Reclaim Policy:  Delete
Access Modes:    RWX
VolumeMode:      Filesystem
Capacity:        1Mi
Node Affinity:   <none>
Message:
Source:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    10.0.10.xxx
    Path:      /nfs/k8s/prod-wordpress-pvc-pvc-3761c4b3-dbef-4cc3-a6cc-xxxxxx
    ReadOnly:  false
Events:        <none>

ubuntu@ip-10-0-10-xxx:~$ netstat -an | grep ':2049' | grep ESTABLISHED
tcp        0      0 10.0.10.xxx:2049        10.0.10.xxx:665         ESTABLISHED
tcp        0      0 10.0.10.xxx:665         10.0.10.xxx:2049        ESTABLISHED
```

**_Kind: Service_**

Without using Kubernetes service, we must locate each pod and forward traffic directly into the many different dynamic ports used for each pod. Service allows us to abstract all this and expose our pods through a single endpoint. It will also performs the load balancing between the pods.

The service knows which pods to use is thanks to the "selector" configuration. The pods that are created through the deployment contains the same labels and therefore it knows to use those pods for this service.

**Ingress Controller** ([ingress.yaml](https://github.com/88lexd/lexd-solutions/blob/main/aws-wordpress/3-app-configuration/wordpress-helm/templates/ingress.yaml))

**_Kind: Ingress_**

The ingress controller in my cluster is powered by Nginx. This is the service that get exposed externally on the network and in this case, it is the Internet because my EC2 instance is located on the public subnet.

_Note: as mentioned in my previous 2 posts, reason for this is so I can start with the minimal cost by using only a single EC2 instance._

By using ingress, I can configure rules to define how the web service is accessed. This includes configuring it to use SSL/TLS with my pre-defined certificate which is stored as a K8s secret.

When there is a need for me to scale up the cluster, then I will move all my nodes into the private subnets and implement the load balancer service which will created an ALB for the front-end that routes traffic back to the end services.

## Conclusion

Thank you for reaching this far. This now concludes my "how I built this blog" series. If there is anything specific you would like me to talk about or to go more into details, please leave a comment below or you reach out to me directly.

For my next blog, I will talking about how I will be using assume role with AWS to stay secure.

Subscribe to my blog by using form on the main page to be notified for all future new posts!
