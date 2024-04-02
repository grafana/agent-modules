# Konnectivity Agent Module

Handles scraping Konnectivity Agent metrics.

## Components

-   [kubernetes](#kubernetes)
-   [local](#local)
-   [scrape](#scrape)

### kubernetes

Handles discovery of kubernetes targets and exports them, this component does not perform any scraping at all and is not required to be used for kubernetes, as a custom service discovery and targets can be defined and passed to `konnectivity.scrape`

#### Arguments

| Name               | Required | Default                                        | Description                                                                 |
| :----------------- | :------- | :--------------------------------------------- | :-------------------------------------------------------------------------- |
| `namespaces`       | _no_     | `[]`                                           | The namespaces to look for targets in, the default (`[]`) is all namespaces |
| `field_selectors`  | _no_     | `[]`                                           | The label selectors to use to find matching targets                         |
| `label_selectors`  | _no_     | `["app.kubernetes.io/component=konnectivity"]` | The label selectors to use to find matching targets                         |
| `port_name`        | _no_     | `metrics`                                      | The of the port to scrape metrics from                                      |

#### Exports

| Name     | Type                | Description                |
| :------- | :------------------ | :--------------------------|
| `output` | `list(map(string))` | List of discovered targets |

#### Labels

The following labels are automatically added to exported targets.

| Label       | Description                                                                                       |
| :---------- | :------------------------------------------------------------------------------------------------ |
| `app`       | Derived from the pod label value of `app.kubernetes.io/name`, `k8s-app`, or `app`                 |
| `namespace` | The namespace the target was found in.                                                            |
| `service`   | The full name of the service                                                                      |
| `source`    | Constant value of `kubernetes`, denoting where the results came from, this can be useful for LBAC |

---

### scrape

#### Arguments

| Name              | Required | Default                       | Description                                                                                                                                         |
| :---------------- | :------- | :---------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| `targets`         | _yes_    | `list(map(string))`           | List of targets to scrape                                                                                                                           |
| `forward_to`      | _yes_    | `list(MetricsReceiver)`       | Must be a where scraped should be forwarded to                                                                                                      |
| `job_label`       | _no_     | `integrations/mimir`          | The job label to add for all mimir metric                                                                                                           |
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
| `job` | Set to the value of `argument.job_label.value` |

---

## Usage

### Kubernetes

The following example will scrape all konnectivity instances in cluster.

```river
import.git "konnectivity" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "v2/integrations/konnectivity/module.river"
  pull_frequency = "15m"
}

// get the targets
konnectivity.kubernetes "targets" {}

// scrape the targets
konnectivity.scrape "metrics" {
  targets = konnectivity.kubernetes.targets.output
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

The following example will scrape konnectivity for metrics on the local machine.

```river
import.git "konnectivity" {
  repository = "https://github.com/grafana/agent-modules.git"
  revision   = "main"
  path       = "v2/integrations/konnectivity/module.river"
  pull_frequency = "15m"
}

// get the targets
konnectivity.local "targets" {}

// scrape the targets
konnectivity.scrape "metrics" {
  targets = konnectivity.local.targets.output
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
