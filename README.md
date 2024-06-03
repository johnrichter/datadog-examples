# Overview

Configuations in these examples are meant to be used in Datadog trials or as starting points for the configuration of various Datadog packages and products.

> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️
>
> By default many of these examples **turn every feature and product on**. If you do not want this behavior please consult the [Datadog documentation](https://docs.datadoghq.com) to turn off features you do not want to use. In almost every case it should be self explanitory in the example as I've included links to the docs in the examples.
>
> ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️ ⚠️

Other great Datadog example configurations and applications can be found in these repos

- [Jenks Gibbons' Datadog Examples](https://github.com/jgibbons-cp/datadog)
- [Alex Fernandes' Datadog Examples](https://github.com/yafernandes/datadog)
- [Alex Fernandes' Datadog Labs](https://github.com/yafernandes/datadog-experience)
- [Boyan Syarov's Datadog Examples](https://github.com/ncracker?tab=repositories&q=dd)
- [Lloyd Williams' Datadog Examples](https://github.com/lloydwilliams/datadog)
- [Pejman Tabassomi's Datadog Examples](https://github.com/ptabasso2?tab=repositories&q=datadog)
- [Datadog on Databricks](https://github.com/levihernandez/datadog-databricks)
- [Storedog](https://github.com/DataDog/storedog)
  - A complete full-stack app with Datadog monitoring that can be used for testing and playing around with Datadog.
- [eCommerce Workshop](https://github.com/DataDog/ecommerce-workshop)
  - An eCommerce app to demonstrate how to apply observability principles
- [OTEL Recipes](https://otelrecipes.com/recipes)
  - Example apps from the Open Telemetry project that can be instrumented with OTEL/Datadog

## Structure

```bash
.
│   # Scripts to generate deployment diagrams pertaining to
│   # architectures and install flows
├── references
│   # Examples of how to get started with Datadog and
│   # configure Datadog products for various use cases and
│   # requirements
└── examples
```

The test benches that used to exist in this repo have been moved to [test-benches](https://github.com/johnrichter/test-benches).

**This repo uses submodules. Use recursive clone to download all submodules.**

```bash
git clone --recursive git@github.com:johnrichter/datadog-examples.git
```

# TODO

**Hosts**

- Diagrams
  - [ ] Bare metal deployment architecture
  - [ ] Bare metal APM Auto-injection install flow
  - [ ] External Agent (for Databases, SNMP, etc)
- [ ] IOT
- [ ] Proxies
  - Docs
    - [ ] Add details on why you want to just use a web-proxy and not an LB or rev-proxy
  - [x] HAProxy
  - [ ] nginx

**Integrations**

- General
  - Diagrams
    - [ ] Crawler architecture (AWS, GCP, Azure, etc)
    - [ ] Crawler flow (AWS, GCP, Azure, etc)
- Hypervisors
  - vSphere
    - [ ] vSphere integration example
- Config Mangement
  - [ ] Ansible
    - [ ] Installing the Datadog Agent
    - [ ] Monitoring Ansible with the Integrations

**Containers**

- K8s
  - [x] AWS EKS Helm example
  - [x] AWS Outposts
  - [x] GCP GKE Helm example
  - [x] Self Hosted Helm example
  - [x] Mixed OS clusters, multiple helm charts, using one cluster agent for the all
  - [x] Selective node deployments. Taints and Tolerances. Multiple charts. Builds on OS example
  - Service Mesh
    - [ ] Istio and Envoy
  - Diagrams
    - [ ] Deployment architecture
    - [ ] APM Auto-injection install flow
- Docker
  - [ ] Compose example
  - Diagrams
    - [ ] Architecture Diagram
    - [ ] APM Auto-injection install flow

**APM**

- [ ] Update Nodejs example. Service mapping, plugin configuration, latest libs
- [ ] Update PCF example. latest libs
- Library auto injection example
  - [ ] Containers
  - [ ] Host

> Maybe pull examples from these?
>
> - https://github.com/DataDog/trace-examples
> - https://github.com/DataDog/sandbox

**Networking**

- NDM
  - [ ] SNMP Polling
  - [ ] Traps
  - [ ] Netflows
  - [ ] Diagrams for all

**Observability Pipelines**

- [ ] Production deployment on Kubernetes using the Helm chart
  - Diagrams
    - [ ] Architecture Diagram
    - [ ] APM Auto-injection install flow
