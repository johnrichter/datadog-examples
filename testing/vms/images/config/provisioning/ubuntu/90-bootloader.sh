#!/bin/env -S bash -ex

{
    echo "${USER_PASSWORD}"
    echo 'GRUB_TIMEOUT=10'
    echo 'GRUB_TIMEOUT_STYLE="menu"'
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="acpi=force acpi_rev_override=5"'
} | sudo -S tee -a /etc/default/grub
echo "${USER_PASSWORD}" | sudo -S update-grub
