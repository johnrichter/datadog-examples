locals {
  //
  // Configs and lookup maps
  //

  hypervisors = {
    vbox   = "virtualbox-iso"
    vmware = "vmware-iso"
    qemu   = "qemu"
    // TODO
    // parallels = "parallels"
  }
  architectures = {
    aarch64 = "aarch64"
    arm64   = "aarch64"
    amd64   = "amd64"
    x86_64  = "amd64"
    unknown = "unknown"
  }
  os_installers = {
    unknown = {
      iso               = { local = "", remote = "" }
      checksum          = { sha256 = "", file = "" }
      codename          = ""
      build_command     = []
      boot_key_interval = ""
      boot_wait         = ""
      shutdown_command  = ""
    }
    ubuntu_20045_aarch64 = {
      iso = {
        local  = ""
        remote = "https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.5-live-server-arm64.iso"
      }
      checksum = {
        file   = "https://cdimage.ubuntu.com/releases/20.04/release/SHA256SUMS"
        sha256 = "e42d6373dd39173094af5c26cbf2497770426f42049f8b9ea3e60ce35bebdedf"
      }
      build_command = [
        "c<wait>",
        "search --set=root --file /casper/vmlinuz<enter><wait5>",
        "linux /casper/vmlinuz",
        " initrd=/casper/initrd",
        " debconf/frontend=noninteractive",
        // " cloud-config-url='http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
        " autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait5>",
        "initrd /casper/initrd<enter><wait5>",
        "boot<wait5><enter>"
      ]
      boot_key_interval = "25ms"
      boot_wait         = "10s"
      codename          = "focal64"
      shutdown_command  = "echo '${var.user_password}' | sudo -S shutdown -P now"
    }
    ubuntu_20046_amd64 = {
      iso = {
        local  = ""
        remote = "https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
      }
      checksum = {
        file   = "https://releases.ubuntu.com/20.04/SHA256SUMS"
        sha256 = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
      }
      build_command = [
        "c<wait>",
        "search --set=root --file /casper/vmlinuz<enter><wait5>",
        "linux /casper/vmlinuz",
        " initrd=/casper/initrd",
        " debconf/frontend=noninteractive",
        // " cloud-config-url='http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
        " autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait5>",
        "initrd /casper/initrd<enter><wait5>",
        "boot<wait5><enter>"
      ]
      boot_key_interval = "50ms"
      boot_wait         = "5s"
      codename          = "focal64"
      shutdown_command  = "echo '${var.user_password}' | sudo -S shutdown -P now"
    }
    ubuntu_22042_aarch64 = {
      iso = {
        local  = ""
        remote = "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
      }
      checksum = {
        file   = "https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS"
        sha256 = "12eed04214d8492d22686b72610711882ddf6222b4dc029c24515a85c4874e95"
      }
      build_command = [
        "c<wait>",
        "search --set=root --file /casper/vmlinuz<enter><wait5>",
        "linux /casper/vmlinuz",
        " initrd=/casper/initrd",
        " debconf/frontend=noninteractive",
        // " cloud-config-url='http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
        " autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait5>",
        "initrd /casper/initrd<enter><wait5>",
        "boot<wait5><enter>"
      ]
      boot_key_interval = "25ms"
      boot_wait         = "10s"
      codename          = "jammy64"
      shutdown_command  = "echo '${var.user_password}' | sudo -S shutdown -P now"
    }
    ubuntu_22042_amd64 = {
      iso = {
        remote = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
        local  = ""
      }
      checksum = {
        file   = "https://releases.ubuntu.com/22.04/SHA256SUMS"
        sha256 = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
      }
      build_command = [
        "c<wait>",
        "search --set=root --file /casper/vmlinuz<enter><wait5>",
        "linux /casper/vmlinuz",
        " initrd=/casper/initrd",
        " debconf/frontend=noninteractive",
        // " cloud-config-url='http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
        " autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait5>",
        "initrd /casper/initrd<enter><wait5>",
        "boot<wait5><enter>"
      ]
      boot_key_interval = "50ms"
      boot_wait         = "5s"
      codename          = "jammy64"
      shutdown_command  = "echo '${var.user_password}' | sudo -S shutdown -P now"
    }
  }
  vagrant = {
    cloud = {
      box_namespace = "jrichter.io"
    }
  }
  virtualbox = {
    guest_additions = {
      uploaded_file = "/opt/virtualbox/VBoxGuestAdditions-${var.virtualbox_guest_additions_version}.iso"
      url           = "https://download.virtualbox.org/virtualbox/${var.virtualbox_guest_additions_version}/VBoxGuestAdditions_${var.virtualbox_guest_additions_version}.iso"
    }
    guest_os_type = {
      generic              = "Linux"
      ubuntu_20045_aarch64 = "Ubuntu20_LTS_64"
      ubuntu_20046_amd64   = "Ubuntu20_LTS_64"
      ubuntu_22042_aarch64 = "Ubuntu22_LTS_64"
      ubuntu_22042_amd64   = "Ubuntu22_LTS_64"
    }
    version_file = "/opt/virtualbox/.vbox_version"
  }
  vmware = {
    guest_os_type = {
      generic              = "other-64"
      ubuntu_20045_aarch64 = "arm-ubuntu-64"
      ubuntu_20046_amd64   = "ubuntu-64"
      ubuntu_22042_aarch64 = "arm-ubuntu-64"
      ubuntu_22042_amd64   = "ubuntu-64"
    }
    remote_cache_datastore = "/opt/vmware/cache"
    remote_cache_directory = "/opt/vmware/cache/assets"
    // Currently opting to install open-vm-tools via apt as recommended by VMware
    tools = {
      flavor        = null // When not set or set to "" don't install VMware tools
      uploaded_file = "/opt/vmware/vmware_tools_{{ .Flavor }}.iso"
    }
  }
  qemu = {
    binary = {
      unknown = "qemu-system-unknown"
      aarch64 = "qemu-system-aarch64"
      arm64   = "qemu-system-aarch64"
      amd64   = "qemu-system-x86_64"
      x86_64  = "qemu-system-x86_64"
    }
  }

  //
  // Constants
  //

  guest_os_arch           = lookup(local.architectures, var.vm_os.arch, local.architectures.unknown)
  guest_os_key            = "${var.vm_os.name}_${replace(var.vm_os.version, ".", "")}_${local.guest_os_arch}"
  build_dir_rel           = "${path.root}/build/${var.vm_os.name}-${var.vm_os.version}-${local.guest_os_arch}"
  build_dir_abs           = abspath(local.build_dir_rel)
  config_dir              = abspath("${path.root}/config")
  cloudinit_config_dir    = abspath("${local.config_dir}/cloudinit")
  provisioning_config_dir = abspath("${local.config_dir}/provisioning")
  vagrant_boxes_dir       = abspath("${path.root}/../boxes")
  vagrant_config_dir      = abspath("${local.config_dir}/vagrant")
  vm_human_name           = "${var.vm_os.name}-${var.vm_os.version}-${local.guest_os_arch}"
  vm_instance_id          = substr(strrev(sha512(uuidv4())), 0, 16)

  //
  // Runtime config
  //

  // Not meant to be used anywhere, but here
  resolved_os_installer = lookup(local.os_installers, local.guest_os_key, local.os_installers.unknown)

  // Meant to be used in sources
  os_installer = merge(
    local.resolved_os_installer,
    {
      checksum = {
        uri = (
          local.resolved_os_installer.checksum.sha256 != "" ? "sha256:${local.resolved_os_installer.checksum.sha256}" : (
            local.resolved_os_installer.checksum.file != "" ? "file:${local.resolved_os_installer.checksum.file}" : (
              "none"
            )
          )
        )
      }
    }
  )

  //
  // Constants
  //

  vagrant_cloud_box_tag = "${local.vagrant.cloud.box_namespace}/${local.os_installer.codename}"

  //
  // Sources config
  //

  builders = {
    packer = {
      boot_command      = local.os_installer.build_command
      boot_key_interval = local.os_installer.boot_key_interval
      boot_wait         = local.os_installer.boot_wait
      communicator      = "ssh"
      cores             = 4
      cpus              = 4 // cpus = sockets * cores (per socket) * threads (per core)
      headless          = false
      http_bind_address = "0.0.0.0"
      http_directory    = local.config_dir
      iso_checksum      = local.os_installer.checksum.uri
      iso_skip_cache    = false
      iso_urls = [
        local.os_installer.iso.local,
        local.os_installer.iso.remote
      ]
      keep_registered              = false
      memory                       = 4096
      output_directory             = local.build_dir_abs
      pause_before_connecting      = "0s"
      post_shutdown_delay          = "0s"
      qmp_enable                   = false
      qmp_socket_path              = "${local.build_dir_rel}/build.monitor"
      shutdown_command             = local.os_installer.shutdown_command
      shutdown_timeout             = "5m"
      skip_export                  = false
      skip_nat_mapping             = false
      sockets                      = 1
      sound                        = false
      ssh_agent_auth               = false
      ssh_certificate_file         = null // Noop if ssh_agent_auth is set
      ssh_disable_agent_forwarding = false
      ssh_file_transfer_method     = "sftp"
      ssh_keep_alive_interval      = "5s"
      ssh_password                 = var.user_password
      ssh_port                     = 22
      ssh_private_key_file         = null // Noop if ssh_agent_auth is set
      ssh_pty                      = false
      ssh_timeout                  = "30m" // Noop if ssh_handshake_attempts is set
      ssh_username                 = var.user_name
      threads                      = 1
      usb                          = true
      vm_name                      = var.vm_filename
      vnc_bind_address             = "127.0.0.1"
      vnc_use_password             = false
      vrdp_bind_address            = "127.0.0.1"
    }
    virtualbox = {
      acpi_shutdown        = false
      audio_controller     = "ac97"
      bundle_iso           = false
      chipset              = "piix3"
      disk_additional_size = []    // Additional disks to create
      disk_size            = 21475 // ~20GiB in MB
      // https://www.virtualbox.org/manual/ch09.html#vboxmanage-export
      export_opts = [
        "--manifest",
        "--description", "${var.vm_description}",
        "--version", "${var.vm_version}"
      ]
      // EFI requires extension pack from https://www.virtualbox.org/wiki/Downloads
      firmware                  = "efi"
      format                    = "ova"
      gfx_accelerate_3d         = false
      gfx_controller            = "vmsvga"
      gfx_efi_resolution        = "1200x1200"
      gfx_vram_size             = "128"
      guest_additions_interface = "sata"
      guest_additions_mode      = "upload"
      guest_additions_path      = local.virtualbox.guest_additions.uploaded_file
      guest_additions_sha256    = "none"
      guest_additions_url       = local.virtualbox.guest_additions.url
      guest_os_type             = lookup(local.virtualbox.guest_os_type, local.guest_os_key, local.virtualbox.guest_os_type.generic)
      hard_drive_discard        = true
      hard_drive_interface      = "pcie"
      hard_drive_nonrotational  = true
      iso_interface             = "sata"
      nested_virt               = true
      nic_type                  = "82540EM"
      nvme_port_count           = 1
      rtc_time_base             = "local"
      sata_port_count           = 3
      sound                     = "none"
      usb                       = true
      vboxmanage_post = [
        ["modifyvm", "{{.Name}}", "--cpus", "1"],
        ["modifyvm", "{{.Name}}", "--memory", "512"],
      ]
      virtualbox_version_file = local.virtualbox.version_file
    }
    vmware = {
      cdrom_adapter_type     = "sata"
      cleanup_remote_cache   = true
      disk_adapter_type      = "nvme"
      disk_additional_size   = []    // Additional disks to create
      disk_size              = 21475 // ~20GiB in MB
      disk_type_id           = 1     // Growable virtual disk split into 2GB files (split sparse).
      display_name           = local.vm_human_name
      format                 = "vmx"
      guest_os_type          = lookup(local.vmware.guest_os_type, local.guest_os_key, local.vmware.guest_os_type.generic)
      network                = "nat"    // Defaults to VMnet0..N
      network_adapter_type   = "e1000e" // https://kb.vmware.com/s/article/1001805
      ovftool_options        = []       // vSphere. Requires https://developer.vmware.com/web/tool/4.6.0/ovf-tool
      remote_cache_datastore = local.vmware.remote_cache_datastore
      remote_cache_directory = local.vmware.remote_cache_directory
      skip_compaction        = false
      tools_source_path      = null // Set if not found with default values
      tools_upload_flavor    = local.vmware.tools.flavor
      tools_upload_path      = local.vmware.tools.uploaded_file
      version                = 20 // Hardware Version - https://kb.vmware.com/s/article/1003746
      // Arbitrary key/values to enter into the virtual machine VMX file
      vmx_data = {
        "firmware"                              = "efi"
        "mks.enable3d"                          = "FALSE"
        "usb_xhci.present"                      = "TRUE"
        "ethernet0.linkStatePropagation.enable" = "TRUE"
        "sata1.present"                         = "TRUE"
        "floppy0.present"                       = "TRUE"
        "powertype.poweroff"                    = "hard"
        "powertype.poweron"                     = "hard"
        "powertype.reset"                       = "hard"
        "powertype.suspend"                     = "hard"
        "softPowerOff"                          = "FALSE"
      }
      vmx_data_post                  = {}
      vmx_remove_ethernet_interfaces = var.vm_is_vagrant_box
    }
    // Values for some options can be listed by `qemu-system-aarch64 -<option> help`
    qemu = {
      accelerator = var.host_machine.is_mac ? "hvf" : "hvm"
      args = [
        // Override Packer's QMP settings for mux and customization
        ["-chardev", "socket,id=char0,path=${local.build_dir_rel}/build.monitor,mux=on,server=on,wait=off"],
        ["-mon", "chardev=char0,mode=control,pretty=on"],
        // Make the VNC window larger for readability
        ["-serial", "vc:1200x1200"],
        // Enable USB and the usb-tablet for better mouse position control and prevent mouse capture
        ["-usb"],
        ["-device", "nec-usb-xhci,id=usb-bus"],
        ["-device", "usb-tablet,bus=usb-bus.0"],
        ["-device", "usb-mouse,bus=usb-bus.0"],
        ["-device", "usb-kbd,bus=usb-bus.0"],
        // Enable graphics driver. Currently not supported on Apple Silicon and caused boot issues
        // ["-device", "virtio-gpu-pci"],
        // Add Random Number Generator
        ["-device", "virtio-rng-pci"],
        // Override network bus for vmnet on Mac (hack)
        // var.host_machine.is_mac && var.host_machine.mac.use_vmnet ? ["-device", "virtio-net-device,netdev=user.0"] : [],
      ]
      binary               = lookup(local.qemu.binary, local.guest_os_arch, local.qemu.binary.unknown)
      cpu_model            = "host"
      cdrom_interface      = null // virtio-scsi if having problems
      disk_additional_size = []   // Additional disks to create
      disk_compression     = false
      disk_detect_zeroes   = "unmap"
      disk_discard         = "unmap"
      disk_interface       = "virtio"
      disk_size            = "21475M"
      display              = var.host_machine.is_mac ? "cocoa" : "gtk"
      efi_boot             = var.vm_use_uefi
      efi_firmware_code    = var.qemu.firmware.uefi.code
      efi_firmware_vars    = var.qemu.firmware.uefi.vars
      firmware             = var.vm_use_uefi ? null : var.qemu.firmware.bios
      format               = "qcow2"
      machine_type         = "virt"
      net_device           = (var.host_machine.is_mac && var.host_machine.mac.use_vmnet) ? "vmnet-shared" : "virtio-net-pci"
      // This bridge must already exist before running Packer and using libvirt. The virbr0 bridge the
      // default network created by libvirt. Only works on Linux
      net_bridge          = var.host_machine.is_mac ? null : "virbr0"
      use_default_display = false // Set to true for sdl errors on mac
    }
  }

  // Builders
  enabled_sources = [
    for hv in var.enabled_hypervisors : "source.${lookup(local.hypervisors, hv, "unknown")}.vm"
  ]
}
