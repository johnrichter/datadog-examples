# Overview

OpenShift comes with hardened security by default (SELinux, SecurityContextConstraints), thus requiring some specific configuration:

- Create SCC for Node Agent and Cluster Agent
- Specific CRI socket path as OpenShift uses CRI-O container runtime
- Kubelet API certificates may not always be signed by cluster CA
- Tolerations are required to schedule the Node Agent on master and infra nodes
- Cluster name should be set as it cannot be retrieved automatically from cloud provider

This configuration supports OpenShift 3.11 and OpenShift 4, but works best with OpenShift 4.

Before using this configuration, please update any values between angle brackets (`<` and `>`).

- `<DATADOG_API_KEY>`
- `<DATADOG_APP_KEY>`
- `<CLUSTER_NAME>`

# Important distribution-specific configuration options

These are the critical options that must be changed

```yaml
datadog:
  clusterName: <CLUSTER_NAME>
  criSocketPath: /var/run/crio/crio.sock
  # Depending on your DNS/SSL setup, it might not be possible to verify the Kubelet cert properly
  # If you have proper CA, you can switch it to true
  kubelet:
    tlsVerify: false
agents:
  podSecurity:
    securityContextConstraints:
      create: true
  tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/master
      operator: Exists
    - effect: NoSchedule
      key: node-role.kubernetes.io/infra
      operator: Exists
clusterAgent:
  podSecurity:
    securityContextConstraints:
      create: true
kube-state-metrics:
  securityContext:
    enabled: false
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#Openshift).
