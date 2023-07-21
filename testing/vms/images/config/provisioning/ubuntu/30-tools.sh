#!/bin/env -S bash -ex

if [[ $PACKER_BUILDER_TYPE == *"vmware"* ]]; then
    echo "${USER_PASSWORD}" | sudo -S apt-get install -y open-vm-tools
fi
