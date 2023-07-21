#cloud-config
#
# Autoinstall
#
# Since version 20.04, the server installer supports automated installation mode (autoinstallation
# for short). You might also know this feature as unattended, hands-off, or preseeded installation.
#
# Autoinstallation lets you answer all those configuration questions ahead of time with an
# autoinstall config, and lets the installation process run without any interaction.
#
# The `user-data` is a regular Cloud Init config
#
# https://ubuntu.com/server/docs/install/autoinstall-reference
# https://cloudinit.readthedocs.io/
#
autoinstall:
  # A future-proofing config file version field. Currently this must be “1”.
  version: 1

  # The locale to configure for the installed system
  locale: "en_US.UTF-8"

  # Controls whether the installer updates to a new version available in the given channel before
  # continuing
  refresh-installer:
    # Whether to update or not
    update: true
    # The channel to check for updates.
    channel: "stable/ubuntu-${var.vm_os.version}"

  # The layout of any attached keyboard. The mapping’s keys correspond to settings in
  # /etc/default/keyboard
  keyboard:
    # Corresponds to the XKBLAYOUT setting
    layout: "us"

  # Driver install sources
  source:
    # Whether the installer should search for available third-party drivers. When set to false,
    # it disables the drivers screen and section.
    search_drivers: false

  # The proxy to configure both during installation and for apt and for snapd in the target system
  proxy: null

  # Configuration of disk storage. Default is to use “lvm” layout in a single disk system, no
  # default in a multiple disk system
  storage:
    # Simple way of expressing common configurations. Can be “lvm” or “direct.” Default is "lvm"
    layout:
      name: lvm

      # Controls volume expansion and sizing behavior. The lvm layout will, by default, attempt to
      # leave room for snapshots and further expansion.
      #   * scaled -> adjust space allocated to the root LV based on space available to the VG
      #   * all -> allocate all remaining VG space to the root LV
      # The scaling system is currently as follows
      #   * Less than 10 GiB: use all remaining space for root filesystem
      #   * Between 10-20 GiB: 10 GiB root filesystem
      #   * Between 20-200 GiB: use half of remaining space for root filesystem
      #   * Greater than 200 GiB: 100 GiB root filesystem
      sizing-policy: "scaled"

    # The grub and swap curtin config.
    # https://curtin.readthedocs.io/en/latest/topics/config.html#grub
    grub:
      # Controls whether grub-install will update the Linux Default target value during installation
      replace_linux_default: true

      # Certain platforms, like uefi and prep systems utilize NVRAM to hold boot configuration
      # settings which control the order in which devices are booted. Curtin by default will enable
      # NVRAM updates to boot configuration settings. Users may disable NVRAM updates by setting the
      # update_nvram value to False
      update_nvram: true

      # Curtin is typically used with MAAS where the systems are configured to boot from the network
      # leaving MAAS in control. On UEFI systems, after installing a bootloader the systems
      # BootOrder may be updated to boot from the new entry. This breaks MAAS control over the
      # system as all subsequent reboots of the node will no longer boot over the network.
      # Therefore, if reorder_uefi is True curtin will modify the UEFI BootOrder settings to place
      # the currently booted entry (BootCurrent) to the first option after installing the new target
      # OS into the UEFI boot menu. The result is that the system will boot from the same device
      # that it booted to run curtin; for MAAS this will be a network device.
      #
      # On some UEFI systems the BootCurrent entry may not be present. This can cause a system to
      # not boot to the same device that it was previously booting. If BootCurrent is not present,
      # curtin will update the BootOrder such that all Network related entries are placed before
      # the newly installed boot entry and all other entries are placed at the end. This enables
      # the system to network boot first and on failure will boot the most recently installed entry
      #
      # This setting is ignored if update_nvram is False.
      #
      # Required for ubuntu 20.04 since it can't unmount the cdrom on reboot
      # https://bugs.launchpad.net/subiquity/+bug/1901397
      # https://github.com/hashicorp/packer-plugin-qemu/issues/66#issuecomment-1466049817
      reorder_uefi: false

      # The fallback reodering mechanism is only active if BootCurrent is not present in the
      # efibootmgr output. The fallback reordering method may be enabled even if BootCurrent is
      # present if reorder_uefi_force_fallback is True. This setting is ignored if update_nvram or
      # reorder_uefi are False.
      reorder_uefi_force_fallback: false

      # When curtin updates UEFI NVRAM it will remove duplicate entries that are present in the UEFI
      # menu. If you do not wish for curtin to remove duplicate entries setting
      # remove_duplicate_entries to False. This setting is ignored if update_nvram is False.
      remove_duplicate_entries: true

  # Configure the initial user for the system. This is the only config key that must be present
  # (unless the user-data section is present, in which case it is optional).
  identity:
    # The hostname for the system
    hostname: "${var.hostname}"

    # The real name for the user. This field is optional
    realname: "${var.user_realname}"

    # The user name to create
    username: "${var.user_name}"

    # The password for the new user, encrypted. This is required for use with sudo, even if SSH
    # access is configured. The crypted password string must conform to what passwd expects.
    # Depending on the special characters in the password hash, quoting may be required, so it’s
    # safest to just always include the quotes around the hash. Several tools can generate the
    # crypted password, such as `mkpasswd` from the whois package, or `openssl passwd`
    password: ${var.user_password_crypted}

  # Configure SSH for the installed system
  ssh:
    # Whether to install OpenSSH server in the target system.
    install-server: true

    # A list of SSH public keys to install in the initial user’s account
    authorized-keys: ${jsonencode(var.user_ssh_authorized_key_blobs)}

    # Allow login via password. Defaults to true if authorized_keys is empty, false otherwise
    allow-pw: ${jsonencode(var.ssh_enable_password_authentication)}

  # Configure whether common restricted packages (including codecs) from [multiverse] should be
  # installed
  codecs:
    # Whether to install the ubuntu-restricted-addons package
    install: false

  # Driver installation
  drivers:
    # Whether to install the available third-party drivers
    install: false

  # The type of updates that will be downloaded and installed after the system install. Supported
  # values are
  #   * security -> download and install updates from the -security pocket
  #   * all -> also download and install updates from the -updates pocket
  updates: "all"

  # Request the system to power off or reboot automatically after the installation has finished.
  # Supported values are
  #   * reboot
  #   * poweroff
  shutdown: "reboot"

  # A list of shell commands to invoke as soon as the installer starts, in particular before probing
  # for block and network devices
  early-commands:
    # otherwise packer tries to connect and exceed max attempts:
    - "systemctl stop ssh.service"
    # - "systemctl stop ssh.socket"

  # Shell commands to run after the install has completed successfully and any updates and packages
  # installed, just before the system reboots. They are run in the installer environment with the
  # installed system mounted at /target. You can run curtin in-target -- $shell_command (with the
  # version of subiquity released with 20.04 GA you need to specify this as
  # curtin in-target --target=/target -- $shell_command) to run in the target system (similar to
  # how plain in-target can be used in d-i preseed/late_command)
  late-commands:
    # Required for ubuntu 20.04 since it can't unmount the cdrom on reboot
    # https://bugs.launchpad.net/subiquity/+bug/1901397
    # https://github.com/hashicorp/packer-plugin-qemu/issues/66#issuecomment-1466049817
    # curtin in-target --target=/target -- sudo sed -i 's|nocloud-net;seedfrom=http://.*/|vmware|' /etc/default/grub
    # curtin in-target --target=/target -- update-grub
    # curtin in-target --target=/target -- rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg
    # curtin in-target --target=/target -- sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
    # curtin in-target --target=/target -- cloud-init clean
    # curtin in-target --target=/target -- echo -e "GRUB_TIMEOUT='10'\n" >> /etc/default/grub
    # curtin in-target --target=/target -- echo -e "GRUB_CMDLINE_LINUX_DEFAULT='ds=nocloud-net;s=file://tmp/cloud/'\n" >> /etc/default/grub
    # sudo rm -f /target/etc/cloud/cloud.cfg"
    # sudo rm -f /target/etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
    - |
      echo 'GRUB_TIMEOUT=10' | tee -a /target/etc/default/grub
      echo 'GRUB_TIMEOUT_STYLE="menu"' | tee -a /target/etc/default/grub
      echo 'GRUB_CMDLINE_LINUX_DEFAULT="acpi=force acpi_rev_override=5"' | tee -a /target/etc/default/grub
      curtin in-target --target=/target -- update-grub
    - |
      if [ -d /sys/firmware/efi ]; then
        /target/bin/efibootmgr -o $(/target/bin/efibootmgr | /target/bin/perl -n -e '/Boot(.+)\* ubuntu/ && print $1')
      fi
    # - "curtin in-target --target=/target -- sudo cloud-init clean"
    # - "sudo rm -f /target/etc/cloud/cloud.cfg.d/99-installer.cfg"
    # - "sudo rm -f /target/etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg"
    # - "sudo rm -f /target/etc/cloud/ds-identify.cfg"
    # - "sudo rm -f /target/etc/netplan/00-installer-config.yaml"

  # Shell commands to run after the install has failed. They are run in the installer environment,
  # and the target system (or as much of it as the installer managed to configure) will be mounted
  # at /target. Logs will be available at /var/log/installer in the live session
  # error-commands:
  #   - "curtin in-target --target=/target -- cloud-init schema --system"
