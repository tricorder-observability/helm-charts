# Tricorder Database Initialization

* `post-init-configmap.yaml` Create Kuternetes ConfigMap that stores the content of scripts for initializing
  Timescale DB (aka Postgres + Timescale extensions).
* `timescaledb-extensions.yaml` Create TimescaleDB extensions for Porm and OTel
