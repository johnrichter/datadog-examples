# Overview

This example shows how to build multiple Datadog Helm Chart value files to target subgroups of nodes using Taints and Tolerances.

In the case where you need to deploy two charts to the same cluster for any reason, e.g. multiple OS used across the subgroups of nodes, it also shows how to properly have only a single Cluster Agent deployment managing the full fleet, irregardless of what the node is.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> These charts must be deployed in order and the values files are named accordingly. The first chart creates the cluster agent and deploys node agents to just nodes that match its selectors. The second chart creates node agents on just nodes that match its selectors and has them join the Cluster Agent deployed in the first chart.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
