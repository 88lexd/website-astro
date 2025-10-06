# Custom Cert Manager - Helm Chart
This Helm Chart installs cert-manager as a dependency and deploys the ClusterIssuer upon install.

## Initial Setup
For fast feedback loop, the initial setup is performed locally by using the following:
```shell
# Took 2 tries.. webhook wasn't up fast enough
helm upgrade --install cert-manager . \
  --values values.yaml \
  --namespace cert-manager \
  --create-namespace \
  --dependency-update
```

## Upgrade Notes
CRDs are installed as part of the Helm template. Be very careful during upgrading/removing cert-manager

Refer to: https://cert-manager.io/docs/installation/upgrade/ to ensure a safe upgrade.

## Argo CD Application
The Argo CD Application for `cert-manager` is located in `infra/argo-cd-apps/core/cert-manager.yaml`.

All future management of cert-manager will be managed through Argo CD.

## Delete Helm Secret
Once ArgoCD is in sync and to ensure no accidental future changes are made using Helm from local, the release secret is deleted.
```shell
# Delete all related versions as required
kubectl delete secret -n cert-manager sh.helm.release.v1.cert-manager.v{1..2}
```
