#!/bin/env -S bash -ex

case "$PACKER_BUILDER_TYPE" in
vmware-iso | vmware-vmx)
    echo "Install open-vm-tools"
    apt-get install -y open-vm-tools
    mkdir /mnt/hgfs
    systemctl enable open-vm-tools
    systemctl start open-vm-tools
    echo "Finish open-vm-tools"
    ;;
esac
