
## Uninstall/Cleanup

Due to some quirkiness with Helm, if you wish to uninstall tobs you will need to follow these steps.

To uninstall a release you can run:

```bash
helm uninstall my-tricorder -n <your-namespace>
```

After uninstalling helm release some objects will be left over. To remove them follow next sections.

### Cleanup secrets
secret's created with the deployment aren't deleted. These secrets need to be manually deleted:
```bash
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get secrets -n $NAMESPACE -l "app=timescaledb" -o name)
```

### Cleanup configmap
```bash
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get configmap -n $NAMESPACE -l "app=$RELEASE-promscale" -o name)
```

### Cleanup Kube-Prometheus secret
One of the Kube-Prometheus secrets created with the deployment isn't deleted. This secret needs to be manually deleted:
```bash
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete secret -n $NAMESPACE $RELEASE-kube-prometheus-stack-admission
```

### Cleanup DB PVCs and Backup
Removing the deployment does not remove the Persistent Volume Claims (pvc) belonging to the release. For a full cleanup run:

```bash
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get pvc -n $NAMESPACE -l release=$RELEASE -o name)
```

### Prometheus PVCs
Removing the deployment does not remove the Persistent Volume Claims (pvc) of Prometheus belonging to the release. For a full cleanup run:
```bash
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get pvc -n $NAMESPACE -l operator.prometheus.io/name=$RELEASE-kube-prometheus-stack-prometheus -o name)
```

### Prometheus CRDs, ValidatingWebhookConfiguration and MutatingWebhookConfiguration

```bash
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com alertmanagers.monitoring.coreos.com probes.monitoring.coreos.com prometheuses.monitoring.coreos.com prometheusrules.monitoring.coreos.com servicemonitors.monitoring.coreos.com thanosrulers.monitoring.coreos.com podmonitors.monitoring.coreos.com
```

```bash
RELEASE=<release_name>
kubectl delete MutatingWebhookConfiguration $RELEASE-kube-promethe-admission

kubectl delete ValidatingWebhookConfiguration $RELEASE-kube-prometheus-admission
```

### Delete Namespace
Since it was recommended for you to install tobs into its own specific namespace you can go ahead and remove that as well.
```bash
NAMESPACE=<namespace>
kubectl delete ns $NAMESPACE
```
