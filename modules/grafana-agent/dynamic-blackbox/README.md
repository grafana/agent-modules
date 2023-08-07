# Grafana Agent Telemetry to LGTM Stack Module

Module to add a dynamic target list to blackbox exporter.

## Agent Version

`>= v0.35`

## Module arguments

The following arguments are supported when passing arguments to the module loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `targets`  | `list(map(string))`   | List of targets for blackbox | | yes
| `target_label` | `string` | Metric label the original target will be added to | `"address"` | no
| `config_file`     | `string` or `secret`  | 	blackbox_exporter configuration file path | | no
| `config` | `secret`   | blackbox_exporter configuration as inline string | | no
| `probe_timeout_offset`       | `duration`   | Offset in seconds to subtract from timeout when probing targets | `"0.5s"` | no

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