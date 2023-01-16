# Send OpenTelemetry data to Starship

You can send traces to Starship using OTLP with any of the OpenTelemetry client SDKs, instrumentation libraries, or the OpenTelemetry Collector.

You can quickly preview the effect by installing the [OpenTelemetry demo](https://github.com/open-telemetry/opentelemetry-demo) through [OpenTelemetry Demo Helm Chart](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-demo)

## Installing the OpenTelemetry Demo Chart

Before the demo installation, we need to make sure our starship components and relative `kubernetes service` are ready, you check by following command:

e.g. To check our starship promescale service in `tricorder` namespace:

```shell
$ kubectl get service -n tricorder | grep promscale
my-tricorder-promscale                  ClusterIP   10.100.69.104    <none>   9201:32401/TCP,9202:31864/TCP                 3h56m
```

So, `my-tricorder-promscale.tricorder.svc.cluster.local:9202` is the endpoint of Promescale.

```shell
export STARSHIP_PROMESCALE_ENDPOINT="my-tricorder-promscale.tricorder.svc.cluster.local:9202"
```

Create patch yaml file for custom opentelemetry collector config:

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

```shell
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Create an kubernetes namespace for OpenTelemetry Demo installation:

```shell
kubectl create ns otel-demo
```

To install the chart with the release name `my-otel-demo`, run the following command:

**WARNING:** Since StarShip Helm Chart already has Prometheus/Grafana installed and uses TimeScaleDB to store trace data, you can disable duplicate components in installation:

```shell
helm install my-otel-demo open-telemetry/opentelemetry-demo -n otel-demo \
--set observability.jaeger.enabled=false --set observability.prometheus.enabled=false --set observability.grafana.enabled=false \
--values otel_demo_col_patch.yaml
```

Last, check your opentelemetry demo pods:

```shell
$ kubectl -n webstore-demo get pods
NAME                                                  READY   STATUS    RESTARTS       AGE
my-otel-demo-accountingservice-7dd759467b-q26vp       1/1     Running   2 (134m ago)   134m
······
my-otel-demo-shippingservice-595b8985b7-46d7l         1/1     Running   0              134m
```

## Access the Starship managenment UI by expose services using kubectl port-forward

If all pods are runnning, you can access the startship managenment UI which has a link to Grafana UI to view the opentelemetry demo data.

e.g. Check our `startship managenment UI` in `tricorder` namespace:

```shell
$ kubectl get service -n tricorder | grep tricorder-api-server
my-tricorder-tricorder-api-server       ClusterIP   10.100.110.131   <none>    50051:32658/TCP,8080:30652/TCP,80:30961/TCP   5h18m
```

To expose the Starship managenment UI service use the following command (replace `my-tricorder-api-server` and `-n tricorder` with your Helm chart release name accordingly):

```shell
$ kubectl -n tricorder port-forward service/my-tricorder-api-server 18080:80
```

With the Starship managenment UI set up, you can access:

Starship managenment UI: http://localhost:18080/