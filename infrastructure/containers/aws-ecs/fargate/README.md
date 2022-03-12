# Datadog & AWS ECS Fargate

To monitor containers running in ECS Fargate we need to deploy a Datadog Agent as a sidecar
container.

## Overview

This config enables every feature supported by the Datadog Agent using this pattern in Fargate.
See the Datadog Agent container and custom app container definitions in the task for more details.

- [Live Processes](https://docs.datadoghq.com/infrastructure/process)
- [Live Containers](https://docs.datadoghq.com/infrastructure/livecontainers)
- [Log Collection](https://docs.datadoghq.com/logs/log_collection) via [AWS Firelens and Fluentbit](https://docs.datadoghq.com/integrations/ecs_fargate/?tab=fluentbitandfirelens#log-collection)
- [Application Performance Monitoring](https://docs.datadoghq.com/tracing/)
  - Requires [APM library installation](https://docs.datadoghq.com/integrations/ecs_fargate/?tab=fluentbitandfirelens#trace-collection) within the custom application.
- [Continuous Profiling](https://docs.datadoghq.com/tracing/profiler/)
  - Requires [APM library installation](https://docs.datadoghq.com/integrations/ecs_fargate/?tab=fluentbitandfirelens#trace-collection) within the custom application.

Note that for APM and Profiling please see the compatibility documentation
[here](https://docs.datadoghq.com/tracing/setup_overview/compatibility_requirements/java/) and
[here](https://docs.datadoghq.com/tracing/profiler/enabling/java/) respectively.

### Replacements

This config contains several AWS account specific settings and environment variables that require
values from your own setup before deploying.

ECS Task Specific

- `<YOUR ECS EXECUTION ARN>`
- `<TASK NAME>`
- `<AWS REGION>`
- `<YOUR MEMORY SETTING>`
- `<YOUR CPU SETTING>`

Custom App Specific

- `<YOUR CUSTOM APP IMAGE>`: The image for your custom app

Shared

- `<DD API KEY>`
  - Obtain from `___.datadoghq.___/organization-settings/api-keys`
    - Replace the domain with the domain you use to access Datadog
- `<DD SITE>`
  - Can be one of the following values. Consult the URL you use to access Datadog to choose the appropriate value.
    - `datadoghq.com`
    - `datadoghq.eu`
    - `us3.datadoghq.com`
    - `us5.datadoghq.com`
- `<ENV>`
  - This is an important tag that is integral to [Datadog's Unified Service Tagging standard](https://docs.datadoghq.com/getting_started/tagging/unified_service_tagging).
  - Examples: `prod`, `dev`, `qa`, `local`, `test`
- `<CUSTOM TAGS>`
  - These can be any tags important to this environment and can represent any concepts that you wish to capture for the task.
  - You must format the values of these tags to [the requirements here](https://docs.datadoghq.com/getting_started/tagging/#defining-tags)
  - Example: `team:data-science,department:compliance`
- `<SERVICE NAME>`: The name of your service as it appears in Datadog.
  - Note: it is a best practice to name the service the same across different environments and
    accounts. Instead, set those via `<ENV>` and `<CUSTOM TAGS>`.
- `<VERSION>`: The version of the custom application. Unlocks
  [Deployment Tracking](https://docs.datadoghq.com/tracing/deployment_tracking/). Keep updated with
  the current deployed version of your application for best results.
- `<SERVICE MAPPING>`: Define service name mappings to allow renaming services in traces. Specify an
  empty string or remove the variable if you do not want to use.
  - Example: `postgres:postgresql,defaultdb:postgresql`
