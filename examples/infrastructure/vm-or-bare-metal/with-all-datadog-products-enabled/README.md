# Overview

Default configuration with all Datadog features and products enabled. The default configurations within should work with any linux based system running kernel version 4.15.0+ or has eBPF features backported to match. There are a few OS-specific customizations that are required and noted below.

# Linux (Kernel versions >4.4, <4.15)

```yaml
# system-probe.yaml

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

```yaml
#  security-agent.yaml

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

# Linux (Kernel versions >4.4, <4.14)

```yaml
# system-probe.yaml

# Universal Service Monitoring requires v4.14.0+
service_monitoring_config:
  enabled: false

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

```yaml
#  security-agent.yaml

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

# Linux (Kernel versions <4.4.0)

```yaml
# system-probe.yaml

# Network Performance Monitoring requires v4.4.0+
network_config:
  enabled: false

# Universal Service Monitoring requires v4.14.0+
service_monitoring_config:
  enabled: false

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

```yaml
#  security-agent.yaml

# Cloud Workload Security requires v4.15.0+
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

# Windows (>2012 R2)

Make sure the network device driver [sub-package is installed](https://docs.datadoghq.com/network_monitoring/performance/setup/?tab=agentwindows#setup) with the Datadog Agent. This is an option in the GUI installer as well as on the command line if running `msiexec` directly.

```yaml
# system-probe.yaml

# Cloud Workload Security does not yet support Windows
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

```yaml
#  security-agent.yaml

# Cloud Workload Security does not yet support Windows
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

# Windows (<2012 R2)

```yaml
# system-probe.yaml

# Network Performance Monitoring requires 2012 R2+
network_config:
  enabled: false

# Universal Service Monitoring requires 2012 R2+
service_monitoring_config:
  enabled: false

# Cloud Workload Security does not yet support Windows
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

```yaml
#  security-agent.yaml

# Cloud Workload Security does not yet support Windows
runtime_security_config:
  enabled: false
  fim_enabled: false
  network:
    enabled: false
```

# macOS

TODO
