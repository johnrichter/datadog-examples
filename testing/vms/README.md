# Overview

Simple barebones VMs that can be created ad-hoc for testing these examples or for testing various Datadog features and functionality

# Vagrant

Currently includes the following VMs which use VirtualBox as the provider. All VMs will by default be installed with a Datadog Agent with the default config running using the Datadog provided install script obtained from the Datadog Agent install guide in-app.

- Ubuntu 20.04
- CentOS 7

```bash
# On first run or when recreating VMs your DD_API_KEY is required
DD_API_KEY="<your key>" vagrant up
vagrant destroy && DD_API_KEY="<your key>" vagrant up

# On subsequent runs when suspending and resuming your DD_API_KEY is not required
vagrant suspend
vagrant up
```
