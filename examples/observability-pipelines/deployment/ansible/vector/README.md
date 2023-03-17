# Overview

This is a simple example that provisions a VM with a Vector Agent with Ansible.

# Vagrant

Currently includes the following VMs which use VirtualBox as the provider. All VMs will by default be installed with a Vector Agent with the default configuration. It will not be running. `vagrant ssh` into the machine to complete setup.

- Ubuntu 20.04
- Ubuntu 18.04
- CentOS 8
- CentOS Stream 8
- CentOS 7

Configure the [Vagrantfile](Vagrantfile) to choose which VMs to create.

Requires Ansible to be installed for VM provisioning.

```bash
vagrant up
vagrant suspend
vagrant destroy
```
