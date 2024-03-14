# MySQL integration
Module which performs expected transformations and labeling for the [MySQL integration](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/integrations/integration-reference/integration-mysql/)

## Usage
Because the instance name is an argument to this module, the module must be re-used for each MySQL instance you wish to observe.

Some examples can be found below.

### Linux/MacOS/Windows (single host)

#### Single instance on one host

```
module.git "grafana_cloud" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "modules/grafana-cloud/autoconfigure/module.river"

  arguments {
    stack_name = "<stack name>"
    token = "<stack token>"
  }
}

prometheus.exporter.mysql "mysql" {
  data_source_name = "<username>:<password>@(<host>:<port>)/"
}

loki.source.file "mysql" {
  targets = [
    { __path__ = "/var/log/mysql/mysql.log" },
  ]
  forward_to = [module.file.mysql.exports.logs_receiver]
}

module.file "mysql" {
  filename = "/config/modules/grafana-cloud/integrations/mysql/module.river"

  arguments {
    instance = "<mysql instance name>"
    metrics_targets = prometheus.exporter.mysql.mysql.targets
    metrics_receiver = [module.file.grafana_cloud.exports.metrics_receiver]
    logs_receiver = [module.file.grafana_cloud.exports.logs_receiver]
  }
}
```


#### Multiple instances on the same host

Note that this is an unrealistic example since the hosts would likely be different, and the log files in the same location on each host.

```
module.git "grafana_cloud" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "modules/grafana-cloud/autoconfigure/module.river"

  arguments {
    stack_name = "<stack name>"
    token = "<stack token>"
  }
}

prometheus.exporter.mysql "mysqlprimary" {
  data_source_name = "<username>:<password>@(<host>:<port>)/"
}

loki.source.file "mysqlprimary" {
  targets = [
    { __path__ = "/var/log/mysql/mysqlprimary.log" },
  ]
  forward_to = [module.file.mysqlprimary.exports.logs_receiver]
}

module.file "mysqlprimary" {
  filename = "/config/modules/grafana-cloud/integrations/mysql/module.river"

  arguments {
    instance = "Primary"
    metrics_targets = prometheus.exporter.mysql.mysqlprimary.targets
    metrics_receiver = [module.file.grafana_cloud.exports.metrics_receiver]
    logs_receiver = [module.file.grafana_cloud.exports.logs_receiver]
  }
}

prometheus.exporter.mysql "mysqlsecondary" {
  data_source_name = "<username>:<password>@(<host>:<port>)/"
}

loki.source.file "mysqlsecondary" {
  targets = [
    { __path__ = "/var/log/mysql/mysqlsecondary.log" },
  ]
  forward_to = [module.file.mysqlsecondary.exports.logs_receiver]
}

module.file "mysqlsecondary" {
  filename = "/config/modules/grafana-cloud/integrations/mysql/module.river"

  arguments {
    instance = "Secondary"
    metrics_targets = prometheus.exporter.mysql.mysqlsecondary.targets
    metrics_receiver = [module.file.grafana_cloud.exports.metrics_receiver]
    logs_receiver = [module.file.grafana_cloud.exports.logs_receiver]
  }
}
```

### Kubernetes

#### K8s Monitoring Helm Chart

When using the k8s monitoring helm chart, we will take advantage of the existing extensibility of the `logs.extraConfig` configuration value. This is also the current approach for the k8s app, with the exception of the introduction of the agent-module.

logs.extraConfig:
```
// ******************************************************************************************************************************************//
// START: MySQL Integration extra config for the instance named "k8s MAD Primary"                                                            //
// ******************************************************************************************************************************************//
// New relabel for each mysql instance for which we wish to fetch pod logs.
// Appends to the relabeling which was already done by the k8s helm chart discovery relabeling which adds namespace, pod, job, and calculates the pod log path on the host
// Drops all other pods
discovery.relabel "mysqlmadprimary_pod_logs" {
  targets = discovery.relabel.pod_logs.output

  rule {
    source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_name","__meta_kubernetes_pod_label_app_kubernetes_io_instance","__meta_kubernetes_pod_label_app_kubernetes_io_component"]
    regex = "mysql;mysql-mad;primary"
    action = "keep"
  }
}

// Direct copy/paste duplication of the file match in the k8s helm chart. Needs to be duplicated for each instance, since we're (re) discovering and relabeling for eacn instance.
local.file_match "mysqlmadprimary_pod_logs" {
  path_targets = discovery.relabel.mysqlmadprimary_pod_logs.output
}

loki.source.file "mysqlmadprimary_pod_logs" {
  targets = local.file_match.mysqlmadprimary_pod_logs.targets
  forward_to = [loki.process.mysqlmadprimary_pod_logs.receiver]
}

loki.process "mysqlmadprimary_pod_logs" {
  stage.cri {} // Also duplication from the k8s helm chart, but crucially, this is copy/pasted, and might not match the setting in the chart.
  forward_to = [module.git.mysqlmadprimary.exports.logs_receiver]
}

prometheus.remote_write "blackhole" {}

module.git "mysqlmadprimary" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision = "0c0de275270f937aaebdbd137bb15dfd768a5b38"
  path = "modules/grafana-cloud/integrations/mysql/module.river"

  arguments {
    instance = "k8s MAD Primary"
    metrics_targets = [] // Blank, because this is the logs instance of k8s. This may be an indicator that the module needs to be broken into logs and metrics
    metrics_receiver = [prometheus.remote_write.blackhole.receiver]
    logs_receiver = [loki.write.grafana_cloud_loki.receiver]
  }
}
// ******************************************************************************************************************************************//
// END: MySQL Integration extra config for the instance named "k8s MAD Primary"                                                              //
// ******************************************************************************************************************************************//
```
