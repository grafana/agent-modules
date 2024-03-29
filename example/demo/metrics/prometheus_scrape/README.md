# metrics/prometheus_scrape

The `metrics/prometheus_scrape` module is an example module which scrapes
metrics from a promtheus compatible endpoint and forwards them to a receiver.

## Agent Version

`>= v0.34`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `address`         | `string`          | The target address to scrape metrics from. | | yes
| `receiver`        | `MetricsReceiver` | Receiver to send scraped metrics to. | | yes
| `scrape_interval` | `duration`        | How frequently to scrape the targets of this scrape config. | "10s" | no

## Module exports

This module does not export anything.

## Example

This example demonstrates how you can send all metrics generated by the Grafana
Agent to a prometheus endpoint using basic auth.

```river
prometheus.remote_write "default" {
	endpoint {
		url = env("METRIC_URL")

		basic_auth {
			username = env("METRIC_USERNAME")
			password = env("METRIC_PASSWORD")
		}
	}
}

module.git "metrics_prometheus_scrape_agent" {
	repository = "https://github.com/grafana/agent-modules.git"
	revision   = "main"
	path       = "example/demo/metrics/prometheus_scrape/module.river"

	arguments {
		address  = "0.0.0.0:12345"
		receiver = prometheus.remote_write.default.receiver
	}
}

```
