# Overview

GKE can be configured in two different mode of operation:

Standard: You manage the cluster’s underlying infrastructure, giving you node configuration flexibility.
Autopilot: GKE provisions and manages the cluster’s underlying infrastructure, including nodes and node pools, giving you an optimized cluster with a hands-off experience.

Depending on the operation mode of your cluster, the Datadog Agent needs to be configured differently.

# Standard

Since Agent 7.26, no specific configuration is required for GKE (whether you run Docker or containerd).

Note: When using COS (Container Optimized OS), the eBPF-based OOM Kill and TCP Queue Length checks are supported starting from the version 3.0.1 of the Helm chart. To enable these checks, configure the following setting:

`datadog.systemProbe.enableDefaultKernelHeadersPaths` to `false`.

This is enabled in the COS example.

Before using this configuration, please update any values between angle brackets (`<` and `>`).

- `<DATADOG_API_KEY>`
- `<DATADOG_APP_KEY>`
- `<CLUSTER_NAME>`

# Autopilot

Datadog recommends that you specify resource limits for the Agent container. Autopilot sets a relatively low default limit (50m CPU, 100Mi memory) that may quickly lead the Agent container to OOMKill depending on your environment. If applicable, also specify resource limits for the Trace Agent and Process Agent containers.

## Important distribution-specific configuration options

These are the critical options that must be changed

```yaml
agents:
  containers:
    agent:
      # resources for the Agent container
      resources:
        requests:
          cpu: 200m
          memory: 256Mi
        limits:
          cpu: 200m
          memory: 256Mi

    traceAgent:
      # resources for the Trace Agent container
      resources:
        requests:
          cpu: 100m
          memory: 200Mi
        limits:
          cpu: 100m
          memory: 200Mi

    processAgent:
      # resources for the Process Agent container
      resources:
        requests:
          cpu: 100m
          memory: 200Mi
        limits:
          cpu: 100m
          memory: 200Mi

    securityAgent:
      # resources for the Security Agent container
      resources:
        requests:
          cpu: 100m
          memory: 200Mi
        limits:
          cpu: 100m
          memory: 200Mi

providers:
  gke:
    autopilot: true
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#GKE).
