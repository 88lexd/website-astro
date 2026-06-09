# kgateway Chart
Argo CD is used for installing this chart.

This directory only contains the `values.yaml` required to be passed into the chart.

## Argo CD Application
The Argo CD Application for `kgateway` is located in `infra/argo-cd-apps/core/kgateway.yaml`

## Upgrading kgateway
The following steps were taken to upgrade kgateway. Ref for supported versions: https://kgateway.dev/docs/envoy/latest/reference/versions/

**REMINDER:** There are 4 components in kgateway:
1. The [Gateway API CRD](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/gateway-api-crds.yaml)
2. The [kgateway CRD](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/kgateway-crds.yaml)
3. The [kgateway Operator](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/kgateway.yaml)
4. The [Gateway resource](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/kgateway-proxy.yaml) (aka dataplane)

The following command is used to check the curent Gateway API CRD version
```shell
$ k get crd gateways.gateway.networking.k8s.io -o yaml | yq '.metadata.annotations.["gateway.networking.k8s.io/bundle-version"]'
v1.4.0
```

Here I am upgrading kgateway from `2.2.1` to `2.3.1` and the target version supports Gateway API `1.3 - 1.5` as per the supported versions doc by kgateway.

To know what kgateway version is available, check the [kgateway GitHub tags](https://github.com/kgateway-dev/kgateway/tags)

The following process is followed (WARNING: upgrade 1 minor version at a time to ensure backwards compatibility):

1. Ensure K8s cluster version is within the supported version (otherwise upgrade the cluster first)

2. Upgrade [kgateway-crds](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/kgateway-crds.yaml) - kgateway-crds should be backwards compatible and kgateway operator should continue to work as normal.

3. Upgrade [kgateway](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/kgateway.yaml) - Upgrade to match the same version as the kgateway CRD

3. Once kgateway is upgraded; then upgrade [Gateway API CRD](https://github.com/88lexd/website-astro/blob/main/infra/argo-cd-apps/core/gateway-api-crds.yaml) - Patch version is OK, but ensure it is supported by kgateway. See [releases](https://github.com/kubernetes-sigs/gateway-api/tags)

Since ListenerSets are new in Gateway API v1.5.x, we can implement this resource to validate that it is working as expected.
