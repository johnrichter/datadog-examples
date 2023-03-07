# Overview

Observability Pipelines does not yet support all telemetry types and data intakes for every Datadog product. This configuration disables all features except for metrics, traces, and logs that will be forwarded through Observability Pipelines.

Supported (will be routed through Observability Pipelines)

- Metrics
- Logs
- Traces

WIP/Unsupported (will be routed through the proxy)

- Inventories
- Live Process
- Live Containers
- CSPM
- CWS
- USM
- NDM
  - Traps
  - Netflows

Please see the following for a full list of data intakes used for Datadog products.

https://docs.datadoghq.com/agent/guide/network/

To use these features while development on Observability Pipelines and Observability Pipelines continues the recommended path is to leverage a proxy server to forward this data to Datadog. The Agent will forward metrics, traces, and logs through Observability Pipelines and everything else through the proxy. See `proxy` section above.

https://docs.datadoghq.com/agent/proxy/

# Datadog Agent

The configs for the Datadog Agent also include useful configuration options for several features. These were left in to help guide configuration of these features.
