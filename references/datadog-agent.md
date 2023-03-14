# Getting the default cluster agent config

1. Clone the Agent repo and `cd` into it
2. Change to the latest tag, e.g. `7.43.0`
3. Get the deps with `go mod tidy`
4. Run the following command to generate the config.
   ```bash
   go run ./pkg/config/render_config.go agent-py3 ./pkg/config/config_template.yaml ./datadog.yaml
   ```
5. Profit
