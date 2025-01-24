# Website - Astro - Chart
This chart creates the resources on Kubernetes to host this blog site.

## Manual dev deployment
During local development, the `dev` namespace will be used and a different DNS record is used for ingress.

```shell
cd /home/alex/code/git/website-astro/infra/website-chart

helm upgrade website-astro \
  --install \
  --namespace dev \
  --set ingress.host=dev.lexdsolutions.com  \
  .

curl -s -H "Host: dev.lexdsolutions.com" http://<node-ip>/health-check | jq
```

TODO: To access this page from a browser, modify the `Hostfile` for create a public DNS that points to local IP