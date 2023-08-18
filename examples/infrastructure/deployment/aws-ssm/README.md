# TODO: Complete

The trickiest part comes down to configuration of the Datadog Agent. Installation will be straight forward and we document that [here](https://docs.datadoghq.com/integrations/amazon_ec2/#install-the-agent-with-aws-systems-manager). The main section to care about from our [OOTB command document](https://docs.datadoghq.com/resources/json/dd-agent-install-us-site.json) is this one

```json
"runCommand":[
  "wget -O ddinstall.sh https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh",
  "export DD_API_KEY=$(aws --region <AWS_REGION> ssm get-parameters --names dd-api-key-for-ssm --with-decryption --query Parameters[].Value --output text)",
  "bash ./ddinstall.sh"
]
```

That runs the standard install script and populates the API key from SSM. The agent service will be started with the default config.

There are three main config files that the Agent uses

- `/etc/datadog-agent/datadog.yaml`
- `/etc/datadog-agent/system-probe.yaml`
- `/etc/datadog-agent/security-agent.yaml`

Integration configs are stored in the `/etc/datadog-agent/conf.d` folder so depending on what you want to turn on you could need to specify those as well.

It really comes down to creating or populating those files somehow. Best options come down to

- Creating a script that modifies or creates the config files and restarts the agent
- Copying pre-set config files from somewhere like S3

For each option you could store micro-conf or script files in S3 and use them to conditionally build the full config for new and existing instances

## S3

## Script

For the script option this might look like

```bash
"aws s3 cp s3://<S3_BUCKET_NAME>/<some path>/configure-datadog.sh /tmp/",
"/tmp/configure-datadog.sh",
```

Where the script looks something like this

```bash
#!/bin/env -S bash -ex

sudo sudo cp /etc/datadog-agent/datadog.yaml.example /etc/datadog-agent/datadog.yaml
sudo sed -i '/^api_key:/c\api_key: <API_KEY>' /etc/datadog-agent/datadog.yaml

# Enabling Logs
sudo sed -i 's/# logs_enabled: false/logs_enabled: true/' /etc/datadog-agent/datadog.yaml

# Enabling container log collection
sudo sed -i 's/# logs_config:/logs_config:/' /etc/datadog-agent/datadog.yaml
sudo sed -i 's/  # container_collect_all: false/  container_collect_all: true/' /etc/datadog-agent/datadog.yaml

sudo systemctl restart datadog-agent
```

Or something like this

```bash
#!/bin/env -S bash -ex

datadog_yaml="
api_key: <API_KEY>
inventories_configuration_enabled: true
logs_enabled: $SOME_ENV_VAR
apm_config:
  enabled: $SOME_ENV_VAR
process_config:
  process_collection:
    enabled: $SOME_ENV_VAR
  container_collection:
    enabled: $SOME_ENV_VAR
"
sudo touch /etc/datadog-agent/datadog.yaml
sudo chown dd-agent:dd-agent /etc/datadog-agent/datadog.yaml
sudo chmod 640 /etc/datadog-agent/datadog.yaml
echo "${datadog_yaml}" | sudo tee -a /etc/datadog-agent/datadog.yaml
sudo systemctl restart datadog-agent
```
