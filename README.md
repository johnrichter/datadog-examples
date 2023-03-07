# Overview

Configuations in these examples are meant to be used in Datadog trials or as starting points for the configuration of various Datadog packages and products.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> By default many of these examples **turn every feature and product on**. If you do not want this behavior please consult the [Datadog documentation](https://docs.datadoghq.com) to turn off features you do not want to use. In almost every case it should be self explanitory in the example as I've included links to the docs in the examples.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️

## Structure

```bash
.
├   # Scripts to generate deployment diagrams pertaining to
├   # architectures and install flows
├── diagrams
├   # Examples of how to get started with Datadog and
├   # configure Datadog products for various use cases and
├   # requirements
├── examples
├   # Simple lab environments that can be used for testing
├   # the provided examples and other Datadog products
└── testing
```

This repo uses submodules. Use recursive clone to download all submodules.

```bash
git clone --recursive git@github.com:johnrichter/datadog-examples.git
```

# TODO

## Examples

**Hosts**

- Diagrams
  - [ ] Bare metal deployment architecture
  - [ ] Bare metal APM Auto-injection install flow
  - [ ] External Agent (for Databases, SNMP, etc)

**Integrations**

- General
  - Diagrams
    - [ ] Crawler architecture (AWS, GCP, Azure, etc)
    - [ ] Crawler flow (AWS, GCP, Azure, etc)
- Hypervisors
  - vSphere
    - [ ] vSphere integration example
    - [ ] Terraform to set up home lab vSphere cluster
- Config Mangement
  - [ ] Ansible
    - [ ] Installing the Datadog Agent
    - [ ] Monitoring Ansible with the Integrations

**Containers**

- K8s
  - [ ] AWS EKS Helm example
  - [ ] GCP GKE Helm example
  - [ ] Self Hosted Helm example
  - Diagrams
    - [ ] Deployment architecture
    - [ ] APM Auto-injection install flow
- Docker
  - [ ] Compose example
  - [ ] Testing environment
  - Diagrams
    - [ ] Architecture Diagram
    - [ ] APM Auto-injection install flow

**Networking**

- NDM
  - [ ] SNMP Polling
  - [ ] Traps
  - [ ] Netflows
  - [ ] Diagrams for all

## Testing labs

- [ ] Docker
- [ ] vSphere
- [ ] Kubernetes
