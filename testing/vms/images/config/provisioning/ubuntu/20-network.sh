#!/bin/env -S bash -ex

# Uploaded by a Packer file provisioner
mv /tmp/netplan/20-all-en-all-eth-match.yaml /etc/netplan/20-all-en-all-eth-match.yaml
chown root:root /etc/netplan/20-all-en-all-eth-match.yaml
chmod u=rw,g=r,o=r /etc/netplan/20-all-en-all-eth-match.yaml
