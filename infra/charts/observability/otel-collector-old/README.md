# OpenTelemetry Collector - Helm Chart
This Helm chart deploys the OTel Collector Custom Resource for monitoring my cluster.

This chart expects the OTel Operator to be already installed along with the CRDs. The Operator is managed through ArgoCD under `infra/argo-cd-apps/observability/otel-operator.yaml`

## Initial Setup
For fast feedback loop, the initial setup is performed locally by using the following:
```shell
helm upgrade --install otel . \
  --values values.yaml \
  --namespace monitoring \
  --create-namespace
```

## Argo CD Application
The Argo CD Application for `otel-collector` is located in `infra/argo-cd-apps/observability/otel-collector.yaml`

## Delete Helm Secret
Once ArgoCD is in sync and to ensure no accidental future changes are made using Helm from local, the release secret is deleted.
```shell
kubectl delete secret -n monitoring sh.helm.release.v1.otel.v1
```
