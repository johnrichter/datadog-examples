build {
  sources = local.enabled_sources

  provisioner "file" {
    sources = [
      abspath("${local.provisioning_config_dir}/netplan")
    ]
    destination = "/tmp/"
  }

  provisioner "shell" {
    pause_before = "30s"
    execute_command = "echo '${var.user_password}' | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    env = {
      USER_PASSWORD = var.user_password
      DEBIAN_FRONTEND = "noninteractive"
    }
    scripts = [
      for f in fileset("${local.provisioning_config_dir}", "${var.vm_os.name}/**/*.sh") : "${local.provisioning_config_dir}/${f}"
    ]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = abspath("${local.vagrant_boxes_dir}/${var.vm_os.name}-${var.vm_os.version}-${var.vm_os.arch}-{{.Provider}}-${source.name}.box")
      vagrantfile_template = abspath("${local.vagrant_config_dir}/Vagrantfile")
    }
    // post-processor "vagrant-cloud" {
    //   access_token = "${var.vagrant_cloud_access_token}"
    //   box_tag      = "hashicorp/precise64"
    //   version      = "${local.version}"
    // }
  }
}

// Looks like the ssh host keys are not generating properly on reboot which causes a hang. Last thing
// I did ws turn off ssh_deletekeys in order to preserve the host keys and avoid regeneration on
// reboot.

// I also saw some failures with apt locks being a thing. Might need to set a delay in the provisioner?
// pause_before="10s" to do that. Add skip_clean=true to the shell provisioner to keep scripts up
// at /tmp

// check to see if there is a ds-config in /etc/cloud
// Check to see in var/run/instance-metadata exists

// sudo cloud-init status --long

// "metadata service crawler" is stuck



// vagrant@ubuntu-arm64:~$ cat /etc/cloud/clean.d/99-installer
// #!/usr/bin/env python3
// # Remove live-installer config artifacts when running: sudo cloud-init clean
// # Autogenerated by Subiquity: 2023-07-19 17:26:28.866703 UTC


// import os

// for cfg_file in ["/etc/cloud/cloud.cfg.d/99-installer.cfg", "/etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg", "/etc/cloud/ds-identify.cfg", "/etc/netplan/00-installer-config.yaml"]:
//     try:
//         os.remove(cfg_file)
//     except FileNotFoundError:
//         pass


// vagrant@ubuntu-arm64:~$ cat /etc/cloud/ds-identify.cfg
// policy: enabled

// vagrant@ubuntu-arm64:~$ ll /etc/cloud/
// total 28
// drwxr-xr-x  5 root root 4096 Jul 19 17:29 ./
// drwxr-xr-x 96 root root 4096 Jul 19 17:32 ../
// drwxr-xr-x  2 root root 4096 Jul 19 17:29 clean.d/
// -rw-r--r--  1 root root 3758 Jun 29 15:41 cloud.cfg
// drwxr-xr-x  2 root root 4096 Jul 19 17:29 cloud.cfg.d/
// -rw-r--r--  1 root adm    16 Jul 19 17:26 ds-identify.cfg
// drwxr-xr-x  2 root root 4096 Jul 19 17:29 templates/

// vagrant@ubuntu-arm64:~$ cat /etc/cloud/ds-identify.cfg
// policy: enabled

// vagrant@ubuntu-arm64:~$ cat /etc/cloud/cloud.cfg.d/
// 05_logging.cfg                              99-installer.cfg                            README
// 90_dpkg.cfg                                 curtin-preserve-sources.cfg                 subiquity-disable-cloudinit-networking.cfg

// vagrant@ubuntu-arm64:~$ cat /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
// network: {config: disabled}

// vagrant@ubuntu-arm64:~$ cat /etc/cloud/cloud.cfg.d/90_dpkg.cfg
// # to update this file, run dpkg-reconfigure cloud-init
// datasource_list: [ NoCloud, ConfigDrive, OpenNebula, DigitalOcean, Azure, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, SmartOS, Bigstep, Scaleway, AliYun, Ec2, CloudStack, Hetzner, IBMCloud, Oracle, Exoscale, RbxCloud, UpCloud, VMware, Vultr, LXD, None ]

// vagrant@ubuntu-arm64:~$ ll /etc/cloud/cloud.cfg.d/99-installer.cfg
// -rw------- 1 root adm 2830 Jul 19 17:26 /etc/cloud/cloud.cfg.d/99-installer.cfg
// vagrant@ubuntu-arm64:~$ sudo cat /etc/cloud/cloud.cfg.d/99-installer.cfg
// datasource:
//   None:
//     metadata:
//       instance-id: abb8c98f-ee1e-4c44-a0aa-9474ae961474
//     userdata_raw: "#cloud-config\napk_repos:\n  alpine_repo:\n    community_enabled:\
//       \ true\n    version: latest-stable\napt:\n  conf: \"APT {\\n    Get {\\n   \
//       \     Assume-Yes 'true';\\n        Fix-Broken 'true';\\n\\\n    \\    }\\n}\\\
//       n\"\n  disable_suites:\n  - backports\n  - proposed\nauthkey_hash: sha512\n\
//       chpasswd:\n  expire: false\ndisable_root: true\ndisable_root_opts: no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command=\"\
//       echo\n  'Please login as the user \\\"vagrant\\\" rather than the user \\\"\
//       $DISABLE_USER\\\".';echo;sleep\n  10;exit 142\"\nfinal_message: 'cloud-init\
//       \ has finished\n\n  version: $version\n\n  timestamp: $timestamp\n\n  datasource:\
//       \ $datasource\n\n  uptime: $uptime\n\n  '\nfqdn: ubuntu-arm64.local\ngrowpart:\n\
//       \  devices:\n  - /\n  ignore_growroot_disabled: false\n  mode: auto\nhostname:\
//       \ ubuntu-arm64\nlocale: en_US.UTF-8\nno_ssh_fingerprints: false\nntp:\n  enabled:\
//       \ false\n  ntp_client: auto\npackage_reboot_if_required: true\npackage_update:\
//       \ true\npackage_upgrade: true\nprefer_fqdn_over_hostname: true\nrandom_seed:\n\
//       \  command:\n  - sh\n  - -c\n  - dd if=/dev/urandom of=$RANDOM_SEED_FILE\n \
//       \ command_required: true\n  data: 5bb229f6f8ae5dc207328e1309a2efe4689d96e07a5569d25d94d352d5f5eddd414e2726a814fb9f418cf06f6f21bd9748a61fd423448be84dc91944d4927f15\n\
//       \  encoding: raw\n  file: /dev/urandom\nresize_rootfs: noblock\nssh_deletekeys:\
//       \ false\nssh_pwauth: true\nusers:\n- create_groups: true\n  gecos: vagrant\n\
//       \  groups:\n  - adm\n  - audio\n  - cdrom\n  - dialout\n  - dip\n  - floppy\n\
//       \  - lxd\n  - netdev\n  - plugdev\n  - sudo\n  - video\n  homedir: /home/vagrant\n\
//       \  lock_passwd: false\n  name: vagrant\n  no_create_home: false\n  no_user_group:\
//       \ false\n  passwd: $6$4d00468b9d22587b$fjQZmRVnc8BkAIGbZtMYSy3f2VNo72Gh8/330w9MYojPZmX5cdqJvQoH9v1HodnQGZqkMfLRP2Vqa.Jw0KYXC.\n\
//       \  primary_group: vagrant\n  shell: /bin/bash\n  ssh_authorized_keys:\n  - ssh-rsa\
//       \ AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==\n\
//       \    vagrant insecure public key\n  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y\n\
//       \    vagrant insecure public key\n  system: false\n- name: vagrant\n  sudo:\
//       \ 'ALL=(ALL) NOPASSWD: ALL'\n"
// datasource_list:
// - None