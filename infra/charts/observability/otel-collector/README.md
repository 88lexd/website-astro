# OpenTelemetry Collector - Helm Chart
This Helm chart deploys the OTel Collector Operator and the OTel Collector Custom Resource for monitoring of my cluster.

## Initial Setup
For fast feedback loop, the initial setup is performed locally by using the following:
```shell
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

# Show chart versions
$ helm search repo open-telemetry/opentelemetry-operator --versions | head -n5
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION
open-telemetry/opentelemetry-operator   0.97.1          0.136.0         OpenTelemetry Operator Helm chart for Kubernetes
...

# Note: App Version is the actual Operator version.
CHART_VERSION="0.97.1"

helm show values open-telemetry/opentelemetry-operator --version ${CHART_VERSION}

helm install otel . \
  --values values.yaml \
  --namespace monitoring \
  --create-namespace \
  --dependency-update
```

## Argo CD Application
The Argo CD Application for `otel-collector` is located in `infra/argo-cd-apps/observability/otel-collector.yaml`

## Delete Helm Secret
Once ArgoCD is in sync and to ensure no accidental future changes are made using Helm from local, the release secret is deleted.
```shell
kubectl delete secret -n monitoring sh.helm.release.v1.otel.v1
```
