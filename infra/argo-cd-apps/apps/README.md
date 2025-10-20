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
