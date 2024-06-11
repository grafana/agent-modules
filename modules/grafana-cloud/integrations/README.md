# Grafana Cloud Integrations

Module library to apply the opinionated configurations for Grafana Cloud [Integrations](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/integrations/integration-reference/)

## Design principals

These modules will *only* apply the opinionated configuration details for a given integration.

Usually, this means that a module will primarily require arguments for input and output. I.E. `metrics_targets`, `metrics_forward_to`, `logs_targets`, `logs_forward_to`.

The module consumer will be responsible for discovering the targets, and configuring an end-of-line receiver (usually a remote write component).