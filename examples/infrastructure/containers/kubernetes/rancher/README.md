# Overview

Rancher installations are close to vanilla Kubernetes, requiring only some minor configuration:

- Tolerations are required to schedule the Node Agent on controlplane and etcd nodes
- Cluster name should be set as it cannot be retrieved automatically from cloud provider

Before using this configuration, please update any values between angle brackets (`<` and `>`).

- `<DATADOG_API_KEY>`
- `<DATADOG_APP_KEY>`
- `<CLUSTER_NAME>`

# Important distribution-specific configuration options

These are the critical options that must be changed

```yaml
datadog:
  clusterName: <CLUSTER_NAME>
  kubelet:
    tlsVerify: false
agents:
  tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/controlplane
      operator: Exists
    - effect: NoExecute
      key: node-role.kubernetes.io/etcd
      operator: Exists
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#Rancher).
