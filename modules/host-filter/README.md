# Host filtering module

The host filtering module provides a Flow mode equivalent to static mode's
[host filtering][] functionality.

[host filtering]: https://grafana.com/docs/agent/latest/static/operation-guide/#host-filtering-beta

## Agent Version

`>= v0.34`

## Module arguments

The following arguments are supported when passing arguments to the module
loader:

| Name | Type | Description | Default | Required
| ---- | ---- | ----------- | ------- | --------
| `targets` | `list(map(string))` | Targets to filter. | | yes
| `hostname` | `string` | Hostname to use for filtering. | _See below_ | no

The `targets` argument determines the set of targets to perform host filtering
against. The following labels are used for host filtering:

* `__meta_consul_node`
* `__meta_dockerswarm_node_id`
* `__meta_dockerswarm_node_hostname`
* `__meta_dockerswarm_node_address`
* `__meta_kubernetes_pod_node_name`
* `__meta_kubernetes_node_name`
* `__host__`

Targets are kept if the target has one of the above labels set to one of the
following values:

* `localhost` or `127.0.0.1`
* The value of the `hostname` argument.

The `hostname` argument defaults to the first of the following:

* The `HOSTNAME` environment variable, if set.
* The system-reported hostname.

## Module exports

The following exports are exposed and can be used:

| Name | Type | Description
| ---- | ---- | -----------
| `output` | `list(map(string))` | Filtered targets.

## Example

This example scrapes Kubernetes pods which are running on the same Kubernetes
Node as Grafana Agent:

```river
discovery.kubernetes "pods" {
    role = "pod"
}

module.git "host_filter" {
    repository = "https://github.com/grafana/agent-modules.git"
    revision   = "main"
    path       = "modules/host-filter/module.river"

    arguments {
        targets = discovery.kubernetes.pods.targets
    }
}

prometheus.scrape "pods" {
    targets    = module.git.host_filter.exports.output
    forward_to = [prometheus.remote_write.example.receiver]
}

prometheus.remote_write "example" {
    endpoint {
        url = PROMETHEUS_URL
    }
}
```
