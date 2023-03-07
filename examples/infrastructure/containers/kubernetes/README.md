# Overview

There are three ways to install Datadog to a Kubernetes cluster. All of the examples in this repository use Helm. Helm is the **recommended** way to install Datadog to a Kubernetes cluster.

1. Datadog Operator (Beta)
2. Helm
3. DaemonSet

**Datadog Operator**

The Datadog docs default to use the Datadog Operator. Do not forget to click the Helm tab when browsing. The Operator is still in development and does not support all options for customizing and configuring both the Datadog Agent and the Datadog Cluster Agent. It'll only really work well for very _basic_, out-of-the-box Datadog deployments.

**DaemonSet**

Kubernetes is a complex system and as a result so is monitoring it. That means that the full set of Datadog resources, deployment, and manifests required to configure Datadog on Kubernetes is no small feat. DaemonSets are great for learning Kubernetes, but highly error prone and have a high maintainence (due to their nature in Kubernetes) as new Datadog features are released, configuration options change, capabilities evolve, and much more. Use Helm to understand this configuration as higher order concepts while maintaining the ability to configure exactly what you need.

# Distributions

Every hosted version of Kubernetes always has some sort of specific nouance that is unique to that platform. For a full list on how to adjust for these various distributions please check out [this guide](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm) in the Datadog documentation.

Examples for these various distributions will include these customizations and you won't need to adjust them. All other examples, unless specified in their respective README, **will not** account for these customizations and you may need to include them if you are deploying to a specific distribution.

# Examples

Note that each Helm Chart values file includes a comment at the top which contains the Datadog chart version used at time the example was prepared. The filename will also include the Helm Chart version as a precaution. Options may change over time as the Charts are updated and Datadog releases new features.

# Installation

For instructions on how to use these example configurations, please consult the [Datadog Kubernetes installation documentation](https://docs.datadoghq.com/containers/kubernetes/installation/?tab=helm).
