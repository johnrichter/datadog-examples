#!/bin/env -S bash -ex

cat >>/etc/default/grub <<EOF
GRUB_TIMEOUT=10
GRUB_TIMEOUT_STYLE="menu"
GRUB_CMDLINE_LINUX_DEFAULT="acpi=force acpi_rev_override=5
EOF
update-grub
