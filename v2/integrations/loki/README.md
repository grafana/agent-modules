# Memcached Module

Handles scraping Memcached metrics.

## Components

-   [kubernetes](#kubernetes)
-   [local](#local)
-   [scrape](#scrape)

### kubernetes

Handles discovery of kubernetes targets and exports them, this component does not perform any scraping at all and is not required to be used for kubernetes, as a custom service discovery and targets can be defined and passed to `loki.scrape`

#### Arguments

| Name         | Required | Default                                | Description                                                                                                                                            |
| :----------- | :------- | :------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `namespaces` | _no_     | `[]`                                   | The namespaces to look for targets in, the default (`[]`) is all namespaces                                                                            |
| `selectors`  | _no_     | `["app.kubernetes.io/name=loki"]`      | The label selectors to use to find matching targets<br>*Note:* for Grafana Enterprise Logs this should be `["app.kubernetes.io/name=enterprise-logs"]` |
| `port_name`  | _no_     | `http-metrics`                         | The of the port to scrape metrics from                                                                                                                 |

#### Exports

| Name     | Type                | Description                |
| :------- | :------------------ | :--------------------------|
| `output` | `list(map(string))` | List of discovered targets |

#### Labels

The following labels are automatically added to exported targets.

| Label       | Description                                                                                                                                         |
| :---------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| `app`       | Derived from the pod label value of `app.kubernetes.io/name`, `k8s-app`, or `app`                                                                   |
| `component` | Derived from the pod label value of `app.kubernetes.io/component`, `k8s-component`, or `component                                                   |
| `container` | The name of the container, usually `haproxy`                                                                                                        |
| `namespace` | The namespace the target was found in.                                                                                                              |
| `pod`       | The full name of the pod                                                                                                                            |
| `source`    | Constant value of `kubernetes`, denoting where the results came from, this can be useful for LBAC                                                   |
| `workload`  | Kubernetes workload, a combination of `__meta_kubernetes_pod_controller_kind` and `__meta_kubernetes_pod_controller_name`, i.e. `ReplicaSet/my-app` |
---

### local

#### Arguments

| Name   | Optional | Default | Description                            |
| :----- | :------- | :------ | :------------------------------------- |
| `port` | `true`   | `3100`  | The of the port to scrape metrics from |

#### Exports

| Name     | Type                | Description                |
| :------- | :------------------ | :--------------------------|
| `output` | `list(map(string))` | List of discovered targets |

#### Labels

The following labels are automatically added to exported targets.

| Label    | Description                                                                                  |
| :------- | :------------------------------------------------------------------------------------------- |
| `source` | Constant value of `local`, denoting where the results came from, this can be useful for LBAC |

---

### scrape

#### Arguments

| Name              | Required | Default                       | Description                                                                                                                                         |
| :---------------- | :------- | :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| `targets`         | _yes_    | `list(map(string))`           | List of targets to scrape                                                                                                                           |
| `forward_to`      | _yes_    | `list(MetricsReceiver)`       | Must be a where scraped should be forwarded to                                                                                                      |
| `job_label`       | _no_     | `integrations/loki`           | The job label to add for all mimir metric                                                                                                           |
| `port_name`       | _no_     | `http-metrics`                | The of the port to scrape metrics from                                                                                                              |
| `keep_metrics`    | _no_     | [see code](module.river#L228) | A regex of metrics to keep                                                                                                                          |
| `drop_metrics`    | _no_     | [see code](module.river#L235) | A regex of metrics to drop                                                                                                                          |
| `scrape_interval` | _no_     | `60s`                         | How often to scrape metrics from the targets                                                                                                        |
| `scrape_timeout`  | _no_     | `10s`                         | How long before a scrape times out                                                                                                                  |
| `max_cache_size`  | _no_     | `100000`                      | The maximum number of elements to hold in the relabeling cache.  This should be at least 2x-5x your largest scrape target or samples appended rate. |
| `clustering`      | _no_     | `false`                       | Whether or not [clustering](https://grafana.com/docs/agent/latest/flow/concepts/clustering/) should be enabled                                      |

#### Labels

The following labels are automatically added to exported targets.

| Label | Description |
| :---- | :-----------|
| `job` | For kubernetes scrapes, this label is set to `{{namespace}}/{{controller_name}}` |


---

## Usage

### Kubernetes

The following example will scrape all loki instances in cluster.

```river
import.git "loki" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "v2/integrations/loki/module.river"
  pull_frequency = "15m"
}

// get the targets
loki.kubernetes "targets" {}

// scrape the targets
loki.scrape "metrics" {
  targets = loki.kubernetes.targets.output
  forward_to = [
    prometheus.remote_write.default.receiver,
  ]
}

// write the metrics
prometheus.remote_write "local_primary" {
  endpoint {
    url = "http://mimir:9009/api/v1/push"

    basic_auth {
      username = "example-user"
      password = "example-password"
    }
  }
}
```

### Local

The following example will scrape loki for metrics on the local machine.

```river
import.git "loki" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "v2/integrations/loki/module.river"
  pull_frequency = "15m"
}

// get the targets
loki.local "targets" {}

// scrape the targets
loki.scrape "metrics" {
  targets = loki.local.targets.output
  forward_to = [
    prometheus.remote_write.default.receiver,
  ]
}

// write the metrics
prometheus.remote_write "default" {
  endpoint {
    url = "http://mimir:9009/api/v1/push"

    basic_auth {
      username = "example-user"
      password = "example-password"
    }
  }
}
```
