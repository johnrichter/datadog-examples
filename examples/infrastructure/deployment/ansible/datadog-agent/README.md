# Overview

This is a simple example that provisions a VM with a fully configured Datadog Agent with Ansible.

# Vagrant

Currently includes the following VMs which use VirtualBox as the provider. All VMs will by default be installed with a Datadog Agent with the configuration from the [vm all Datadog products enabled](examples/infrastructure/vm-or-bare-metal/with-all-datadog-products-enabled) config.

- Ubuntu 20.04
- Ubuntu 18.04
- CentOS 8
- CentOS Stream 8
- CentOS 7

Configure the [Vagrantfile](Vagrantfile) to choose which VMs to create.

Requires Ansible to be installed for VM provisioning.

```bash
# On first run or when recreating VMs your DD_API_KEY is required
DD_API_KEY="<your key>" vagrant up
vagrant destroy && DD_API_KEY="<your key>" vagrant up

# On subsequent runs when suspending and resuming your DD_API_KEY is not required
vagrant suspend
vagrant up
```
