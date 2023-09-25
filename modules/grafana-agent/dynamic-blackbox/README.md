# Grafana Agent Dynamic Blackbox Exporter

A module to add a dynamic target list to blackbox exporter.

The `prometheus.exporter.blackbox` component expects a series of target blocks as part of its configuration and doesn't accept a list of targets from another component.

This module allows a list of targets from another component to be used by blackbox exporter for scraping.

## Agent Version

`>= v0.35`

## Module arguments

The following arguments are supported when passing arguments to the module loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `targets`  | `list(map(string))`   | List of targets for blackbox | | yes
| `target_label` | `string` | Metric label the original target label will be added to | `"address"` | no
| `config_file`     | `string` or `secret`  | 	blackbox_exporter configuration file path | | no
| `config` | `secret`   | blackbox_exporter configuration as inline string | | no
| `probe_timeout_offset`       | `duration`   | Offset in seconds to subtract from timeout when probing targets | `"0.5s"` | no

The arguments `config` and `config_file` are mutually exclusive. If neither are specified, a default config is used.

The `config_file` argument points to a YAML file defining which blackbox_exporter modules to use.
The `config` argument must be a YAML document as string defining which blackbox_exporter modules to use.
`config` is typically loaded by using the exports of another component. For example,

- `local.file.LABEL.content`
- `remote.http.LABEL.content`
- `remote.s3.LABEL.content`

See [blackbox_exporter]( https://github.com/prometheus/blackbox_exporter/blob/master/example.yml) for details on how to generate a config file.

## Module exports

The following fields are exported by the module:

| Name | Type | Description
| ---- | ---- | -----------
| `targets` | `list(map(string))` | The targets that can be used to collect blackbox metrics.

## Example

```
discovery.file "targets" {
  files = ["targets.yml"]
}

module.git "blackbox" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "modules/grafana-agent/dynamic-blackbox/module.river"

  arguments {
    config = "{ modules: { tcps: { prober: tcp, tcp: { tls: true, tls_config: { insecure_skip_verify: true } } } } }"
    targets = discovery.file.targets.targets
  }
}

prometheus.scrape "scrape" {
  targets    = module.git.blackbox.exports.targets
  forward_to = [ prometheus.remote_write.main.receiver ]
}

prometheus.remote_write "main" {
  endpoint {
    url = "http://url/to/push"
  }
}
```

Add a `__param_module` label in the targets.yml to select the blackbox module to use with a given target.

```
---
- labels:
    type: external
    __param_module: tcps
  targets:
  - grafana.com:443
  - prometheus.io:443
```