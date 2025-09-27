# Argo CD Apps
This is the App of Apps directory.

The `root-app.yaml` creates an Application to applies all manifests within this directory.

Argo CD can search sub directories, so apps or appsets can also be installed automatically the next time new Application manifests are created here.

## Chicken and Egg Problem
The root app cannot manage itself unless we first install it manually once.

**IMPORTANT:** Only perform this ONCE the code has been merged into main.
```
kubectl apply -f root-app.yaml
```

## Moving Forward
Once the root-app is installed and is monitoring the default branch, all needs to be done is add the manifests into this directory and ArgoCD will automatically pick them up.

Note: When the following is used, it searches for sub-directories for manifests
```yaml
- name: root-app
  repoURL: https://github.com/88lexd/website-astro
  targetRevision: HEAD
  path: infra/argo-cd-apps # Here it searches and applies manifests from all sub-dirs
```
