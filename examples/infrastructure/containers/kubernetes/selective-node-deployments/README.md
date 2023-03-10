# Overview

This example shows how to build multiple Datadog Helm Chart value files to target subgroups of nodes using node selection and affinity. It is nearly identical to the mixed-os cluster example, but just uses node selectors.

In the case where you need to deploy two charts to the same cluster for any reason, e.g. multiple OS used across the subgroups of nodes, it also shows how to properly have only a single Cluster Agent deployment managing the full fleet, irregardless of what the node is.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> These charts must be deployed in order and the values files are named accordingly and have configuration options set assuming this order of deployment.
>
> Note that each chart must select a mutually exclusive set of nodes. You cannot deploy two Agents to a single node.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️

Before using this configuration, please update any values between angle brackets (`<` and `>`).

- `<DATADOG_API_KEY>`
- `<DATADOG_APP_KEY>`
- `<CLUSTER_NAME>`
- `<EXISTING_DCA_SERVICE_NAME>`
- `<EXISTING_DCA_SECRET_NAME>`

# Cluster Agents

You must only have a single Cluster Agent deployment per Kubernetes Cluster.

1. The first chart creates the cluster agent and deploys node agents to just the nodes that match the node selectors.
2. The second chart creates node agents on just the nodes that match the node selectors and has them join the Cluster Agent deployed in the first chart.

Before deploying the second (or more) chart, you may need to update the values files for the following options. They can be found as artifacts from the first deployment.

- `existingClusterAgent.tokenSecretName`
- `existingClusterAgent.serviceName`

# Important deployment-specific configuration options

For all, but the first chart, these are the critical options that must be changed

```yaml
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
