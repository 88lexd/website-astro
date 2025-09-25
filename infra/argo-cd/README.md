# Argo CD Helm Chart
Use this to install Argo CD for automated deployments.

## Installing Argo CD
Create namespace
```shell
kubectl create namespace argocd
```

Setup secret for email notification
```shell
EMAIL_USER=xxx@smtp-brevo.com
PASSWORD=password

# This secret is being referenced by Argo for sending email notification
kubectl apply -n argocd -f - << EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-notifications-secret
stringData:
  email-username: $EMAIL_USER
  email-password: $PASSWORD
type: Opaque
EOF
```

Initial install
```shell
$ cd ./infra/argo-cd

$ helm repo add argo-cd https://argoproj.github.io/argo-helm
$ helm repo update
$ helm dep update .

$ helm upgrade --install argocd --namespace argocd --create-namespace .
```
**Note:** In addition to Argo CD, I am also installing an ingress resource so I can access it from the network.

### Applications into Argo CD
This chart also contains the `Application` definitions for Argo Apps.

Argo will monitor this directory on the `main` branch and will self manage itself. This includes the following:
- Changes to `Chart.yaml` where Argo is installed, if changed then Argo CD will perform a self upgrade
- Changes to `templates` directory, Argo will auto install any changes


## Install and Setup Argo CLI
The following is required on my local machine to access Argo CD via CLI.
```shell
# Install CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Get the initial password
argocd admin initial-password -n argocd

#########################################
# Prior to Ingress - Using port forward
kubectl port-forward -n argocd services/argocd-server 8080:80
argocd login argo.lexdsolutions.com

# Login with new password (self-signed TLS, ignore WARNING with extra flag)


argocd login argo.lexdsolutions.com --grpc-web
#########################################
  # Note: A re-install of Argo caused me some issue, had to delete thils containing old data
  rm -f ~/.config/argo/config

# Login and change password
argocd account update-password
# >Enter current password
# >Enter new password
```

Delete the secret containing the initial setup password
```shell
kubectl delete secrets -n argocd argocd-initial-admin-secret
```

## Add Git Repository into Argo CD
Add the repository into Argo CD so it can read and perform git write-back via Image Updater.

```shell
argocd repo add git@github.com:88lexd/website-astro.git --project default --ssh-private-key-path ~/.ssh/argo-cd
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
Install Image Updater
```shell
# As of December 2024 when installed this, v0.15.1 is the latest.
# Reason I choose to use the version tag instead of `stable` is so I can easily uninstall using the same manifest.

# VERY IMPORTANT: The chart references `argocd` as the namespace! I have re-deployed argo-cd to keep it the same
# Otherwise I must manually modify the manifest before applying.
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/v0.15.1/manifests/install.yaml
```

Setup SSH key for Argo CD Image Updater to use
```shell
cd ~/.ssh

kubectl -n argocd create secret generic git-cred-website-astro \
  --from-file=sshPrivateKey=argo-cd
```

Install CLI
```shell
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
The chart also install CRDs on first install, but does not handle any upgrades (only applies to chart versions prior to 5.2.0, CRDs are now part of the templates directory in the chart).

Refer to the following doc for more info: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/README.md#custom-resource-definitions
