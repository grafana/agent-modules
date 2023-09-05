# k8s_api

The `k8s_api` module collects Kubernetes API server metrics and forwards them
to a Prometheus-compatible Grafana Agent Flow component.

> **NOTE**: `k8s_api` must be used with a module loader which can pass arguments
> to loaded modules, such as `module.git`.

## Agent Version

`>= v0.34`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `forward_metrics_to` | `list(MetricsReceiver)` | Receivers to forward collected metrics to. | | yes
| `scrape_interval` | `duration` | How often to collect metrics. | `"60s"` | no
| `scrape_timeout` | `duration` | Timeout period for collecting metrics. | `"10s"` | no

`k8s_api` uses in-cluster authentication for connecting to Kubernetes, and
expects to be running inside the Kubernetes cluster.

## Module exports

`k8s_api` does not export any fields.

## Example

This example uses the `module.git` loader to run the module and forward metrics
to a [`prometheus.remote_write` component][prometheus.remote_write]:

```river
module.git "k8s_api" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "modules/k8s_api/module.river"

  arguments {
    forward_metrics_to = [prometheus.remote_write.default.receiver]
  }
}

prometheus.remote_write "default" {
  endpoint {
    url = env("PROMETHEUS_URL")
  }
}
```

[prometheus.remote_write]: https://grafana.com/docs/agent/latest/flow/reference/components/prometheus.remote_write