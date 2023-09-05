# k8s_pods

The `k8s_pods` module collects metrics and logs from Kubernetes Pods and
forwards them to a Prometheus-compatible Grafana Agent Flow component.

Kubernetes pods must follow a convention to be discovered; see [Module
arguments](#module-arguments) for specifics.

> **NOTE**: `k8s_pods` must be used with a module loader which can pass
> arguments to loaded modules, such as `module.git`.

## Agent Version

`>= v0.34`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `forward_metrics_to` | `list(MetricsReceiver)` | Receivers to forward collected metrics to. | | yes
| `forward_logs_to` | `list(LogsReceiver)` | Receivers to forward collected logs to. | | yes
| `scrape_interval` | `duration` | How often to collect metrics. | `"60s"` | no
| `scrape_timeout` | `duration` | Timeout period for collecting metrics. | `"10s"` | no

`k8s_pods` uses in-cluster authentication for connecting to Kubernetes, and
expects to be running inside the Kubernetes cluster.

`k8s_pods` will collect logs from all discovered Pods in the cluster. Metrics
will only be collected from Pods that have a port name ending in `-metrics`.

All telemetry data will have the following labels:

* `job`: set to `POD_NAMESPACE/POD_SERVICE_NAME`. `POD_SERVICE_NAME` is
  set to the value of the first set from the following:
  * A label named `k8s-app`.
  * A label named `app`.
  * A label named `name`.
  * A combination of the `kubernetes.io/instance` and `kubernetes.io/name`
    labels, concatenated with a hyphen.
  * The pod controller name.
  * The pod name.
* `namespace`: set to `POD_NAMESPACE`.
* `pod`: set to `POD_NAME`.
* `container`: set to `POD_CONTAINER_NAME`.
* `app`: set to the value of the `app` label if present.
* `name`: set to the value of the `app.kubernetes.io/name` label if present.

Additionally, when collecting metrics, the `instance` label is set to
`POD_NAME:POD_CONTAINER_NAME:POD_CONTAINER_PORT_NAME`.

## Module exports

`k8s_pods` does not export any fields.

## Example

This example uses the `module.git` loader to run the module and forward metrics
to a [`prometheus.remote_write` component][prometheus.remote_write] and forward
logs to a [`loki.write` component][loki.write]:

```river
module.git "k8s_pods" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "modules/k8s_pods/module.river"

  arguments {
    forward_metrics_to = [prometheus.remote_write.default.receiver]
    forward_logs_to    = [loki.write.default.receiver]
  }
}

prometheus.remote_write "default" {
  endpoint {
    url = env("PROMETHEUS_URL")
  }
}

loki.write "default" {
  endpoint {
    url = env("LOKI_URL")
  }
}
```

[prometheus.remote_write]: https://grafana.com/docs/agent/latest/flow/reference/components/prometheus.remote_write
[loki.write]: https://grafana.com/docs/agent/latest/flow/reference/components/loki.write