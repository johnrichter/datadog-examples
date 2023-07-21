source "virtualbox-iso" "vm" {
  //
  // Virtualbox specific
  //

  acpi_shutdown             = local.builders.virtualbox.acpi_shutdown
  audio_controller          = local.builders.virtualbox.audio_controller
  bundle_iso                = local.builders.virtualbox.bundle_iso
  chipset                   = local.builders.virtualbox.chipset
  disk_additional_size      = local.builders.virtualbox.disk_additional_size
  disk_size                 = local.builders.virtualbox.disk_size
  export_opts               = local.builders.virtualbox.export_opts
  firmware                  = local.builders.virtualbox.firmware
  format                    = local.builders.virtualbox.format
  gfx_accelerate_3d         = local.builders.virtualbox.gfx_accelerate_3d
  gfx_controller            = local.builders.virtualbox.gfx_controller
  gfx_efi_resolution        = local.builders.virtualbox.gfx_efi_resolution
  gfx_vram_size             = local.builders.virtualbox.gfx_vram_size
  guest_additions_interface = local.builders.virtualbox.guest_additions_interface
  guest_additions_mode      = local.builders.virtualbox.guest_additions_mode
  guest_additions_path      = local.builders.virtualbox.guest_additions_path
  guest_additions_sha256    = local.builders.virtualbox.guest_additions_sha256
  guest_additions_url       = local.builders.virtualbox.guest_additions_url
  guest_os_type             = local.builders.virtualbox.guest_os_type
  hard_drive_discard        = local.builders.virtualbox.hard_drive_discard
  hard_drive_interface      = local.builders.virtualbox.hard_drive_interface
  hard_drive_nonrotational  = local.builders.virtualbox.hard_drive_nonrotational
  iso_interface             = local.builders.virtualbox.iso_interface
  nested_virt               = local.builders.virtualbox.nested_virt
  nic_type                  = local.builders.virtualbox.nic_type
  nvme_port_count           = local.builders.virtualbox.nvme_port_count
  rtc_time_base             = local.builders.virtualbox.rtc_time_base
  sata_port_count           = local.builders.virtualbox.sata_port_count
  vboxmanage_post           = local.builders.virtualbox.vboxmanage_post

  //
  // Packer
  //

  boot_command      = local.builders.packer.boot_command
  boot_wait         = local.builders.packer.boot_wait
  boot_key_interval = local.builders.packer.boot_key_interval
  communicator      = local.builders.packer.communicator
  cpus              = local.builders.packer.cpus
  headless          = local.builders.packer.headless
  http_bind_address = local.builders.packer.http_bind_address
  http_content = {
    "/meta-data"      = templatefile("${local.cloudinit_config_dir}/metadata.pkrtpl.hcl", { var = var, local = local })
    "/network-config" = templatefile("${local.cloudinit_config_dir}/network-config.pkrtpl.hcl", { var = var, local = local })
    "/user-data"      = templatefile("${local.cloudinit_config_dir}/autoinstall/autoinstall-with-cloudinit.pkrtpl.hcl", { var = var, local = local })
    "/vendor-data"    = templatefile("${local.cloudinit_config_dir}/vendordata.pkrtpl.hcl", { var = var, local = local })
  }
  iso_checksum                 = local.builders.packer.iso_checksum
  iso_urls                     = local.builders.packer.iso_urls
  keep_registered              = local.builders.packer.keep_registered
  memory                       = local.builders.packer.memory
  output_directory             = local.builders.packer.output_directory
  pause_before_connecting      = local.builders.packer.pause_before_connecting
  post_shutdown_delay          = local.builders.packer.post_shutdown_delay
  shutdown_command             = local.builders.packer.shutdown_command
  shutdown_timeout             = local.builders.packer.shutdown_timeout
  skip_export                  = local.builders.packer.skip_export
  skip_nat_mapping             = local.builders.packer.skip_nat_mapping
  sound                        = local.builders.packer.sound ? (var.host_machine.is_mac ? "coreaudio" : "alsa") : "none"
  ssh_agent_auth               = local.builders.packer.ssh_agent_auth
  ssh_certificate_file         = local.builders.packer.ssh_certificate_file
  ssh_disable_agent_forwarding = local.builders.packer.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = local.builders.packer.ssh_file_transfer_method
  ssh_keep_alive_interval      = local.builders.packer.ssh_keep_alive_interval
  ssh_password                 = local.builders.packer.ssh_password
  ssh_port                     = local.builders.packer.ssh_port
  ssh_pty                      = local.builders.packer.ssh_pty
  ssh_timeout                  = local.builders.packer.ssh_timeout
  ssh_username                 = local.builders.packer.ssh_username
  usb                          = local.builders.packer.usb
  virtualbox_version_file      = local.builders.packer.virtualbox_version_file
  vm_name                      = local.builders.packer.vm_name
  vrdp_bind_address            = local.builders.packer.vrdp_bind_address
}

source "vmware-iso" "vm" {
  //
  // VMware specific
  //

  cdrom_adapter_type             = local.builders.vmware.cdrom_adapter_type
  cleanup_remote_cache           = local.builders.vmware.cleanup_remote_cache
  disk_adapter_type              = local.builders.vmware.disk_adapter_type
  disk_additional_size           = local.builders.vmware.disk_additional_size
  disk_size                      = local.builders.vmware.disk_size
  disk_type_id                   = local.builders.vmware.disk_type_id
  display_name                   = local.builders.vmware.display_name
  format                         = local.builders.vmware.format
  guest_os_type                  = local.builders.vmware.guest_os_type
  network                        = local.builders.vmware.network
  network_adapter_type           = local.builders.vmware.network_adapter_type
  ovftool_options                = local.builders.vmware.ovftool_options
  remote_cache_datastore         = local.builders.vmware.remote_cache_datastore
  remote_cache_directory         = local.builders.vmware.remote_cache_directory
  skip_compaction                = local.builders.vmware.skip_compaction
  tools_source_path              = local.builders.vmware.tools_source_path
  tools_upload_flavor            = local.builders.vmware.tools_upload_flavor
  tools_upload_path              = local.builders.vmware.tools_upload_path
  version                        = local.builders.vmware.version
  vmx_data                       = local.builders.vmware.vmx_data
  vmx_data_post                  = local.builders.vmware.vmx_data_post
  vmx_remove_ethernet_interfaces = local.builders.vmware.vmx_remove_ethernet_interfaces

  //
  // Packer
  //

  boot_command                 = local.builders.packer.boot_command
  boot_key_interval            = local.builders.packer.boot_key_interval
  boot_wait                    = local.builders.packer.boot_wait
  communicator                 = local.builders.packer.communicator
  cores                        = local.builders.packer.cores / local.builders.packer.cores
  cpus                         = local.builders.packer.cpus
  headless                     = local.builders.packer.headless
  http_bind_address            = local.builders.packer.http_bind_address
  iso_checksum                 = local.builders.packer.iso_checksum
  iso_urls                     = local.builders.packer.iso_urls
  keep_registered              = local.builders.packer.keep_registered
  memory                       = local.builders.packer.memory
  output_directory             = local.builders.packer.output_directory
  pause_before_connecting      = local.builders.packer.pause_before_connecting
  shutdown_command             = local.builders.packer.shutdown_command
  shutdown_timeout             = local.builders.packer.shutdown_timeout
  skip_export                  = local.builders.packer.skip_export
  sound                        = local.builders.packer.sound
  ssh_certificate_file         = local.builders.packer.ssh_certificate_file
  ssh_disable_agent_forwarding = local.builders.packer.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = local.builders.packer.ssh_file_transfer_method
  ssh_keep_alive_interval      = local.builders.packer.ssh_keep_alive_interval
  ssh_password                 = local.builders.packer.ssh_password
  ssh_port                     = local.builders.packer.ssh_port
  ssh_pty                      = local.builders.packer.ssh_pty
  ssh_timeout                  = local.builders.packer.ssh_timeout
  ssh_username                 = local.builders.packer.ssh_username
  usb                          = local.builders.packer.usb
  vm_name                      = local.builders.packer.vm_name
  vmdk_name                    = local.builders.packer.vm_name
  vnc_bind_address             = local.builders.packer.vnc_bind_address
  vnc_disable_password         = !local.builders.packer.vnc_use_password

  //
  // Operating System configuration
  //

  // Used for Subiquity/Autoinstall. Build commands specify kernel parameters to boot the
  // autoinstaller with Packer's HTTP server as a datasource only on the first boot.
  // https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html#method-3-custom-webserver-kernel-commandline-or-smbios
  http_content = {
    "/meta-data"      = templatefile("${local.cloudinit_config_dir}/metadata.pkrtpl.hcl", { var = var, local = local })
    "/network-config" = templatefile("${local.cloudinit_config_dir}/network-config.pkrtpl.hcl", { var = var, local = local })
    // currently with cloudinit
    "/user-data"   = templatefile("${local.cloudinit_config_dir}/autoinstall/autoinstall-with-cloudinit.pkrtpl.hcl", { var = var, local = local })
    "/vendor-data" = templatefile("${local.cloudinit_config_dir}/vendordata.pkrtpl.hcl", { var = var, local = local })
  }

  // floppy_label = "CIDATA"
  // floppy_content = {
  //   "meta-data"      = templatefile("${local.cloudinit_config_dir}/metadata.pkrtpl.hcl", { var = var, local = local })
  //   "network-config" = templatefile("${local.cloudinit_config_dir}/network-config.pkrtpl.hcl", { var = var, local = local })
  //   "user-data"      = templatefile("${local.cloudinit_config_dir}/user-data.pkrtpl.hcl", { var = var, local = local })
  //   "vendor-data"    = templatefile("${local.cloudinit_config_dir}/vendordata.pkrtpl.hcl", { var = var, local = local })
  // }

  // For Cloud-Init's NoCloud datasource. It'll automatically look for a volume labeled 'CIDATA'
  // https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html#method-1-local-filesystem-labeled-filesystem
  // cd_label = "CIDATA"
  // cd_content = {
  //   "meta-data"      = templatefile("${local.cloudinit_config_dir}/metadata.pkrtpl.hcl", { var = var, local = local })
  //   "network-config" = templatefile("${local.cloudinit_config_dir}/network-config.pkrtpl.hcl", { var = var, local = local })
  //   "user-data"      = templatefile("${local.cloudinit_config_dir}/user-data.pkrtpl.hcl", { var = var, local = local })
  //   "vendor-data"    = templatefile("${local.cloudinit_config_dir}/vendordata.pkrtpl.hcl", { var = var, local = local })
  // }
}

source "qemu" "vm" {
  //
  // QEMU specific
  //

  accelerator          = local.builders.qemu.accelerator
  cdrom_interface      = local.builders.qemu.cdrom_interface
  cpu_model            = local.builders.qemu.cpu_model
  disk_additional_size = local.builders.qemu.disk_additional_size
  disk_compression     = local.builders.qemu.disk_compression
  disk_detect_zeroes   = local.builders.qemu.disk_detect_zeroes
  disk_discard         = local.builders.qemu.disk_discard
  disk_interface       = local.builders.qemu.disk_interface
  disk_size            = local.builders.qemu.disk_size
  display              = local.builders.qemu.display
  efi_boot             = local.builders.qemu.efi_boot
  efi_firmware_code    = local.builders.qemu.efi_firmware_code
  efi_firmware_vars    = local.builders.qemu.efi_firmware_vars
  firmware             = local.builders.qemu.firmware
  format               = local.builders.qemu.format
  machine_type         = local.builders.qemu.machine_type
  net_bridge           = local.builders.qemu.net_bridge
  net_device           = local.builders.qemu.net_device
  qemu_binary          = local.builders.qemu.binary
  qemuargs             = local.builders.qemu.args
  use_default_display  = local.builders.qemu.use_default_display

  //
  // Packer
  //

  boot_command      = local.builders.packer.boot_command
  boot_key_interval = local.builders.packer.boot_key_interval
  boot_wait         = local.builders.packer.boot_wait
  communicator      = local.builders.packer.communicator
  cores             = local.builders.packer.cores
  cpus              = local.builders.packer.cpus
  headless          = local.builders.packer.headless
  http_bind_address = local.builders.packer.http_bind_address
  http_content = {
    "/meta-data"      = templatefile("${local.cloudinit_config_dir}/metadata.pkrtpl.hcl", { var = var, local = local })
    "/network-config" = templatefile("${local.cloudinit_config_dir}/network-config.pkrtpl.hcl", { var = var, local = local })
    "/user-data"      = templatefile("${local.cloudinit_config_dir}/autoinstall/autoinstall-with-cloudinit.pkrtpl.hcl", { var = var, local = local })
    "/vendor-data"    = templatefile("${local.cloudinit_config_dir}/vendordata.pkrtpl.hcl", { var = var, local = local })
  }
  iso_checksum                 = local.builders.packer.iso_checksum
  iso_skip_cache               = local.builders.packer.iso_skip_cache
  iso_urls                     = local.builders.packer.iso_urls
  memory                       = local.builders.packer.memory
  output_directory             = local.builders.packer.output_directory
  pause_before_connecting      = local.builders.packer.pause_before_connecting
  qmp_enable                   = local.builders.packer.qmp_enable
  qmp_socket_path              = local.builders.packer.qmp_socket_path
  shutdown_command             = local.builders.packer.shutdown_command
  shutdown_timeout             = local.builders.packer.shutdown_timeout
  skip_nat_mapping             = local.builders.packer.skip_nat_mapping
  sockets                      = local.builders.packer.sockets
  ssh_agent_auth               = local.builders.packer.ssh_agent_auth
  ssh_certificate_file         = local.builders.packer.ssh_certificate_file
  ssh_disable_agent_forwarding = local.builders.packer.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = local.builders.packer.ssh_file_transfer_method
  ssh_keep_alive_interval      = local.builders.packer.ssh_keep_alive_interval
  ssh_password                 = local.builders.packer.ssh_password
  ssh_port                     = local.builders.packer.ssh_port
  ssh_private_key_file         = local.builders.packer.ssh_private_key_file
  ssh_pty                      = local.builders.packer.ssh_pty
  ssh_timeout                  = local.builders.packer.ssh_timeout
  ssh_username                 = local.builders.packer.ssh_username
  threads                      = local.builders.packer.threads
  vm_name                      = local.builders.packer.vm_name
  vnc_bind_address             = local.builders.packer.vnc_bind_address
  vnc_use_password             = local.builders.packer.vnc_use_password
}

// TODO
// source "parallels" "vm" {}
