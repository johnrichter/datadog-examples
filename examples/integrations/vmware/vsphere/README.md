# Work in progress. Do not use

Getting Docker running on vCenter Server

https://williamlam.com/2016/10/how-to-run-a-docker-container-on-the-vcenter-server-appliance-vcsa-6-5.html

```bash
> tdnf -y install docker
> insmod /usr/lib/modules/$(uname -r)/kernel/net/bridge/bridge.ko.xz
> systemctl enable docker
> systemctl start docker
> docker run -d --restart=always --name dd-agent ......
```

These steps ensure Docker persists and runs on boot

```bash
# Change bridge to /bin/true
> vim /etc/modprobe.d/modprobe.conf
# Create file and add the word `bridge` to it
> vim /etc/modules-load.d/bridge.conf
```

```bash
docker run \
  -d \
  --restart=always \
  --name dd-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/datadog/data/agent/conf.d:/conf.d:rw \
  -p 8125:8125/udp \
  -p 10518:10518/tcp \
  -e DD_API_KEY=<DD API KEY> \
  -e DD_SITE="datadoghq.com" \
  -e DD_PROCESS_AGENT_ENABLED=true \
  -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
  -e DD_LOGS_ENABLED=true \
  -e DD_INVENTORIES_CONFIGURATION_ENABLED=true \
  -e DD_ENV=sandbox \
  -e DD_TAGS=cloud_provider:vsphere
  gcr.io/datadoghq/agent:7

docker run -d --restart=always --name dd-agent -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -v /etc/passwd:/etc/passwd:ro -v /etc/datadog/data/agent/conf.d:/conf.d:rw -p 8125:8125/udp -p 10518:10518/tcp -e DD_API_KEY=<DD API KEY> -e DD_SITE="datadoghq.com" -e DD_PROCESS_AGENT_ENABLED=true -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true -e DD_LOGS_ENABLED=true -e DD_INVENTORIES_CONFIGURATION_ENABLED=true -e DD_ENV=sandbox -e DD_TAGS=cloud_provider:vsphere gcr.io/datadoghq/agent:7
```

```yaml
# Default values for the vSphere integration. A full example of this file can be found at
# https://github.com/DataDog/integrations-core/blob/master/vsphere/datadog_checks/vsphere/data/conf.yaml.example

init_config:
  service: vcenter

instances:
  # Details on why we split up the check into two instances can be found here
  # https://github.com/DataDog/integrations-core/blob/master/vsphere/datadog_checks/vsphere/data/conf.yaml.example#L95-L103

  # Hosts and VMs in their own realtime instance
  - collection_type: realtime
    host: <vcenter host>
    username: <username>
    password: <password>
    empty_default_hostname: false
    use_legacy_check_version: false

    # Data collection controls
    collection_level: 4
    use_collect_events_fallback: true
    collect_per_instance_filters:
      vm:
        - .*
      host:
        - .*
    collect_tags: true # vSphere tags
    tags_prefix: "vsphere:tag:"
    collect_attributes: true
    attributes_prefix: "vsphere:attr:"

    # Deduping controls
    use_guest_hostname: false

    # DELETE ME
    ssl_verify: false # TODO DELETE

  # Datastores, Datacenters and Clusters in the historical instance
  - collection_type: historical
    host: <vcenter host>
    username: <username>
    password: <password>
    empty_default_hostname: false
    use_legacy_check_version: false

    # Data collection
    collection_level: 4
    use_collect_events_fallback: true
    collect_per_instance_filters:
      datastore:
        - .*
      cluster:
        - .*
    collect_tags: true # vSphere tags
    tags_prefix: "vsphere:tag:"
    collect_attributes: true
    attributes_prefix: "vsphere:attr:"

    # Host deduping
    use_guest_hostname: false

    # Security
    ssl_verify: false
    # ssl_capath: <DIRECTORY_PATH>

# Only one of these options is needed, but you could do both if you wanted to
logs:
  # Syslog directly to this Agent option
  - type: tcp
    port: 10518
    source: vsphere
    # Inherited by `init_config`
    # service: vcenter

  # # Syslog to file option
  # - type: file
  #   path: "<PATH_LOG_FILE>/<LOG_FILE_NAME>.log"
  #   source: "vsphere"
```
