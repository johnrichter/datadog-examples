# Datadog & AKS

`<DATADOG_API_KEY>` and `<DATADOG_APP_KEY>` will need to be replace in the configuration before
using the configuration. If you are having issues with TLS connetions to the Kubelet, set
`datadog.kubelet.tlsVerify` to `false`.

The following versions were used for this configuration of the Datadog Helm chart

```bash
> helm search repo | grep datadog
datadog/datadog                      	2.28.5       	7                      	Datadog Agent
datadog/datadog-crds                 	0.4.6        	1                      	Datadog Kubernetes CRDs chart
datadog/datadog-operator             	0.7.6        	0.7.2                  	Datadog Operator
```

## Overview

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

Take a look at the kubelet host option and note that `spec.nodeName` will also need to used instead of `status.hostIP` when
[specifying `DD_AGENT_HOST` on application containers](https://docs.datadoghq.com/agent/kubernetes/apm/?tab=helm#configure-your-application-pods-in-order-to-communicate-with-the-datadog-agent)
instrumented with [Datadog APM and Continuous Profiler](https://docs.datadoghq.com/tracing/).
