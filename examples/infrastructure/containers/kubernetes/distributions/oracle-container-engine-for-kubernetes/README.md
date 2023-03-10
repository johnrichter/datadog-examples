# Overview

No specific configuration is required.

To enable container monitoring, add the following (containerd check):

Before using this configuration, please update any values between angle brackets (`<` and `>`).

- `<DATADOG_API_KEY>`
- `<DATADOG_APP_KEY>`
- `<CLUSTER_NAME>`

# Important distribution-specific configuration options

These are the critical options that must be changed

```yaml
datadog:
  criSocketPath: /run/dockershim.sock
  env:
    - name: DD_AUTOCONFIG_INCLUDE_FEATURES
      value: "containerd"
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#OKE).
