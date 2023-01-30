# Agent

* `daemonset.yaml` Defines agent daemonset, which runs on each and every Kubernetes node. They run eBPF+WASM data collection modules.
  And collect Kubernetes process and container information, and writes to API Server for serialization.

TODO: Consider include [PGBouncer](https://github.com/pgbouncer/pgbouncer) to have connection pool to support large kubernetes cluster.
Because agents right now connects to PG directly for writing data collected by the eBPF+WASM data collection modules.
