# MySQL integration
Module which performs expected transformations and labeling for the [MySQL integration](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/integrations/integration-reference/integration-mysql/)

## Usage
Because the instance name is an argument to this module, the module must be re-used for each MySQL instance you wish to observe.

Some examples can be found below.

### Multiple instances on the same host

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

### Multiple instances with kuberenetes discovery

Placeholder