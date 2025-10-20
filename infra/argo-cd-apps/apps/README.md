# General Argo Apps
This directory contains general Apps to be installed through Argo CD.

## Website - Astro
This is the main blog website.

This App uses `argocd-image-updater` which is a tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD.

When I release a new container image, I want Argo CD to automatically get my Application to use the latest image.

### Install and Setup
First of, the Argo CD Image Updater is managed as an [Argo CD app](../../argo-cd-apps/core/argocd-image-updater.yaml)

Follow by configuring the Argo CD repo to enable git write-back via Image Updater
```shell
# Login to Argo
argocd login argocd.home --grpc-web

# Setup repo
argocd repo add git@github.com:88lexd/website-astro.git --project default --ssh-private-key-path ~/.ssh/argo-cd
```

Lastly, to ensure Image Updater can use perform Git Write-back. The following secret needs to be created
```shell
# Create the secret
cd ~/.ssh && kubectl -n argocd create secret generic git-cred-website-astro \
  --from-file=sshPrivateKey=argo-cd
```

Setup `argocd-image-updater` CLI
```shell
# Install `argocd-image-updater` binary on my machine
wget https://github.com/argoproj-labs/argocd-image-updater/releases/download/v0.17.0/argocd-image-updater-linux_amd64
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
