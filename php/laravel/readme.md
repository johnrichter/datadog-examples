This repository is a example of how to instrument a PHP 8 and Laravel 8 application at every layer
and have all telemetry correlate in single views across the Datadog platform.

- Frontend HTML/JS -- Real User Monitoring
- Backend APIs -- Application Performance Monitoring and Continuous Profiling
- Logging -- Log Management and Logging without Limits
- Infrastructure -- VMs, Docker, Live Containers, K8s, and more

The example application is from the [Centrifugal example library](https://github.com/centrifugal/examples/tree/master/php_laravel_chat_tutorial)
on Github. It is based on [this Centrifugal blog article](https://centrifugal.dev/blog/2021/12/14/laravel-multi-room-chat-tutorial). 

![demo](https://raw.githubusercontent.com/centrifugal/examples/master/php_laravel_chat_tutorial/demo.gif)

# Quickstart

Replace all Datadog configuration variables in the following files with values from your Datadog account.
Don't have a Datadog account? [Open a free 14 day trial!](https://www.datadoghq.com/free-datadog-trial/)

- docker-compose.yml (`services.datadog.environment`)
  - API key can be found [here](https://app.datadoghq.com/organization-settings/api-keys)
- ./app/resources/views/layouts/app.blade.php (`window.DD_RUM.init(...)`)
  - Create a RUM app and get the new arguments to the function [here](https://app.datadoghq.com/rum/list)

> Note the [compatibility requirements](https://docs.datadoghq.com/tracing/setup_overview/compatibility_requirements/php) for the best experience.

## Run

```bash
docker compose up
```

Open http://localhost/

# Datadog Agent

Collection of all non-browser telemetry happens via the Datadog Agent. All metrics, logs, and traces from this
demo are collected by the agent automatically and shipped to Datadog. This includes

- [Host metrics from the VM](https://docs.datadoghq.com/infrastructure/) and [any services operating on the host](https://docs.datadoghq.com/integrations/)
- [Live Processes](https://docs.datadoghq.com/infrastructure/process/?tab=linuxwindows)
- [Live Containers](https://docs.datadoghq.com/infrastructure/livecontainers/)
- [K8s](https://docs.datadoghq.com/agent/kubernetes/?tab=helm) (not in this example)
- [Network Performance Data](https://docs.datadoghq.com/network_monitoring/)
- [And more](https://docs.datadoghq.com/agent/)

Since we're running this example in Docker, we're running the Agent in a container as well. You'll
need to specify the variables with placeholders in `docker-compose.yml`. API key can be found
[here](https://app.datadoghq.com/organization-settings/api-keys). Snippet below.

```yaml
services:
  datadog:
    container_name: datadog-agent
    image: gcr.io/datadoghq/agent:7
    environment:
      ## GLOBALS
      DD_API_KEY: <api key> # https://app.datadoghq.com/organization-settings/api-keys
      DD_ENV: <env> # dev
      DD_TAGS: "<tags>" # team:devops
      DD_AC_EXCLUDE: name:datadog-agent # exclude this container from data collection
      ## TAGS https://docs.datadoghq.com/getting_started/tagging/assigning_tags/?tab=containerizedenvironments
      DD_DOCKER_LABELS_AS_TAGS: '{"*":"%%label%%"}'
      ## LOGS https://docs.datadoghq.com/agent/docker/log/
      DD_LOGS_ENABLED: true
      DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL: true
      ## LIVE PROCESSES https://docs.datadoghq.com/graphing/infrastructure/process/?tab:docker
      DD_PROCESS_AGENT_ENABLED: true
      ## DOGSTATSD
      DD_DOGSTATSD_NON_LOCAL_TRAFFIC: true
      ## APM
      DD_APM_ENABLED: true
      DD_APM_NON_LOCAL_TRAFFIC: true
      ## Network Performance Monitoring.
      ## Running this on a Mac? Set this value to false
      DD_SYSTEM_PROBE_ENABLED: true
    security_opt:
      - apparmor:unconfined
    cap_add:
      - SYS_ADMIN
      - SYS_RESOURCE
      - SYS_PTRACE
      - NET_ADMIN
      - NET_BROADCAST
      - NET_RAW
      - IPC_LOCK
      - CHOWN
    ports:
      - 127.0.0.1:8125:8125/udp # Dogstatsd
      - 127.0.0.1:8126:8126/tcp # APM
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /proc/:/host/proc/:ro
      - /sys/fs/cgroup:/host/sys/fs/cgroup:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /etc/passwd:/etc/passwd:ro # Live Processes
      - /sys/kernel/debug:/sys/kernel/debug # NPM
      - ./data/agent/conf.d:/conf.d:rw
      - ./data/logs:/data/logs:rw
    networks:
      - app
```

# RUM ([Docs](https://docs.datadoghq.com/real_user_monitoring/browser/))

To monitor user actions and interactions between the frontend and the backend, modify
`./app/resources/views/layouts/app.blade.php` with the RUM Application config from Datadog. It
looks like this

```html
<script
  src="https://www.datadoghq-browser-agent.com/datadog-rum-v4.js"
  type="text/javascript"
  crossorigin="anonymous"
></script>
<script>
  // Create these values -- https://app.datadoghq.com/rum/list
  window.DD_RUM &&
    window.DD_RUM.init({
      applicationId: "<appId>",
      clientToken: "<clientToken>",
      site: "datadoghq.com",
      // The name of the frontend as you want it to appear in when correlated with backend APM traces
      // e.g. laravel-frontend
      service: "<service>",
      env: "<env>", // The deployment environment. prod, stage, dev, local, etc
      // Specify a version number to identify the deployed version of your application in Datadog.
      // Just a string. Doesn't have to be semver
      version: "1.0.0",
      sampleRate: 100,
      trackInteractions: true,
      defaultPrivacyLevel: "mask-user-input",
      // This defines what URLs RUM will generate trace identifiers for when running HTTP calls to
      // external services and other APIs. If the service is also traced the traces will be merged
      // so you can see the whole picture in one flame graph and more accurately depict system dependencies.
      // https://docs.datadoghq.com/real_user_monitoring/connect_rum_and_traces?tab=browserrum
      allowedTracingOrigins: [
        /https?:\/\/localhost/,
        /https?:\/\/centrifugo:8001/,
        /https?:\/\/nginx/,
      ],
    });
  window.DD_RUM && window.DD_RUM.startSessionReplayRecording();
</script>
```

# APM ([Docs](https://docs.datadoghq.com/tracing/setup_overview/setup/php/))

Monitoring PHP API calls and other activity happens through a PHP extension. Custom tracing and
enrichment of OOTB traces via span tags can be done using the [Datadog Tracer API documented here](https://docs.datadoghq.com/tracing/setup_overview/custom_instrumentation/php).

The extension is added as a part of the container image in `docker/Dockerfile` and you won't need to
change anything for it to work. The relevant snippet is below.

```bash
  ...
  # Add APM and Profiling for PHP apps
  && apk add libexecinfo \
  && mkdir -p /etc/datadog \
  # 0.69.0 is the latest version of the tracer as of 20220202 and is the first version to include
  # profililng support (in public beta).
  && curl -L https://github.com/DataDog/dd-trace-php/releases/download/0.69.0/datadog-setup.php -o /etc/datadog/datadog-setup.php \
  # For the purposes of this example, the php-fpm install is for the app
  && php '/etc/datadog/datadog-setup.php' '--enable-profiling' '--php-bin=php-fpm' \
  # and the php install is for the demo-script. In practice only one should be necessary
  && php '/etc/datadog/datadog-setup.php' '--enable-profiling' '--php-bin=php'
```

## Bonus

Datadog can also [trace PHP CLI tools](https://docs.datadoghq.com/tracing/setup_overview/setup/php/?tab=containers#tracing-cli-scripts).
`app/demo-script.php` is an example of how to use the Datadog Tracer API to add additional context as
well as [**inject trace identifiers into logs to allow for automatic correlation of logs and traces**](https://docs.datadoghq.com/tracing/connect_logs_and_traces/php/).

To run it just call

```bash
docker compose exec -e DD_TRACE_CLI_ENABLED=true -e DD_SERVICE=demo-script app php demo-script.php
```

# Logging ([Docs](https://docs.datadoghq.com/logs/log_collection/php/))

Logging in Datadog is best done by using structured logs. This repository contains and example in
`app/demo-script.php` on how to set up JSON logging with Monolog. Consult the documentation for more
advanced usages.

**Be sure to review** the [Connecting Logs to Traces Documentation](https://docs.datadoghq.com/tracing/connect_logs_and_traces/php/) to correlate logs to traces in Datadog.

[Monolog uses a specific structure](https://github.com/Seldaek/monolog/blob/main/doc/message-structure.md)
to its logs so be sure to update your [PHP Log Pipeline](https://app.datadoghq.com/logs/pipelines/pipeline/library) to account
for the differences. Out of the box the Pipeline ([docs](https://docs.datadoghq.com/logs/log_configuration/pipelines/?tab=source))
will process the k:v text logs and convert them to structure logs usable in the Datadog platform.

1. Add a [Date Remapper](https://docs.datadoghq.com/logs/log_configuration/processors/?tab=ui#log-date-remapper) using `datetime` as the target attribute
2. Add a [Status Remapper](https://docs.datadoghq.com/logs/log_configuration/processors/?tab=ui#log-status-remapper) using `level_name` as the target attribute
