# Kubernetes Modules

## Logs

The following pod annotations are supported:

| Annotation       | Label        | Description |
| :--------------- | :----------- | :-----------|
| `logs.agent.grafana.com/scrape` | `logs_agent_grafana_com_scrape` | Allow a pod to declare it's logs should be dropped. |
| `logs.agent.grafana.com/tenant` | `logs_agent_grafana_com_tenant` | Allow a pod to override the tenant for its logs. |
| `logs.agent.grafana.com/log-format` | `logs_agent_grafana_com_log_format` | If specified additional processing is performed to extract details based on the specified format.  The following formats are currently supported: common-log, donet, istio, json, klog, log4j, logfmt, otel, postgres, python, and spring-boot |
| `logs.agent.grafana.com/scrub-level` | `logs_agent_grafana_com_scrub_level` | Boolean whether or not the level should be dropped from the log message (as it is a label). |
| `logs.agent.grafana.com/scrub-timestamp` | `logs_agent_grafana_com_scrub_timestamp` | Boolean whether or not the timestamp should be dropped from the log message (as it is metadata). |
| `logs.agent.grafana.com/scrub-nulls` | `logs_agent_grafana_com_scrub_nulls` | Boolean whether or not keys with null values should be dropped from json, reducing the size of the log message. |
| `logs.agent.grafana.com/scrub-empties` | `logs_agent_grafana_com_scrub_empties` | Boolean whether or not keys with empty values (`"", [], {}`) should be dropped from json, reducing the size of the log message. |
| `logs.agent.grafana.com/embed-pod` | `logs_agent_grafana_com_embed_pod` | Boolean whether or not to inject the name of the pod to the end of the log message i.e. `__pod=agent-logs-grafana-agent-jrqms`. |
| `logs.agent.grafana.com/drop-info` | `logs_agent_grafana_com_drop_info` | Boolean whether or not info messages should be dropped (default is `false`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/drop-debug` | `logs_agent_grafana_com_drop_debug` | Boolean whether or not debug messages should be dropped (default is `true`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/drop-trace` | `logs_agent_grafana_com_drop_trace` | Boolean whether or not trace messages should be dropped (default is `true`), but a pod can override this temporarily or permanently. |
| `logs.agent.grafana.com/mask-ssn` | `logs_agent_grafana_com_mask_ssn` | Boolean whether or not to mask SSNs in the log line, if true the data will  be masked as `*SSN*salt*` |
| `logs.agent.grafana.com/mask-credit-card` | `logs_agent_grafana_com_mask_credit_card` | Boolean whether or not to mask credit cards in the log line, if true the data will be masked as `*credit-card*salt*` |
| `logs.agent.grafana.com/mask-email` | `logs_agent_grafana_com_mask_email` | Boolean whether or not to mask emails in the log line, if true the data will be masked as`*email*salt*` |
| `logs.agent.grafana.com/mask-ipv4` | `logs_agent_grafana_com_mask_ipv4` | Boolean whether or not to mask IPv4 addresses in the log line,, if true the data will be masked as`*ipv4*salt*` |
| `logs.agent.grafana.com/mask-ipv6` | `logs_agent_grafana_com_mask_ipv6` | Boolean whether or not to mask IPv6 addresses in the log line, if true the data will be masked as `*ipv6*salt*` |
| `logs.agent.grafana.com/mask-phone` | `logs_agent_grafana_com_mask_phone` | Boolean whether or not to mask phone numbers in the log line, if true the data will be masked as `*phone*salt*` |

See [/example/logs/kubernetes](../../example/logs/kubernetes) for working example configurations.
