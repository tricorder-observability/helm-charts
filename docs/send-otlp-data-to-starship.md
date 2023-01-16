# Send OpenTelemetry data to Starship

Starship use [Promscale](https://docs.timescale.com/promscale/latest/about-promscale/) as observability backend to receive Prometheus metrics and OpenTelemetry traces.

So, Starship natively supports the OpenTelemetry Line Protocol (OTLP) for traces and Prometheus remote write protocol for metrics. You can send traces to Starship using OTLP with any of the OpenTelemetry client SDKs, instrumentation libraries, or the OpenTelemetry Collector. [more details](https://docs.timescale.com/promscale/latest/send-data/opentelemetry/)

If your app doesn't currently use OpenTelemetry, you can quickly preview the effect by installing the [OpenTelemetry demo](https://github.com/open-telemetry/opentelemetry-demo) through [OpenTelemetry Demo Helm Chart](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-demo)

## Installing the OpenTelemetry Demo Chart

Before the demo installation, we need to make sure our starship components and relative `kubernetes service` are ready, you check by following command:

e.g. To check our starship promescale service in `tricorder` namespace:

```bash
$ kubectl get service -n tricorder | grep promscale
my-tricorder-promscale                  ClusterIP   10.100.69.104    <none>   9201:32401/TCP,9202:31864/TCP                 3h56m
```

So, `my-tricorder-promscale.tricorder.svc.cluster.local:9202` is the endpoint of Promescale.

```bash
export STARSHIP_PROMESCALE_ENDPOINT="my-tricorder-promscale.tricorder.svc.cluster.local:9202"
```

Create patch yaml file for custom otel col config:

```shell
cat > otel_demo_col_patch.yaml << EOF
opentelemetry-collector:
  config:
    receivers:
      otlp:
        protocols:
          grpc:
          http:
            cors:
              allowed_origins:
                - "http://*"
                - "https://*"

    exporters:
      otlp:
        endpoint: $STARSHIP_PROMESCALE_ENDPOINT
        tls:
          insecure: true
      prometheus:
        endpoint: '0.0.0.0:9464'

    processors:
      spanmetrics:
        metrics_exporter: prometheus

    service:
      pipelines:
        traces:
          processors: [memory_limiter, spanmetrics, batch]
          exporters: [otlp, logging]
        metrics:
          exporters: [prometheus, logging]
EOF
```

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Create an kubernetes namespace for OpenTelemetry Demo installation:

```bash
kubectl create ns webstore-demo
```

To install the chart with the release name `my-otel-demo`, run the following command:

**WARNING:** Since StarHip Helm Chart already has Prometheus/Grafana installed and uses TimeScaleDB to store trace data, you can disable the relevant components during the demo installation:

```bash
helm install my-otel-demo open-telemetry/opentelemetry-demo -n webstore-demo \
--set observability.jaeger.enabled=false --set observability.prometheus.enabled=false --set observability.grafana.enabled=false \
--values otel_demo_col_patch.yaml
```

Last, check your OTEL demo pods:

```bash
$ kubectl -n webstore-demo get pods
NAME                                                  READY   STATUS    RESTARTS       AGE
my-otel-demo-accountingservice-7dd759467b-q26vp       1/1     Running   2 (134m ago)   134m
······
my-otel-demo-shippingservice-595b8985b7-46d7l         1/1     Running   0              134m
```

If all pods are runnning, you can access the startship Grafana UI to view the OTEL data.






