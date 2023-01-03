# tricorder observability Helm charts

Helm Charts for tricorder observability.

## Usage

Helm must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```bash
helm repo add tricorder-stable https://tricorder-observability.github.io/helm-charts

helm repo update

kubectl create namespace <your-namespace>

helm install my-tricorder tricorder-stable/tricorder -n <your-namespace>
```

## Upgrade

e.g. upgrade with LoadBalancer settings.

```bash
helm upgrade --install --create-namespace --cleanup-on-fail -n tricorder my-tricorder tricorder --set starship.service.type=LoadBalancer
```

## Sub-charts
- [tricorder-starship](./charts/tricorder/charts/starship/README.md)
