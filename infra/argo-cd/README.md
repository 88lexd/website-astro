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
# Install CLI
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

# Argo CD Image Updater
A tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD.

When I release a new container image, I want Argo CD to automatically get my Application to use the latest.

## Install
```shell
# As of December 2024 when installed this, v0.15.1 is the latest.
# Reason I choose to use the version tag instead of `stable` is so I can easily uninstall using the same manifest.
kubectl apply -n argo-cd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/v0.15.1/manifests/install.yaml

# Install `argocd-image-updater` binary on my machine
wget https://github.com/argoproj-labs/argocd-image-updater/releases/download/v0.15.1/argocd-image-updater-linux_amd64
sudo mv argocd-image-updater-linux_amd64 /usr/local/bin/argocd-image-updater
sudo chmod +x /usr/local/bin/argocd-image-updater

# Test run
argocd-image-updater test 88lexd/website-astro
DEBU[0000] Creating in-cluster Kubernetes client
INFO[0000] retrieving information about image            image_alias= image_name=88lexd/website-astro registry_url=
INFO[0000] Fetching available tags and metadata from registry  application=test image_alias= image_name=88lexd/website-astro registry_url=
INFO[0002] Found 1 tags in registry                      application=test image_alias= image_name=88lexd/website-astro registry_url=
DEBU[0002] found 1 from 1 tags eligible for consideration  image=88lexd/website-astro
INFO[0002] latest image according to constraint is 88lexd/website-astro:v1.0.0  application=test image_alias= image_name=88lexd/website-astro registry_url=
```

# Custom Resource Definitions
The chart also install CRDs on first install, but does not handle any upgrades.

Refer to the following doc for more info: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/README.md#custom-resource-definitions
