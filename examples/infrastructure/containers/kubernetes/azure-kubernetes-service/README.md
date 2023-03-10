# Important configuration options

These are the critical options that must be changed

```yaml
datadog:
  kubelet:
    ## As of Agent 7.35, tlsVerify: false is required because Kubelet certificates in AKS do not
    ## have a Subject Alternative Name (SAN) set. In some setups, DNS resolution for spec.nodeName
    ## inside Pods may not work in AKS. This has been reported on all AKS Windows nodes and when
    ## cluster is setup in a Virtual Network using custom DNS on Linux nodes. In this case,
    ## removing the agent.config.kubelet.host field (defaults to status.hostIP) and using
    ## tlsVerify: false is required.
    tlsVerify: false

clusterAgent:
  env:
    ## Admission Controller functionality on AKS requires configuring the add selectors to prevent
    ## an error on reconciling the webhook:
    - name: "DD_ADMISSION_CONTROLLER_ADD_AKS_SELECTORS"
      value: "true"
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#AKS).

Note that the kubelet host option value, `spec.nodeName`, may also need to used instead of `status.hostIP` when
[specifying `DD_AGENT_HOST` on application containers](https://docs.datadoghq.com/agent/kubernetes/apm/?tab=helm#configure-your-application-pods-in-order-to-communicate-with-the-datadog-agent)
instrumented with [Datadog APM and Continuous Profiler](https://docs.datadoghq.com/tracing/).

# Datadog & AKS

`<DATADOG_API_KEY>` and `<DATADOG_APP_KEY>` will need to be replace in the configuration before
using the configuration. If you are having issues with TLS connetions to the Kubelet, set
`datadog.kubelet.tlsVerify` to `false`.

See the [Datadog documentation on Kubernetes Distributions](https://docs.datadoghq.com/containers/kubernetes/distributions) for more information.

# Overview

The config does the following

- Deploy [Agents](https://docs.datadoghq.com/agent/) to every node in the cluster and turn on the following features
  - Enable [Live Processes](https://docs.datadoghq.com/infrastructure/process/?tab=linuxwindows)
  - Enable [Live Containers](https://docs.datadoghq.com/infrastructure/livecontainers/)
  - Enable [log collection](https://docs.datadoghq.com/agent/kubernetes/log/?tab=helm) from all running containers on each host
  - Enable [Application Performance Monitoring trace collection](https://docs.datadoghq.com/agent/kubernetes/apm/?tab=helm) from all running containers on each host
    - Note, you'll still need to [add the Datadog tracing library](https://docs.datadoghq.com/tracing/setup_overview/) to custom applications in order to trace those applications. The Agent only listens for traces from our tracing libraries when you enable this feature.
  - Enable [Network Performance Monitoring](https://docs.datadoghq.com/network_monitoring/performance/setup/?tab=kubernetes)
- Deploy a [Cluster Agent](https://docs.datadoghq.com/agent/cluster_agent/) in non-HA mode (see replicas option to enable HA)
  - Enable [Cluster Checks](https://docs.datadoghq.com/agent/cluster_agent/clusterchecks/)
  - Enable [Endpoint Checks](https://docs.datadoghq.com/agent/cluster_agent/endpointschecks/)
  - [Add Datadog as a metrics provider](https://docs.datadoghq.com/agent/cluster_agent/external_metrics/?tab=helm) for [pod autoscaling](https://www.datadoghq.com/blog/autoscale-kubernetes-datadog/)
