#!/bin/env -S bash -ex

# Uploaded by a Packer file provisioner
echo "${USER_PASSWORD}" | sudo -S mv /tmp/netplan/00-all-en-all-eth-match.yaml /etc/netplan/00-all-en-all-eth-match.yaml
echo "${USER_PASSWORD}" | sudo -S chown root:root /etc/netplan/00-all-en-all-eth-match.yaml
echo "${USER_PASSWORD}" | sudo -S chmod u=rw,g=r,o=r /etc/netplan/00-all-en-all-eth-match.yaml
