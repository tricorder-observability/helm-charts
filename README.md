# tricorder observability Helm charts

Helm Charts for tricorder observability.

## Usage

Helm must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```bash
helm repo add tricorder https://tricorder-observability.github.io/helm-charts

helm upgrade --install --create-namespace --cleanup-on-fail -n tricorder my-tricorder tricorder
```

## Sub-charts
- [tricorder-demo](./charts/tricorder-demo/README.md)
