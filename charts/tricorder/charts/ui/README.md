# tricorder UI Helm Chart

```bash
helm repo add tricorder https://tricorder-observability.github.io/helm-charts

helm upgrade --install --create-namespace --cleanup-on-fail -n tricorder my-tricorder tricorder/ui
```
