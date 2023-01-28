# Kubenetes Prometheus Stack

* `connection-secret-job.yaml` Store credentials into K8s secret, for PromScale to connect to TimescaleDB.
* `grafana-dashboards-conf.yaml` Stores configurations of the pre-built dashboards.
* `grafana-datasources-sec.yaml` Stores configurations of prom, otel, and timescale time-series database query endpoints and credentials.
