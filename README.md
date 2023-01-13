# Starship Helm charts

This repository contains Helm charts to help with the deployment of tricorder on Kubernetes. This project is currently in active development.

## Prerequisites
- Kubernetes 1.16+ [get started](https://kubernetes.io/docs/setup/)
- Helm 3+ [installation](https://helm.sh/docs/intro/install/)

### EKS
- For AWS EKS, isntall [EBS CSI](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) on your EKS cluster.
  This is required because Helm chats will creates DB pods using a Kubernetes
  [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), and in the process,
  we need to create [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  to store the database's data file. PersistentVolume requires EBS CSI.

## Install

```bash
helm repo add tricorder-stable https://tricorder-observability.github.io/helm-charts
helm repo update

# Change namespace to your own, here we use tricorder as an example
kubectl create namespace tricorder
helm install my-tricorder tricorder-stable/tricorder -n tricorder
```

The Helm charts in this repo come with an [Opentelemetry Demo](https://github.com/open-telemetry/opentelemetry-demo).
By default, it's not installed. Set `opentelemetry-demo.enabled=true` to install it

```bash
helm install my-tricorder tricorder-stable/tricorder -n tricorder --set opentelemetry-demo.enabled=true
```

To enable external access to Starship's Web UI, override `starship.service.type`
to [`LoadBalancer`](https://kubernetes.io/docs/concepts/services-networking/service/):

```bash
helm install my-tricorder tricorder-stable/tricorder -n tricorder --set starship.service.type=LoadBalancer --set kube-prometheus-stack.grafana.service.type=LoadBalancer
```

If you already installed Starship, you can modify the service type with `helm upgrade`:
```
helm upgrade my-tricorder tricorder-stable/tricorder -n tricorder --set starship.service.type=LoadBalancer --set kube-prometheus-stack.grafana.service.type=LoadBalancer
```

On AWS EKS, you need to install [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
in order to use LoadBalancer service.

TODO: Add instructions for other public Clouds.

## Uninstall
Due to some quirkiness with Helm, if you wish to uninstall tobs you will need to follow these steps.

[Uninstall and Cleanup](./docs/uninstall.md)
