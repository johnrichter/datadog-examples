# Overview

The Datadog documentation on proxying Datadog Agent traffic through proxies can be [found here](https://docs.datadoghq.com/agent/proxy/).

[HAProxy](https://www.haproxy.org/) is a free, fast, and reliable solution offering proxying for TCP and HTTP applications. While HAProxy is usually used as a load balancer to distribute incoming requests to pool servers, you can also use it to proxy Agent traffic to Datadog from hosts that have no outside connectivity:

`agent ---> haproxy ---> Datadog`

This is another good option if you do not have a web proxy readily available in your network and you wish to proxy a large number of Agents. In some cases, a single HAProxy instance is sufficient to handle local Agent traffic in your network, because each proxy can accommodate upwards of 1000 Agents.

Note: This figure is a conservative estimate based on the performance of m3.xl instances specifically. Numerous network-related and host-related variables can influence throughput of HAProxy, so you should keep an eye on your proxy deployment both before and after putting it into service. See the [HAProxy documentation](https://www.haproxy.org/) for additional information.

The communication between HAProxy and Datadog is always encrypted with TLS. The communication between the Agent host and the HAProxy host is not encrypted by default, because the proxy and the Agent are assumed to be on the same host. However, it is recommended that you secure this communication with TLS encryption if the HAproxy host and Agent host are not located on the same isolated local network. To encrypt data between the Agent and HAProxy, you need to create an x509 certificate with the Subject Alternative Name (SAN) extension for the HAProxy host. This certificate bundle (\*.pem) should contain both the public certificate and private key. See this [HAProxy blog post](https://www.haproxy.com/blog/haproxy-ssl-termination/) for more information.

## Tips

Download the Datadog certificate with one of the following commands

```bash
sudo apt-get install ca-certificates # (Debian, Ubuntu)
yum install ca-certificates # (CentOS, Red Hat)
```

The path to the certificate is `/etc/ssl/certs/ca-certificates.crt` for Debian and Ubuntu, or `/etc/ssl/certs/ca-bundle.crt` for CentOS and Red Hat.
