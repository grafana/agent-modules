<p align="center"><img src="assets/logo_and_name.png" alt="Grafana Agent logo"></p>

[Modules](https://grafana.com/docs/agent/latest/flow/concepts/modules/) are a
way to create Grafana Agent [Flow](https://grafana.com/docs/agent/latest/flow/)
configurations which can be loaded as a component. Modules are a great way to
parameterize a configuration to create reusable pipelines.

## Contents
- <b>modules</b>: A library of usable modules out of the box
- <b>example</b>: A practical example shown for each module loader plus without modules for comparison
- <b>util</b>: Utilities for managing modules in this repo

## Modules

| Name |  Description | Agent Version |
| ---- |  ----------- | ------------- |
| [Metrics and Logs Annotation Ingestion](./modules/kubernetes/) | Module to ingest Metrics (scraping/probes) and Logs through annotations. | `>= v0.36.1`
| [OTLP to LGTM](./modules/otlp/otlp-to-lgtm/) | Module to ingest OTLP data and then send it to Loki, Mimir and Tempo stacks locally or in GrafanaCloud. | `>= v0.33`
| [Grafana Agent Telemetry to LGTM](./modules/grafana-agent/telemetry-to-lgtm/) | Module to forward the Grafana Agent's own telemetry data to Loki, Mimir and Tempo stacks locally or in Grafana Cloud. | `>= v0.33`
| [Grafana Agent Dynamic Blackbox Exporter](./modules/grafana-agent/dynamic-blackbox/) | Module to use blackbox exporter with dynamic targets. | `>= v0.39`
| [Grafana Cloud Autoconfigure](./modules/grafana-cloud/autoconfigure/) | Module to automatically configure receivers for Grafana Cloud. | `>= v0.34`
| [Host Filtering](./modules/host-filter/) | The host filtering module provides a Flow mode equivalent to static mode's host filtering functionality. | `>= v0.34`

## Submitting modules

Add modules to the `modules` folder. Each module must have a README.MD that provides the following information:
* Name
* Brief description
* Applicable Agent Versions
* Arguments
* Exports
* Example

Modules must contain the following elements:
* Arguments
* Exports
* The body of the module
