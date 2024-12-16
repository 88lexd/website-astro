# Argo CD Helm Chart
Use this to install Argo CD for automated deployments.

## Installing this chart
Create Namespace (if I ever rebuild K8s)
```
$ kubectl create ns argo-cd
```

Install chart
```
$ cd ./infra/argo-cd-chart

$ helm repo add argo-cd https://argoproj.github.io/argo-helm
$ helm dep update .

# Install
$ helm upgrade --install argo-cd .
```

## Accessing Argo CD
Use the following to get the password

The username is: `admin`
```
# Unless password is changed then use that instead.
$ kubectl get secret -n argo-cd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# port forward so I can access it from local machine
$ kubectl port-forward -n argo-cd svc/argo-cd-argocd-server 8080:443
```

Open a browser and access http://localhost:8080


## Custom Resource Definitions
The chart also install CRDs on first install, but does not handle any upgrades.

Refer to the following doc for more info: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/README.md#custom-resource-definitions
