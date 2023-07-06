# Grafana Cloud Autoconfigure Module

Module to automatically configure receivers for Grafana Cloud.

## Agent Version

`>= v0.34`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `stack_name`  | `string`   | Name of your stack as shown in the account console | | yes
| `token` | `secret` | Access policy token or API Key. | | yes

To create a token:
1. Navigate to the [Grafana Cloud Portal](https://grafana.com/profile/org)
1. Go to either the `Access Policies` or `API Keys` page, located in the `Security` section
1. Create an Access Policy or API token with the correct permissions

The token must have permissions to read stack information. The setup of these permissions depends on the type of token:

* Access Policies need the `stacks:read` scope
* API Keys need at least the the `MetricsPublisher` role

## Module exports

The following fields are exported by the module:

| Name | Type | Description
| ---- | ---- | -----------
| `metrics_receiver` | `prometheus.Interceptor` | A value that other components can use to send metrics data to.
| `logs_receiver` | `loki.LogsReceiver` | A value that other components can use to send logs data to.
| `traces_receiver` | `otelcol.Consumer` | A value that other components can use to send trace data to.
| `profiles_receiver` | `write.fanOutClient` | A value that other components can use to send profiling data to.
| `stack_information` | `object` | Decoded representation of the [Stack info endpoint](https://grafana.com/docs/grafana-cloud/api-reference/cloud-api/#stacks).

## Example

```
module.git "grafana_cloud" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "modules/grafana-cloud/autoconfigure/module.river"

    arguments {
        stack_name = "<your-stack-name>"
        token      = "<your-access-token>"
    }
}

prometheus.scrape "default" {
  targets = [
    {"__address__" = "127.0.0.1:12345"},
  ]
  forward_to = [
    module.git.grafana_cloud.exports.metrics_receiver,
  ]
}
```
