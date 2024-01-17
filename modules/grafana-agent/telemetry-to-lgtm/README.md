# Grafana Agent Telemetry to LGTM Stack Module

Module to forward the Grafana Agent's own telemetry data to Loki, Mimir and Tempo stacks locally or in GrafanaCloud.

## Agent Version

`>= v0.36`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `grafana_agent_port`  | `string`   | The port the Grafana Agent is running on. | `"12345"` | no
| `prometheus_endpoint` | `receiver` | The Prometheus remote write endpoint. | | yes
| `prometheus_user`     | `string`   | The Prometheus remote write basic auth username. | | yes
| `prometheus_password` | `secret`   | The Prometheus remote write basic auth password. | | yes
| `loki_endpoint`       | `string`   | Loki endpoint | | yes
| `loki_user`           | `string`   | Loki basic auth username. | | yes
| `loki_password`       | `secret`   | Loki basic auth password. | | yes
| `tempo_endpoint`      | `string`   | Tempo Endpoint | | yes
| `tempo_user`          | `string`   | Tempo basic auth username. | | yes
| `tempo_password`      | `secret`   | Tempo basic auth password. | | yes

## Module exports

The following fields are exported by the module:

| Name | Type | Description
| ---- | ---- | -----------
| `log_receiver` | `LogsReceiver`     | A logs receiver that other components can use to send telemetry data to.
| `trace_input`  | `otelcol.Consumer` | A value that other components can use to send telemetry data to.

## Example

```
logging {
	level    = "info"
	format   = "logfmt"
	write_to = [module.git.agent_telemetry.exports.log_receiver]
}

tracing {
	sampling_fraction = 1
	write_to          = [module.git.agent_telemetry.exports.trace_input]
}

module.git "agent_telemetry" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "modules/grafana-agent/telemetry-to-lgtm/module.river"

    arguments {
        prometheus_endpoint = "https://prometheus-us-central1.grafana.net/api/prom/push"
        prometheus_user     = "123456"
        prometheus_password = env("GRAFANA_CLOUD_KEY")

        loki_endpoint = "https://logs-prod-us-central1.grafana.net/loki/api/v1/push"
        loki_user     = "1234567"
        loki_password = env("GRAFANA_CLOUD_KEY")

        tempo_endpoint = "tempo-us-central1.grafana.net:443"
        tempo_user     = "1234"
        tempo_password = env("GRAFANA_CLOUD_KEY")
    }
}
```
