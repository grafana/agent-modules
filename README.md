<p align="center"><img src="assets/logo_and_name.png" alt="Grafana Agent logo"></p>

[Modules](https://grafana.com/docs/agent/latest/flow/concepts/modules/) are a 
way to create Grafana Agent [Flow](https://grafana.com/docs/agent/latest/flow/)
configurations which can be loaded as a component. Modules are a great way to
parameterize a configuration to create reusable pipelines.

## Contents
- <b>modules</b>: A library of usable modules out of the box
- <b>example</b>: A practical example shown for each module loader plus without modules for comparison
- <b>util</b>: Utilities for managing modules in this repo

## Categories

### OTLP

OTLP covers multi use OpenTelemetry modules

| Name |  Description | Agent Version | 
| ---- |  ----------- | ------------- | 
| [OTLP to LGTM](./modules/otlp/otlp-to-lgtm/) | Module to ingest OTLP data and then send it to Loki, Mimir and Tempo stacks locally or in GrafanaCloud. | `>= v0.33`
| [Grafana Agent Telemetry to LGTM](./modules/grafana-agent/telemetry-to-lgtm/) | Module to forward the Grafana Agent's own telemetry data to Loki, Mimir and Tempo stacks locally or in Grafana Cloud. | `>= v0.33`
| [Grafana Agent Dynamic Blackbox Exporter](./modules/grafana-agent/dynamic-blackbox/) | Module to use blackbox exporter with dynamic targets. | `>= v0.35`
| [Grafana Cloud Autoconfigure](./modules/grafana-cloud/autoconfigure/) | Module to automatically configure receivers for Grafana Cloud. | `>= v0.34`
