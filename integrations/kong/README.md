# Kong | Datadog Example

This repo is an example of how to monitor [Kong][kong-site-url] with Datadog. It depends on a few third party open source applications.

- Konga: A lightweight UI built on top of Kong
- An [example Nodejs API](https://github.com/brunormferreira/nodejs-docker)

The example runs entirely in Docker and leverages the offical Docker Compose template for [Kong][kong-site-url].

It leverages both [Kong's built-in Datadog plugin](https://docs.konghq.com/hub/kong-inc/datadog) that sends metrics to the Datadog Agent's Dogstatsd port and [the Datadog Kong integration](https://docs.datadoghq.com/integrations/kong/?tab=host) running within the Datadog Agent which collects metrics from the `/status` and `/metrics` Prometheus open metrics endpoints and logs from the Kong container.

# Build and run

Start Docker and then update the following env variables for the Datadog Agent container in `docker-compose.yml`

```yaml
---
datadog:
  environment:
    DD_API_KEY: <your dd api key>
    DD_ENV: <your env> # dev
    DD_TAGS: <additional tags> # team:devops
```

```bash
$ git clone --recursive github.com:johnrichter/kong-datadog
$ ./init.sh
$ docker compose up
$ curl -X POST http://localhost:8001/plugins/ \
    --data "name=prometheus"
$ curl -X POST -H 'Content-Type: application/json' http://localhost:8001/plugins/ \
    --data '{
      "name": "datadog",
      "config": {
        "host": "datadog-agent",
        "port": 8125,
        "prefix": "kong_plugin",
        "service_name_tag": "service"
      }
    }'
$ curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://example_api:3333/api/pizzas'
$ curl -i -X POST -H 'Content-Type: application/json' \
  --url http://localhost:8001/services/example-service/routes \
  --data '{
    "name": "example-route",
    "paths": ["/example"]
  }'
```

If you prefer you can open Konga on http://localhost:9000 to configure the service instead of leveraging the Kong Admin API. You'll need to create a new connection to Kong in the Konga UI by using `http://kong:8001` or `http://localhost:8001` as the URL.

Send in some traffic and then open Datadog to explore the [`kong.*` metrics](https://app.datadoghq.com/metric/summary?filter=kong.), Kong [Dashboards](https://app.datadoghq.com/dashboard/lists?q=kong), and [Kong logs](https://app.datadoghq.com/logs?query=source%3Akong).

```bash
$ for i in {1..100}; do curl -s localhost:8000/example/; done
```

[kong-site-url]: https://konghq.com/
