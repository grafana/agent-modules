# Grafana Agent Modules

This folder contains example modules and entrypoint parent config files for the
Grafana Agent. This example focuses on the agent forwarding its own metrics,
logs and traces. The purpose of the example is to demonstrate module features
such as various module loaders, passing arguments and receiving exports. It is not
recommended as the most efficient way to do this for production. See
[Grafana Agent Telemetry to LGTM](../modules/grafana-agent/telemetry-to-lgtm/) for a
practical module to use.

# Entrypoints

Provided modules can be used independently by creating your own entrypoint
parent config or via a provided entrypoint parent config. Environment variables
control the entrypoints so the entrypoints need not be modified.

Here are the exports as can be defined in a .bashrc profile. Example values were
left where possible and REDACTED where not.

```bash
export AGENT_MODE="flow"
export AGENT_CONFIG_FOLDER="/mnt/c/workspace/agent-modules/example/demo"
export AGENT_LOG_LEVEL="debug"
export METRIC_URL="https://prometheus-us-central1.grafana.net/api/prom/push"
export METRIC_USERNAME="REDACTED"
export METRIC_PASSWORD="REDACTED"
export LOG_URL="https://logs-prod3.grafana.net/loki/api/v1/push"
export LOG_USERNAME="REDACTED"
export LOG_PASSWORD="REDACTED"
export TRACE_URL="https://tempo-us-central1.grafana.net:443"
export TRACE_USERNAME="REDACTED"
export TRACE_PASSWORD="REDACTED"
```

## `module.string` Entrypoint

`string.river` is an entrypoint parent config for using modules with the `module.string` module loader.
The contents of `module.string` are loaded using the `local.file` flow component.

Clone this repo and set the AGENT_CONFIG_FOLDER environment variable to the path to this folder.

The command to run the agent from the root of the project looks like this:

```bash
go run ./cmd/grafana-agent run ${AGENT_CONFIG_FOLDER}/string.river
```

or if running an installed agent, something like this should work:

```bash
grafana-agent run ${AGENT_CONFIG_FOLDER}/string.river
```

## `module.file` Entrypoint

`file.river` is an entrypoint parent config for using modules with the `module.file` module loader.

Clone this repo and set the AGENT_CONFIG_FOLDER environment variable to the path to this folder.

The command to run the agent from the root of the agent project looks like this:

```bash
go run ./cmd/grafana-agent run ${AGENT_CONFIG_FOLDER}/file.river
```

or if running an installed agent, something like this should work:

```bash
grafana-agent run ${AGENT_CONFIG_FOLDER}/file.river
```

## `module.git` Entrypoint

`git.river` is an entrypoint parent config for using modules with the `module.git` module loader.

Copy this entrypoint parent config and set the AGENT_CONFIG_FOLDER environment variable to the path to the config.

The command to run the agent from the root of the agent project looks like this:

```bash
go run ./cmd/grafana-agent run ${AGENT_CONFIG_FOLDER}/git.river
```

or if running an installed agent, something like this should work:

```bash
grafana-agent run ${AGENT_CONFIG_FOLDER}/git.river
```

## Without Module Entrypoint

`single.river` is an entrypoint parent config that does not make use of modules.
This is useful for testing and visual comparison with modules.

Clone this repo and set the AGENT_CONFIG_FOLDER environment variable to the path to this folder.

The command to run the agent from the root of the agent project looks like this:

```bash
go run ./cmd/grafana-agent run ${AGENT_CONFIG_FOLDER}/single.river
```

or if running an installed agent, something like this should work:

```bash
grafana-agent run ${AGENT_CONFIG_FOLDER}/single.river
```