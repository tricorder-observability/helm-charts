# Starship

Starship's helm charts

Dependent external charts

* `timescaledb-single` Single node deployment of timescaleDB.
* `promscale` Timescale's prom & OTel connector, to enable ingesting and querying Prom & OTel data with the corresponding 
  ingestion, transport, and query protocols.
* `kube-prometheus-stack` Prom collector, which defines how Prom collector connects to PromScale. This defines Prom collector.
