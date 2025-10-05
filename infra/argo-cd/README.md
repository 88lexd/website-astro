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

# Note: To find what values are available
$ helm show values argo-cd/argo-cd --version "8.5.6"

$ helm upgrade --install argocd --namespace argocd --create-namespace --values argocd-values.yaml argo-cd/argo-cd --version "8.5.6"
```

## Install and Setup Argo CLI
The following is required on my local machine to access Argo CD via CLI.
```shell
# Install CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Get the initial password
argocd admin initial-password -n argocd

################################################
# Prior to Ingress - Using port forward to login
$ argocd login --port-forward --port-forward-namespace argocd --plaintext
Username: admin
Password: '<enter-password-from-above>'

# Login and change password
argocd account update-password --port-forward --port-forward-namespace argocd
# >Enter current password
# >Enter new password
```

Delete the secret containing the initial setup password
```shell
kubectl delete secrets -n argocd argocd-initial-admin-secret
```

Access Argo from Host via Port Forwarding in WSL
```shell
make port-forward-argo
```

## Install Self-Managed Argo App
The following Argo Application will allow Argo to manage itself.
```shell
kubectl apply-f app-argocd.yaml
```

To manage Argo CD, simply update the `app-argocd.yaml` Application to define the new chart version and/or update the `argocd-values.yaml` with new configurations.

## Delete Helm Secret
Argo does not do a Helm release deployment. It performs `helm template` and manages the manifests directly.

Once confirm Argo sync is working, delete the Helm secret that controls the Helm release and prevent accidental management using Helm directly from local.
