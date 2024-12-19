# Argo CD Helm Chart
Use this to install Argo CD for automated deployments.

## Installing Argo CD
Create Namespace (if I ever rebuild K8s)
```
$ kubectl create ns argo-cd
```

Install/Upgrade Chart
```shell
$ cd ./infra/argo-cd-chart

$ helm repo add argo-cd https://argoproj.github.io/argo-helm
$ helm dep update .

# Install
$ helm upgrade --install argo-cd --namespace argo-cd .
```

**Note:** In addition to Argo CD, I am also installing an ingress resource so I can access it from the network.

## Install and Setup Argo CLI
The following is required on my local machine to access Argo CD via CLI.
```shell
# Install
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Get the initial password
argocd admin initial-password -n argo-cd

# Login and change password
argocd account update-password
# >Enter current password
# >Enter new password

# Login with new password (self-signed TLS, ignore WARNING with extra flag)
argocd login argo.lexdsolutions.com --grpc-web
```

Delete the secret containing the initial setup password
```shell
kubectl delete secrets -n argo-cd argocd-initial-admin-secret
```

## Add Git Repository into Argo CD
Add the repository into Argo CD so it can read and perform git write-back via Image Updater.

```shell
argocd repo add git@github.com:88lexd/website-astro.git --ssh-private-key-path ~/.ssh/argo-cd
```

## Accessing Argo CD
I have 2 options for Argo CD
- Open a browser and access https://argo.lexdsolutions.com
- Use CLI
  ```shell
  # Login in cached, shouldn't need to login everytime
  argocd login argo.lexdsolutions.com --grpc-web

  argocd app list

  argo --help
  ```

## Custom Resource Definitions
The chart also install CRDs on first install, but does not handle any upgrades.

Refer to the following doc for more info: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/README.md#custom-resource-definitions
