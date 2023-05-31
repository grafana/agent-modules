# metrics/kubernetes_autoscrape

The `metrics/kubernetes` module is an example for scraping of metrics from your kubernetes cluster.

## Agent Version

`>= v0.34`

## Module arguments

The module does not need any arguments

## Module exports

The following fields are exported by the module:

| Name | Type | Description
| ---- | ---- | -----------
| `targets` | `` | Targets from discovered pods to be scraped


prometheus.remote_write "default" {
	endpoint {
		url = env("METRIC_URL")

		basic_auth {
			username = env("METRIC_USERNAME")
			password = env("METRIC_PASSWORD")
		}
	}
}

module.git "kubernetes_metrics" {
	repository = "https://github.com/grafana/agent-modules.git"
	revision   = "cmp_k8s"
	path       = "example/metrics/kubernetes/common.river"

	arguments {
		receiver = prometheus.remote_write.default.receiver
        node_name_filter = env("HOSTNAME")
	}
}