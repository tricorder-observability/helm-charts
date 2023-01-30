# API Server with UI

* `service.yaml` Defines the service for connecting to the API server's backend server, and the management UI (backed by Nginx reverse proxy)
* `serviceaccount.yaml` Defines service accounts for API Sever's metadata service sub-component to access Kubernetes API server's updates of
  Kubernetes objects.
* `statefulset.yaml` Defines pods for API Server and management Web UI (nginx reverse proxy)
