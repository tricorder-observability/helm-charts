# Starship Helm charts

This repository contains Helm charts to help with the deployment of tricorder on Kubernetes. This project is currently in active development.

## Prerequisites
- Kubernetes 1.16+
- Helm 3+, Helm must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.
- Helm chats will creates DB pods using a Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/). For AWS EKS, The official [EBS CSI](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) documentation may be helpful to you.

## Install

Once Helm is set up properly, add the repo as follows:

```bash
helm repo add tricorder-stable https://tricorder-observability.github.io/helm-charts

helm repo update
```

### Install without OpenTelemetry Demo App

When you execute the command, the [Opentelemetry Demo](https://github.com/open-telemetry/opentelemetry-demo) will not be installed.

```bash
kubectl create namespace <your-namespace>

helm install my-tricorder tricorder-stable/tricorder -n <your-namespace>
```

### Install with OpenTelemetry Demo App
If you want to install OpenTelemetry demo data, you can enalbe it with the following command:

```bash
kubectl create namespace <your-namespace>

helm install my-tricorder tricorder-stable/tricorder -n <your-namespace> --set opentelemetry-demo.enabled=true
```

### Override settigns

Override `starship.service.type` to [`LoadBalancer`](https://kubernetes.io/docs/concepts/services-networking/service/) to access tricorder by external IPs:

```bash
kubectl create namespace <your-namespace>

helm install my-tricorder tricorder-stable/tricorder -n <your-namespace> --set starship.service.type=LoadBalancer --set kube-prometheus-stack.grafana.service.type=LoadBalancer
```

You can also update the service type by `helm upgrade`:
```
helm install my-tricorder tricorder-stable/tricorder -n tricorder --set starship.service.type=LoadBalancer --set kube-prometheus-stack.grafana.service.type=LoadBalancer
```

On AWS EKS, you need to install the official [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) in order to use LoadBalancer service.

TODO: Add instructions for other public Clouds.


## Uninstall
Due to some quirkiness with Helm, if you wish to uninstall tobs you will need to follow these steps.

[Uninstall and Cleanup](./docs/uninstall.md)

## Sub-charts
- [tricorder-starship](./charts/tricorder/charts/starship/README.md)
