# OTLP to LGTM Stack Module

Module to ingest OTLP data and then send it to Loki, Mimir and Tempo stacks locally or in GrafanaCloud.

## Agent Version

`>= v0.33`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `otlp_http_endpoint` | `string` | The OTLP HTTP server URL. | `"0.0.0.0:4318"` | no
| `otlp_grpc_endpoint` | `string` | The OTLP gRPC server URL. | `"0.0.0.0:4317"` | no
| `prometheus_endpoint`      | `receiver` | The Prometheus remote write endpoint. | | yes
| `prometheus_user`      | `string` | The Prometheus remote write basic auth username. | | yes
| `prometheus_password`      | `secret` | The Prometheus remote write basic auth password. | | yes
| `loki_endpoint`      | `string` | Loki endpoint | | yes
| `loki_user`      | `string` |Loki basic auth username. | | yes
| `loki_password`      | `secret` |Loki basic auth password. | | yes
| `tempo_endpoint`      | `string` | Tempo Endpoint | | yes
| `tempo_user`      | `string` | Tempo basic auth username. | | yes
| `tempo_password`      | `secret` | Tempo basic auth password. | | yes

## Module exports

The module has no exports.

## Example

```
module.git "otlp_to_lgtm" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "modules/otlp/otlp-to-lgtm/module.river"

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
