# Overview

# Important configuration options

These are the critical options that must be changed

```yaml
datadog:
  criSocketPath: /run/dockershim.sock
  env:
    - name: DD_AUTOCONFIG_INCLUDE_FEATURES
      value: "containerd"
```

More information on the [Datadog documentation](https://docs.datadoghq.com/containers/kubernetes/distributions/?tab=helm#EKS).

# Cluster Checks

To monitor an AWS managed service like MSK, ElastiCache, or RDS, set clusterChecksRunner to create a Pod with an IAM role assigned through the serviceAccountAnnotation in the Helm chart. Then, set the integration configurations under clusterAgent.confd.

```yaml
clusterChecksRunner:
  enabled: true
  rbac:
    # clusterChecksRunner.rbac.create -- If true, create & use RBAC resources
    create: true
    dedicated: true
    serviceAccountAnnotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::***************:role/ROLE-NAME-WITH-MSK-READONLY-POLICY
clusterAgent:
  confd:
    amazon_msk.yaml: |-
      cluster_check: true
      instances:
        - cluster_arn: arn:aws:kafka:us-west-2:*************:cluster/gen-kafka/*******-8e12-4fde-a5ce-******-3
          region_name: us-west-2
```

See the [Datadog documentation](https://docs.datadoghq.com/containers/cluster_agent/setup/?tab=helm#monitoring-aws-managed-services) for more information
