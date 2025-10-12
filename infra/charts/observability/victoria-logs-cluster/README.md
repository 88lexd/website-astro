# VictoriaLogs Cluster - Chart
Argo CD is used for installing this chart.

This directory only contains the `values.yaml` required to be passed into the chart.

## Initial Setup
For fast feedback loop, the initial setup is performed locally by using the following:
```shell
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update

# Confirm chart and get latest version
$ helm search repo vm/victoria-logs-cluster --versions | head -n3
NAME                            CHART VERSION   APP VERSION     DESCRIPTION
vm/victoria-logs-cluster        0.0.13          v1.35.0         The VictoriaLogs cluster Helm chart deploys Vic...
vm/victoria-logs-cluster        0.0.12          v1.34.0         The VictoriaLogs cluster Helm chart deploys Vic...

# Confirm Values - can also ref: https://docs.victoriametrics.com/helm/victoria-logs-cluster/
helm show values vm/victoria-logs-cluster --version 0.0.13

# Install Chart
helm upgrade --install vlc vm/victoria-logs-cluster \
  --version 0.0.13 \
  --values values.yaml \
  --namespace monitoring \
  --create-namespace
```

## Argo CD Application
The Argo CD Application for `victoria-logs` is located in `infra/argo-cd-apps/core/victoria-logs.yaml`.

All future management of VictoriaLogs will be managed through Argo CD.


## Delete Helm Secret
Once ArgoCD is in sync and to ensure no accidental future changes are made using Helm from local, the release secret is deleted.
```shell
# Delete all related versions as required
kubectl delete secret -n monitoring sh.helm.release.v1.vlc.v1
```

# Useful Queries
As logs are ingested into Victoria Logs from Otel Collector. The following are some common query I've been using.

```shell
# Check which namespace is generating the most logs
* | stats by (k8s.namespace.name) count() as log_count | sort(log_count) desc | limit 20
```