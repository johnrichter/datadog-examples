# Overview

Configuations in these examples are meant to be used in Datadog trials or as starting points for the configuration of various Datadog packages and products.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> By default many of these examples **turn every feature and product on**. If you do not want this behavior please consult the [Datadog documentation](https://docs.datadoghq.com) to turn off features you do not want to use. In almost every case it should be self explanitory in the example as I've included links to the docs in the examples.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️

# Cloning

This repo uses submodules. Use recursive clone to download all submodules.

```bash
git clone --recursive git@github.com:johnrichter/datadog-examples.git
```

# TODO

Containers

- K8s
  - [ ] AWS EKS Helm example
  - [ ] GCP GKE Helm example
  - [ ] Self Hosted Helm example
- Docker
  - [ ] Compose example

Hypervisors

- vSphere
  - [ ] vSphere integration example
  - [ ] Terraform to set up home lab vSphere cluster

Config Mangement

- [ ] Ansible
  - [ ] Installing the Datadog Agent
  - [ ] Monitoring Ansible with the integration

Deployment Diagrams

- Architecture
  - [ ] Host Agent
  - [ ] Docker
  - [ ] K8s
  - [ ] External Agent (for Databases, SNMP, etc)
  - [ ] NDM (polling, traps, and netflows)
  - [ ] Crawler integrations (AWS, GCP, Azure, etc)
- Flows
  - [ ] APM Auto-injection
    - [ ] Container-based
    - [ ] Host-based
  - [ ] Crawler integrations (AWS, GCP, Azure, etc)
