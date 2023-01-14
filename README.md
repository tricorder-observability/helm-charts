# Starship Helm charts

This repository contains Helm charts for deploying Starship Observability
platform, developed by [Tricorder Observability](https://tricorder.dev).

{% note %}
**Note:** This project is currently in active development. Consider everything
as technical preview only.
{% endnote %}

## Prerequisites
- Kubernetes 1.16+ [get started](https://kubernetes.io/docs/setup/)
- Helm 3+ [installation](https://helm.sh/docs/intro/install/)

### AWS EKS
- If you are using AWS EKS, isntall
  [EBS CSI](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
  on your EKS cluster.

  This is required because Helm charts create
  [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  for database pods, which requires EBS CSI.
- You also need to install
  [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
  in order to use LoadBalancer service type, which is Starship's default service
  type.

## Install

Change namespace to your own, here we use `tricorder` as an example.

```shell
helm repo add tricorder-stable \
    https://tricorder-observability.github.io/helm-charts
helm repo update
kubectl create namespace tricorder
helm install my-tricorder tricorder-stable/tricorder -n tricorder
```

The Helm charts in this repo come with an
[Opentelemetry Demo](https://github.com/open-telemetry/opentelemetry-demo).
By default, it's not installed. Use `--set opentelemetry-demo.enabled=true`
with `helm install` to install it

```shell
helm install my-tricorder tricorder-stable/tricorder -n tricorder \
    --set opentelemetry-demo.enabled=true
```

As usual, you can override configuration values defined in `Values.yaml`
with `--set` flags.
```shell
# Change service type to ClusterIP
helm upgrade my-tricorder tricorder-stable/tricorder -n tricorder \
    --set service.type=ClusterIP

# Use specified container image tag
helm upgrade my-tricorder tricorder-stable/tricorder -n tricorder \
    --set tag=<a specific tag>
```

TODO: Add instructions for other public Clouds.

## Uninstall

Due to some quirkiness with Helm, if you wish to uninstall tobs you will need to follow these steps.

To uninstall a release you can run:

```shell
helm uninstall my-tricorder -n tricorder
```

After uninstalling helm release some objects will be left over. To remove them follow next sections.

### Cleanup secrets
secret's created with the deployment aren't deleted. These secrets need to be manually deleted:
```shell
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get secrets -n $NAMESPACE -l "app=timescaledb" -o name)
```

### Cleanup configmap
```shell
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get configmap -n $NAMESPACE -l "app=$RELEASE-promscale" -o name)
```

### Cleanup Kube-Prometheus secret
One of the Kube-Prometheus secrets created with the deployment isn't deleted. This secret needs to be manually deleted:
```shell
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete secret -n $NAMESPACE $RELEASE-kube-prometheus-stack-admission
```

### Cleanup DB PVCs and Backup
Removing the deployment does not remove the Persistent Volume Claims (pvc) belonging to the release. For a full cleanup run:

```shell
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get pvc -n $NAMESPACE -l release=$RELEASE -o name)
```

### Prometheus PVCs
Removing the deployment does not remove the Persistent Volume Claims (pvc) of Prometheus belonging to the release. For a full cleanup run:
```shell
RELEASE=<release_name>
NAMESPACE=<namespace>
kubectl delete -n $NAMESPACE $(kubectl get pvc -n $NAMESPACE -l operator.prometheus.io/name=$RELEASE-kube-prometheus-stack-prometheus -o name)
```

### Prometheus CRDs, ValidatingWebhookConfiguration and MutatingWebhookConfiguration

```shell
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com alertmanagers.monitoring.coreos.com probes.monitoring.coreos.com prometheuses.monitoring.coreos.com prometheusrules.monitoring.coreos.com servicemonitors.monitoring.coreos.com thanosrulers.monitoring.coreos.com podmonitors.monitoring.coreos.com
```

```shell
RELEASE=<release_name>
kubectl delete MutatingWebhookConfiguration $RELEASE-kube-promethe-admission

kubectl delete ValidatingWebhookConfiguration $RELEASE-kube-prometheus-admission
```

### Delete Namespace
Since it was recommended for you to install tobs into its own specific namespace you can go ahead and remove that as well.
```shell
NAMESPACE=<namespace>
kubectl delete ns $NAMESPACE
```
