# Overview

This example shows how to build multiple Datadog Helm Chart value files to target each OS type.

Please read this [Datadog documentation](https://docs.datadoghq.com/agent/troubleshooting/windows_containers/#mixed-clusters-linux--windows) for common troubleshooting Q&A for mixed Linux and Windows clusters.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> These charts must be deployed in order and the values files are named accordingly and have configuration options set assuming this order of deployment.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️

# Cluster Agents

You must only have a single Cluster Agent deployment per Kubernetes Cluster.

1. The Linux chart (the first one) creates the cluster agent and deploys node agents to just Linux nodes.
2. The Windows chart (the second one) creates node agents on just Windows nodes and has them join the Cluster Agent deployed in the Linux chart (the first one).

Before deploying the second (or more) chart, you may need to update the values files for the following options. They can be found as artifacts from the first deployment.

- `existingClusterAgent.tokenSecretName`
- `existingClusterAgent.serviceName`

# Important configuration options

For all, but the first chart, these are the critical options that must be changed

```yaml
targetSystem: windows

# Disables the deployment of a Cluster Agent
clusterAgent:
  enabled: false

# Joins the new node agents to the existing cluster agent
existingClusterAgent:
  join: true
  serviceName: "<EXISTING_DCA_SERVICE_NAME>" # from the first Datadog Helm chart
  tokenSecretName: "<EXISTING_DCA_SECRET_NAME>" # from the first Datadog Helm chart

# Disable datadogMetrics deployment since it should have been already deployed with the first chart.
datadog-crds:
  crds:
    datadogMetrics: false

# Disable kube-state-metrics deployment. Its legacy anyway, but we shouldn't run it twice
datadog:
  kubeStateMetricsEnabled: false
```
