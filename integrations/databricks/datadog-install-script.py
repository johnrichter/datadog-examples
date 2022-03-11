# Databricks notebook source
# MAGIC %sh
# MAGIC hostip=$(hostname -I | xargs)
# MAGIC echo "IP: ${hostip}"
# MAGIC echo """
# MAGIC DD_SITE=${DD_SITE}
# MAGIC DD_ENV=${DD_ENV}
# MAGIC DD_API_KEY=${DD_API_KEY}
# MAGIC DD_TAGS=${DD_TAGS}
# MAGIC CUSTOM_DD_TAGS=${CUSTOM_DD_TAGS}
# MAGIC host_ip: ${hostip}
# MAGIC databricks_cluster_id: ${DB_CLUSTER_ID}
# MAGIC databricks_cluster_name: ${DB_CLUSTER_NAME}
# MAGIC user: """ $(whoami)

# COMMAND ----------

# MAGIC %python
# MAGIC # This cell creates an `datadog-install-driver-workers.sh` init script to dbfs. It requires that the
# MAGIC # user running this cell has the Databricks admin role.
# MAGIC
# MAGIC # The name of the dbfs directory where the Datadog init script will be stored
# MAGIC initdir = "datadog"
# MAGIC
# MAGIC dbutils.fs.put("dbfs:/"+initdir+"/datadog-install-driver-workers.sh","""
# MAGIC #!/bin/bash
# MAGIC
# MAGIC #######################################################
# MAGIC ##########             FORWARD               ##########
# MAGIC #######################################################
# MAGIC # This init script will install a Datadog agent on all nodes, driver and worker, in a Databricks cluster.
# MAGIC # It can be also used as a global init script, but requires environment variables to be hard coded as there
# MAGIC # is no way to specify global environment variables globally. Variables which need to be uncommendeted and
# MAGIC # hard coded for this use case are in the "Customizable Environment Vars" section below.
# MAGIC #
# MAGIC # Driver-node-specific configuration
# MAGIC #   * Configures a sensible default set of tags: databricks_cluster_id, databricks_cluster_name, spark_node
# MAGIC #   * Configures the Datadog agent using the cluster environment variables
# MAGIC #   * Enables Log collection and Live Processes
# MAGIC #     * Disable Log Collection by setting the `Enable Log Collection` section to `false`
# MAGIC #     * Disable Live Processes by setting the `Enable Live Processes` section to `'false'`
# MAGIC #   * Configures the Datadog Agent's Spark integration to
# MAGIC #     * Collect metrics from the Spark API
# MAGIC #     * Collect Spark logs
# MAGIC #     * Collect Databricks logs
# MAGIC #
# MAGIC # Worker-node-specific configuration
# MAGIC #   * Configures a sensible default set of tags: databricks_cluster_id, databricks_cluster_name, spark_node
# MAGIC #   * Configures the Datadog agent using the cluster environment variables
# MAGIC #   * Enables Live Processes
# MAGIC #     * Disable Live Processes by setting the `Enable Live Processes` section to `'false'`
# MAGIC #
# MAGIC # Environment variables
# MAGIC #   * DD_SITE (required)
# MAGIC #     * Can be one of the following values. Consult the URL you use to access Datadog to choose the appropriate value.
# MAGIC #       * datadoghq.com
# MAGIC #       * datadoghq.eu
# MAGIC #       * us3.datadoghq.com
# MAGIC #       * us5.datadoghq.com
# MAGIC #   * DD_API_KEY (required)
# MAGIC #     * Obtain from ___.datadoghq.___/organization-settings/api-keys (replace domain with the domain you use to access Datadog)
# MAGIC #   * DD_ENV (required)
# MAGIC #     * This is an important tag that is integral to Datadog's Unified Service Tagging standard.
# MAGIC #       * https://docs.datadoghq.com/getting_started/tagging/unified_service_tagging?tab=kubernetes
# MAGIC #     * Examples: prod, dev, qa, local, test
# MAGIC #   * CUSTOM_DD_TAGS (optional)
# MAGIC #     * These can be any tags important to this environment and can represent any concepts that you wish to capture for the Databricks cluster.
# MAGIC #     * You must format the values of these tags to the requirements here - https://docs.datadoghq.com/getting_started/tagging/#defining-tags
# MAGIC #     * The script requires you to format the tags as comma separated key:value pairs. The full value must be surrounded in quotes due to bash
# MAGIC #       processing syntax
# MAGIC #     * Example: "team:data-science,department:compliance"
# MAGIC #
# MAGIC # Notes and considerations
# MAGIC #   * The script requires that your clusters have access to the internet to download https://s3.amazonaws.com/dd-agent/scripts/install_script.sh.
# MAGIC #     This install_script.sh will install the Datadog Agent using the best method for the target OS. For Debian, this adds Datadog GPG keys, installs
# MAGIC #     the Datadog APT repo, apt installs the dependencies of the Datadog Agent, and installs the Datadog Agent from the Datadog repo.
# MAGIC #       * In instances of a private cluster, you'll need to host the Datadog Agent package and its dependencies in an internal repo, make the installers
# MAGIC #         accessible as deb packages, or provide another way to install these packages without downloading them from the internet. Lines containing the
# MAGIC #         install_script.sh URL above will need to be replaced with the install method of your choice.
# MAGIC
# MAGIC ########################################################
# MAGIC ########## Create Datadog Installation Script ##########
# MAGIC ########################################################
# MAGIC
# MAGIC cat <<EOF >> /tmp/start_datadog.sh
# MAGIC
# MAGIC #!/bin/bash
# MAGIC
# MAGIC #######################################################
# MAGIC ##########   Customizable Environment Vars   ##########
# MAGIC #######################################################
# MAGIC
# MAGIC ## For Global Init Script deployments, uncomment the variables below and hard code their values
# MAGIC ## For cluster based configs, add the same variables to the cluster Advanced Options > Environment Variables
# MAGIC # DD_SITE=<dd-site>       # Required
# MAGIC # DD_API_KEY=<dd-api-key> # Required
# MAGIC # DD_ENV=<env>            # Required
# MAGIC # CUSTOM_DD_TAGS="<comma separated k:v pairs>" # Optional
# MAGIC
# MAGIC #######################################################
# MAGIC ##########   Initialize required variables   ##########
# MAGIC #######################################################
# MAGIC
# MAGIC hostip=$(hostname -I | xargs)
# MAGIC echo "host_ip: ${hostip}, databricks_cluster_id: ${DB_CLUSTER_ID}, databricks_cluster_name: ${DB_CLUSTER_NAME}, user: "$(whoami)
# MAGIC
# MAGIC #######################################################
# MAGIC ##########    Installation on Driver Node    ##########
# MAGIC #######################################################
# MAGIC
# MAGIC if [[ \${DB_IS_DRIVER} = "TRUE" ]]; then
# MAGIC
# MAGIC   echo "Installing Datadog agent in the driver (master node) ..."
# MAGIC
# MAGIC   ##########################################
# MAGIC   #        Datadog Agent Installation      #
# MAGIC   ##########################################
# MAGIC
# MAGIC   # Configure Datadog Agent host tags for the Driver. These tags inlude the custom tags set up in our environment variables
# MAGIC   DD_TAGS="databricks_cluster_id:\${DB_CLUSTER_ID}","databricks_cluster_name:\${DB_CLUSTER_NAME}","spark_node:driver","${CUSTOM_DD_TAGS}"
# MAGIC
# MAGIC   # Datadog Agent v7 (latest)
# MAGIC   DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=\${DD_API_KEY} DD_SITE=\${DD_SITE} DD_HOST_TAGS=\${DD_TAGS} bash -c "\$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
# MAGIC
# MAGIC   # Wait for the Datadog Agent to be installed
# MAGIC   while [ -z \$datadoginstalled ]; do
# MAGIC     if [ -e "/etc/datadog-agent/datadog.yaml" ]; then
# MAGIC       datadoginstalled=TRUE
# MAGIC     fi
# MAGIC     sleep 2
# MAGIC   done
# MAGIC   echo "Datadog Agent is installed"
# MAGIC
# MAGIC   ##########################################
# MAGIC   #   Create custom Datadog Agent config   #
# MAGIC   ##########################################
# MAGIC
# MAGIC   echo "api_key: \${DD_API_KEY}
# MAGIC site: \${DD_SITE}
# MAGIC tags: [\${DD_TAGS}]
# MAGIC env: \${DD_ENV}
# MAGIC # Enable Live Processes
# MAGIC process_config:
# MAGIC     enabled: 'true'
# MAGIC # Enable Log Collection
# MAGIC logs_enabled: true" > /etc/datadog-agent/datadog.yaml
# MAGIC
# MAGIC   ##########################################
# MAGIC   # Create custom Spark integration config #
# MAGIC   ##########################################
# MAGIC
# MAGIC   # Discover the port that Spark is using on the Driver node
# MAGIC   while [ -z \$gotparams ]; do
# MAGIC     if [ -e "/tmp/driver-env.sh" ]; then
# MAGIC       DB_DRIVER_PORT=\$(grep -i "CONF_UI_PORT" /tmp/driver-env.sh | cut -d'=' -f2)
# MAGIC       gotparams=TRUE
# MAGIC     fi
# MAGIC     sleep 2
# MAGIC   done
# MAGIC
# MAGIC   # Creating config file for Spark integration with structured stream metrics ENABLED.
# MAGIC   # You can modify this section with more Spark integration options. For all available options see
# MAGIC   # https://github.com/DataDog/integrations-core/blob/master/spark/datadog_checks/spark/data/conf.yaml.example
# MAGIC
# MAGIC   echo "init_config:
# MAGIC instances:
# MAGIC     - spark_url: http://\${DB_DRIVER_IP}:\${DB_DRIVER_PORT}
# MAGIC       spark_cluster_mode: spark_driver_mode
# MAGIC       cluster_name: \${hostip}
# MAGIC       streaming_metrics: true
# MAGIC logs:
# MAGIC     - type: file
# MAGIC       path: /databricks/driver/logs/*
# MAGIC       exclude_paths:
# MAGIC         - /databricks/driver/logs/*.gz
# MAGIC         - /databricks/driver/logs/metrics.json
# MAGIC       source: databricks
# MAGIC       service: databricks
# MAGIC       log_processing_rules:
# MAGIC         - type: multi_line
# MAGIC           name: new_log_start_with_date
# MAGIC           pattern: \d{2,4}[\-\/]\d{2,4}[\-\/]\d{2,4}.*" > /etc/datadog-agent/conf.d/spark.yaml
# MAGI
# MAGIC #######################################################
# MAGIC ##########    Installation on Worker Node    ##########
# MAGIC #######################################################
# MAGIC
# MAGIC else
# MAGIC
# MAGIC   ##########################################
# MAGIC   #        Datadog Agent Installation      #
# MAGIC   ##########################################
# MAGI
# MAGIC   # Configure Datadog Agent host tags for the Worker. These tags inlude the custom tags set up in our environment variables
# MAGIC   DD_TAGS="databricks_cluster_id:\${DB_CLUSTER_ID}","databricks_cluster_name:\${DB_CLUSTER_NAME}","spark_node:worker","${CUSTOM_DD_TAGS}"
# MAGIC
# MAGIC   # Datadog Agent v7 (latest)
# MAGIC   DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=\$DD_API_KEY DD_SITE=\${DD_SITE} DD_HOST_TAGS=\$DD_TAGS bash -c "\$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
# MAGIC
# MAGIC   # Wait for the Datadog Agent to be installed
# MAGIC   while [ -z \$datadoginstalled ]; do
# MAGIC     if [ -e "/etc/datadog-agent/datadog.yaml" ]; then
# MAGIC       datadoginstalled=TRUE
# MAGIC     fi
# MAGIC     sleep 2
# MAGIC   done
# MAGIC   echo "Datadog Agent is installed"
# MAGIC
# MAGIC   ##########################################
# MAGIC   #   Create custom Datadog Agent config   #
# MAGIC   ##########################################
# MAGIC
# MAGIC   echo "api_key: \${DD_API_KEY}
# MAGIC site: \${DD_SITE}
# MAGIC tags: [\${DD_TAGS}]
# MAGIC env: \${DD_ENV}
# MAGIC # Enable Live Processes
# MAGIC process_config:
# MAGIC     enabled: 'true'" > /etc/datadog-agent/datadog.yaml
# MAGIC fi
# MAGIC
# MAGIC #######################################################
# MAGIC ##########            Post Install           ##########
# MAGIC #######################################################
# MAGIC
# MAGIC # Restart the Datadog Agent to pick up configuration changes
# MAGIC sudo service datadog-agent restart
# MAGIC
# MAGIC EOF
# MAGIC
# MAGIC #########################################################
# MAGIC ########## Run the Datadog Installation Script ##########
# MAGIC #########################################################
# MAGI
# MAGIC # Enable script
# MAGIC chmod a+x /tmp/start_datadog.sh
# MAGIC /tmp/start_datadog.sh >> /tmp/datadog_start.log 2>&1 & disown
# MAGIC """, True)
