# Agent

* `daemonset.yaml` Defines agent daemonset, which runs on each and every Kubernetes node. They run eBPF+WASM data collection modules.
  And collect Kubernetes process and container information, and writes to API Server for serialization.
