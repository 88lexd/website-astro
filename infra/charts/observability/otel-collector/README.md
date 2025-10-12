# OpenTelemetry Kube Stack Helm Chart
Argo CD is used for installing this chart. This directory only contains the `values.yaml` required to be passed into the chart.

This uses the official [opentelemetry-kube-stack](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-kube-stack) chart to deploy OTel Collector.

## Initial Setup
For fast feedback loop, the initial setup is performed locally by using the following:
```shell
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

# Check kube-stack Chart
$ helm search repo open-telemetry/opentelemetry-kube-stack --versions | head -n5
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION
open-telemetry/opentelemetry-kube-stack 0.11.0          0.129.1         OpenTelemetry Quickstart chart for Kubernetes. ...
open-telemetry/opentelemetry-kube-stack 0.10.5          0.129.1         OpenTelemetry Quickstart chart for Kubernetes. ...
...

helm upgrade --install otel open-telemetry/opentelemetry-kube-stack --version "0.11.0" \
  --values values.yaml \
  --namespace monitoring \
  --create-namespace
```

## Argo CD Application
The Argo CD Application for `otel-collector` is located in `infra/argo-cd-apps/observability/otel.yaml`


## Retaining Helm Release for Rapid Local Development
For fast development feedback, the Helm release/secret will be retained so I can continue using Helm to test and deploy from locally.

Once changes are validated, they will be merged into the `main` branch and ArgoCD will ensure the cluster is in Sync.

**Note:** The Argo App does not have self-healing enabled, so the sync is manual and it will not revert changes made locally using Helm.
```shell
# WARNING: If VERSION is changed, make sure it is also reflected in `/infra/argo-cd-apps/observability/otel.yaml`
CHART_VERSION="0.11.0"

# Make changes to values.yaml and run
helm upgrade --install otel open-telemetry/opentelemetry-kube-stack --version "${CHART_VERSION}" \
  --values values.yaml \
  --namespace monitoring
```
