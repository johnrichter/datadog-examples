# Overview

This is an example of how to do very basic File Integrity Monitoring with the Datadog Agent. It watches both the Datadog Agent's main config file as well as [Vector](https://vector.dev) config files. The monitors will alert when these files have been changed.

Among the file stats the directory integration collects is the `modified X seconds ago` metric which is used in the monitors included in this repo — `DatadogAgentConfigMonitor.json` and `VectorConfigMonitor.json`. Metrics are collected every 15 seconds by default, but you can do it every second if you want to by configuring `min_collection_interval`.

1. Copy the integration config file and modify as necessary. Restart the Datadog Agent.
2. [Import the Monitors](https://black-mesa.datadoghq.com/monitors#create/import) into the same Datadog Org where the Agent is sending data.
3. Restrict access to each Monitor to only trusted admins and the security team.
4. Update both Monitor notifications to send alerts to the right communication channels, e.g. Teams, Slack, Email

The idea of these Monitors is to [evaluate the change](https://docs.datadoghq.com/monitors/types/metric/?tab=change) in the file's last modified time in seconds. If a file is modified you'll see a drop equal to the last modified time of the file. This will appear as "negative change" in the monitor so we alert on the minimum value in the [evaluation window](https://docs.datadoghq.com/monitors/configuration/?tab=thresholdalert#evaluation-window). This means that if there is ever a point below zero the Monitor should (and will) alert. You can tweak the timing of the evaluation window to control how long the Monitor will stay in an alert state. In the current configuration it compares the last 5 minutes to the 30 minutes prior. If no data is received, that means that the Datadog Agent isn't reporting data so it might be the case that someone turned off the Agent before updating the config file. The Monitors will alert on this as well.

## Things to be aware of

The Datadog Agent has built in support for [Secrets Management](https://docs.datadoghq.com/agent/guide/secrets-management/?tab=linux). You can use this to load API keys from external sources. This does not protect against someone modifying the config file with a different API key. It does protect against someone reading the API key that might be in the config file as plain text.
