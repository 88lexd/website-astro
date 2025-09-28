# Ingress Nginx
Argo CD is used for installing this chart.

This directory only contains the `values.yaml` required to be passed into the chart.

## Initial Install
For fast feedback during the initial install, running helm install from local is used to validate the values being passed into the chart.

```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Show chart versions
helm search repo ingress-nginx/ingress-nginx --versions | head -n5

INGRESS_NGINX_CHART_VERSION="4.13.2"

# Show available values
helm show values ingress-nginx/ingress-nginx --version ${INGRESS_NGINX_CHART_VERSION}

helm upgrade --install ingress-nginx --namespace ingress-nginx --values values.yaml ingress-nginx/ingress-nginx --version ${INGRESS_NGINX_CHART_VERSION}
```

## Argo CD Application
The Argo CD Application for `ingress-nginx` is located in `infra/argo-cd-apps/core/ingress-nginx.yaml`

## Delete Helm Secret
Once ArgoCD is in sync and to ensure no accidental future changes are made using Helm from local, the release secret is deleted.
```shell
kubectl delete secret -n ingress-nginx sh.helm.release.v1.ingress-nginx.v1
```

# Hard Cleanup
Since this chart is no longer managed by Helm and if there is a major issue with Argo, the following can be used as a hard clean up

**Note** Chart version must match the one defined in Argo

Example here uses --dry-run
```
$ helm template ingress-nginx --namespace ingress-nginx --values values.yaml ingress-nginx/ingress-nginx --version ${INGRESS_NGINX_CHART_VERSION} | kubectl delete -f - --dry-run=client
serviceaccount "ingress-nginx" deleted from ingress-nginx namespace (dry run)
configmap "ingress-nginx-controller" deleted from ingress-nginx namespace (dry run)
clusterrole.rbac.authorization.k8s.io "ingress-nginx" deleted (dry run)
clusterrolebinding.rbac.authorization.k8s.io "ingress-nginx" deleted (dry run)
role.rbac.authorization.k8s.io "ingress-nginx" deleted from ingress-nginx namespace (dry run)
rolebinding.rbac.authorization.k8s.io "ingress-nginx" deleted from ingress-nginx namespace (dry run)
service "ingress-nginx-controller-metrics" deleted from ingress-nginx namespace (dry run)
service "ingress-nginx-controller-admission" deleted from ingress-nginx namespace (dry run)
service "ingress-nginx-controller" deleted from ingress-nginx namespace (dry run)
deployment.apps "ingress-nginx-controller" deleted from ingress-nginx namespace (dry run)
ingressclass.networking.k8s.io "nginx" deleted (dry run)
validatingwebhookconfiguration.admissionregistration.k8s.io "ingress-nginx-admission" deleted (dry run)
serviceaccount "ingress-nginx-admission" deleted from ingress-nginx namespace (dry run)
clusterrole.rbac.authorization.k8s.io "ingress-nginx-admission" deleted (dry run)
clusterrolebinding.rbac.authorization.k8s.io "ingress-nginx-admission" deleted (dry run)
role.rbac.authorization.k8s.io "ingress-nginx-admission" deleted from ingress-nginx namespace (dry run)
rolebinding.rbac.authorization.k8s.io "ingress-nginx-admission" deleted from ingress-nginx namespace (dry run)
job.batch "ingress-nginx-admission-create" deleted from ingress-nginx namespace (dry run)
job.batch "ingress-nginx-admission-patch" deleted from ingress-nginx namespace (dry run)
```
