# OTLP to LGTM Stack Module

Module to ingest OTLP data and then send it to Loki, Mimir and Tempo stacks locally or in GrafanaCloud.

## Example

```
module.git "otlp_to_lgtm" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "otlp-to-lgtm/module.river"

    arguments {
        prometheus_endpoint = "https://prometheus-us-central1.grafana.net/api/prom"
        prometheus_user = "123456"
        prometheus_password = env("GRAFANA_CLOUD_KEY")

        loki_endpoint = "https://logs-prod-us-central1.grafana.net"
        loki_user = "1234567"
        loki_password = env("GRAFANA_CLOUD_KEY")

        tempo_endpoint = "tempo-us-central1.grafana.net:443"
        tempo_user = "1234"
        tempo_password = env("GRAFANA_CLOUD_KEY")
    }
}
```

## Arguments

### `otlp_http_endpoint`

The OTLP HTTP server URL.

```
optional = true
default = "0.0.0.0:4318"
```

### `otlp_grpc_endpoint`

The OTLP gRPC server URL.

```
optional = true
default = "0.0.0.0:4317"
```

### `prometheus_endpoint`

The Prometheus remote write endpoint.

```
example = https://prometheus-us-central1.grafana.net/api/prom
```

### `prometheus_user`

The Prometheus remote write basic auth username.

```
example = 12345
```


### `prometheus_password`

The Prometheus remote write basic auth password.

```
example = ababababababababa.....=
```

### `loki_endpoint`

Loki endpoint.

```
example = https://logs-prod-us-central1.grafana.net
```

### `loki_user`

Loki basic auth username.

```
example = 12345
```

### `loki_password`

Loki basic auth password.

```
example = ababababababababa.....=
```

### `tempo_endpoint`

Tempo endpoint.

```
example = https://prometheus-us-central1.grafana.net/api/prom
```

### `tempo_user`

Tempo basic auth username.

```
example = tempo-us-central1.grafana.net:443
```

### `tempo_password`

Tempo basic auth password.

```
example = ababababababababa.....=
```