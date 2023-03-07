from datadog_api_client import initialize, api
import json

# Initialize request parameters with Datadog API/APP key
options = {"api_key": "<DD_API_KEY>", "app_key": "<DD_APP_KEY>"}

initialize(**options)

# Create an embed graph definition as a dict and format as JSON
graph_json = {
    "requests": [{"q": "avg:trace.{$var}"}],
    "viz": "timeseries",
    "events": [],
}
graph_json = json.dumps(graph_json)

print(
    api.Embed.create(
        graph_json=graph_json, timeframe="1_hour", size="medium", legend="no"
    )
)
