source "virtualbox-iso" "vm" {
  //
  // Final Image Configuration
  //
  // vboxmanage_post runs after the vm is shutdown and before the vm is exported
  //

  guest_os_type            = "Ubuntu20_LTS_64"
  gfx_accelerate_3d        = true
  gfx_controller           = "vmsvga"
  gfx_vram_size            = "128"
  chipset                  = "piix3"
  firmware                 = "bios"
  nested_virt              = true
  rtc_time_base            = "local"
  audio_controller         = "ac97"
  disk_size                = "21475" // ~20GiB in MB
  nic_type                 = "82545EM"
  hard_drive_discard       = true
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = true
  disk_additional_size     = [] // Additional disks to create
  nvme_port_count          = 1
  sata_port_count          = 1
  vm_name                  = "ubuntu2004"
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--cpus", "1"],
    ["modifyvm", "{{.Name}}", "--memory", "512"],
  ]


  //
  // Installing the Guest OS
  //

  iso_interface = "sata"
  iso_url       = "https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
  iso_checksum  = "file:https://releases.ubuntu.com/20.04/SHA256SUMS"

  //
  // Accessing configuration files within the VM during the build
  //
  // Note that if a CD is used and bundle_iso is enabled, the CD will be copied into the image
  //

  http_bind_address = "0.0.0.0"
  http_content = {
    "/user-data"   = templatefile("${path.root}/../../config/cloudinit/autoinstall.pkrtpl.hcl", { var = var })
    "/meta-data"   = templatefile("${path.root}/../../config/cloudinit/metadata.pkrtpl.hcl", { var = var })
    "/vendor-data" = templatefile("${path.root}/../../config/cloudinit/vendordata.pkrtpl.hcl", { var = var })
  }

  //
  // Building the image
  //
  // We're using Virtualbox Beta to support Apple Arm chips. No SHA is available. Do not set
  // ssh_password or ssh_private_key_file in order to leverage Packer's automatic ephemeral key
  // generation. Access public key with {{ .SSHPublicKey | urlquery }}
  //

  // Only used if guest_additions_mode = attach. Defaults to value in iso_interface
  headless                  = false
  cpus                      = 2
  memory                    = 1024
  sound                     = "none"
  usb                       = false
  guest_additions_interface = "sata"
  guest_additions_mode      = "upload"
  guest_additions_path      = "/opt/virtualbox/VBoxGuestAdditions-${var.virtualbox_guest_additions_version}.iso"
  guest_additions_sha256    = "none"
  guest_additions_url       = "https://download.virtualbox.org/virtualbox/${var.virtualbox_guest_additions_version}/VBoxGuestAdditions_${var.virtualbox_guest_additions_version}.iso"
  acpi_shutdown             = false
  shutdown_command          = "echo 'packer' | sudo -S shutdown -P now"
  shutdown_timeout          = "5m"
  post_shutdown_delay       = "0s"
  vrdp_bind_address         = "127.0.0.1"
  virtualbox_version_file   = "/opt/virtualbox/.vbox_version"
  communicator              = "ssh"
  ssh_port                  = 22
  ssh_username              = "packer"
  ssh_password              = "packer"
  // Path to user certificate used to authenticate with SSH
  // ssh_certificate_file = ""
  // Path to a PEM encoded private key file to use to authenticate with SSH
  // ssh_private_key_file = ""
  // Use the local SSH agent to authenticate to the instance. Don't create a temporary keypair.
  // Don't use ssh_password and ssh_private_key_file. Env var SSH_AUTH_SOCK must be set
  ssh_agent_auth               = false
  ssh_pty                      = false
  ssh_timeout                  = "5m" // Noop if ssh_handshake_attempts is set
  ssh_handshake_attempts       = 10
  ssh_keep_alive_interval      = "5s"
  ssh_disable_agent_forwarding = false
  ssh_file_transfer_method     = "sftp"
  pause_before_connecting      = "0s"
  skip_nat_mapping             = false
  boot_command = [
    "<wait><wait><wait><esc><esc><esc><enter><wait><wait><wait>",
    "/casper/vmlinuz root=/dev/sr0 initrd=/casper/initrd autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/user-data/",
    "<enter>"
  ]
  boot_wait = "10s"

  //
  // Exporting the image
  //
  // Note that bundle_iso copies all attached CDs (ISOs) into the image.
  //

  format           = "ova"
  keep_registered  = false
  skip_export      = false
  bundle_iso       = false
  output_directory = "${path.root}/build/ubuntu/2004"
  output_filename  = "ubuntu2004-arm64"
  // https://www.virtualbox.org/manual/ch09.html#vboxmanage-export
  export_opts = [
    "--manifest",
    "--description", "${var.vm_description}",
    "--version", "${var.vm_version}"
  ]
}

source "vmware-iso" "vm" {}

source "qemu" "vm" {
  // Values for some options can be listed by `qemu-system-aarch64 -<option> help`

  //
  // Final Image Configuration
  //
  // vboxmanage_post runs after the vm is shutdown and before the vm is exported
  //
  efi_boot          = var.vm_firmware.is_uefi
  efi_firmware_code = var.vm_firmware.qemu_code
  efi_firmware_vars = var.vm_firmware.qemu_vars
  cpu_model         = "host"
  accelerator       = "hvf" # kvm is the backup on macOS
  // cdrom_interface      = "virtio-scsi" // virtio-scsi if having problems
  disk_additional_size = [] // Additional disks to create
  disk_interface       = "virtio"
  disk_size            = "21475M"
  disk_compression     = false
  disk_discard         = "unmap"
  disk_detect_zeroes   = "unmap"
  machine_type         = "virt"
  net_device           = var.vm_host_is_mac ? "vmnet-bridged" : "virtio-net-pci"

  // This bridge must already exist before running Packer and using libvirt. The virbr0 bridge the
  // default network created by libvirt. Only works on Linux
  net_bridge  = var.vm_host_is_mac ? null : "virbr0"
  qemu_binary = "qemu-system-aarch64"
  qemuargs = [
    // Override Packer's QMP settings for mux and customization
    ["-chardev", "socket,id=char0,path=${path.root}/../../build/ubuntu/2004/build.monitor,mux=on,server=on,wait=off"],
    ["-mon", "chardev=char0,mode=control,pretty=on"],
    // ["-serial", "vc:1280x720"],
    ["-serial", "vc:1200x1200"],
    // Enable USB and the usb-table for better mouse position control and prevent mouse capture
    ["-usb"],
    ["-device", "nec-usb-xhci,id=usb-bus"],
    ["-device", "usb-tablet,bus=usb-bus.0"],
    ["-device", "usb-mouse,bus=usb-bus.0"],
    ["-device", "usb-kbd,bus=usb-bus.0"],
    // Enable graphics driver
    // ["-device", "virtio-gpu-pci"],
    // Add Random Number Generator
    ["-device", "virtio-rng-pci"],
    // HVF: May need to add if guest OS is having issues
    // ["-global", "virtio-pci.disable-modern=on"]
    // Create network bus for vmnet on Mac
    (var.vm_host_is_mac ? ["-device", "virtio-net-device,mac=4E:D6:E5:53:AA:F9,netdev=user.0"] : []),
  ]
  use_default_display = false // Set to true for sdl errors on mac
  display             = "${var.vm_host_is_mac ? "cocoa" : "gtk"}"

  //
  // Installing the Guest OS
  //

  iso_urls = [
    "${var.vm_iso_url.arm64.local}",
    "${var.vm_iso_url.arm64.remote}"
  ]
  iso_checksum   = "sha256:${var.vm_iso_checksum_sha256.arm64}" // "file:" for urls
  iso_skip_cache = false

  //
  // Accessing configuration files within the VM during the build
  //
  // Note that if a CD is used and bundle_iso is enabled, the CD will be copied into the image
  //

  http_bind_address = "0.0.0.0"
  http_content = {
    "/user-data"      = templatefile("${path.root}/../../config/cloudinit/autoinstall.pkrtpl.hcl", { var = var })
    "/meta-data"      = templatefile("${path.root}/../../config/cloudinit/metadata.pkrtpl.hcl", { var = var })
    "/vendor-data"    = templatefile("${path.root}/../../config/cloudinit/vendordata.pkrtpl.hcl", { var = var })
    "/network-config" = templatefile("${path.root}/../../config/cloudinit/network-config.pkrtpl.hcl", { var = var })
  }

  //
  // Building the image
  //
  // We're using Virtualbox Beta to support Apple Arm chips. No SHA is available. Do not set
  // ssh_password or ssh_private_key_file in order to leverage Packer's automatic ephemeral key
  // generation. Access public key with {{ .SSHPublicKey | urlquery }}
  //

  headless             = false
  cpus                 = 4 // cpus = sockets * cores (per socket) * threads (per core)
  sockets              = 1
  cores                = 4
  threads              = 1
  memory               = 4096
  communicator         = "ssh"
  ssh_port             = 22
  ssh_username         = var.user_name
  ssh_password         = var.user_password
  ssh_certificate_file = null // Noop if ssh_agent_auth is set
  ssh_private_key_file = null // Noop if ssh_agent_auth is set
  ssh_agent_auth       = false
  ssh_pty              = false
  ssh_timeout          = "45m" // Noop if ssh_handshake_attempts is set
  // ssh_handshake_attempts       = 10
  ssh_keep_alive_interval      = "5s"
  ssh_disable_agent_forwarding = false
  ssh_file_transfer_method     = "sftp"
  pause_before_connecting      = "0s"
  skip_nat_mapping             = false
  shutdown_command             = "echo 'packer' | sudo -S shutdown -P now"
  shutdown_timeout             = "5m"
  vnc_bind_address             = "127.0.0.1"
  vnc_use_password             = false
  qmp_enable                   = false
  qmp_socket_path              = "${path.root}/../../build/ubuntu/2004/build.monitor"
  boot_wait                    = "10s"
  boot_key_interval            = "25ms"
  boot_command = [
    "c<wait>",
    "search --file /casper/vmlinuz<enter>",
    "search --set=root --file /casper/vmlinuz<enter>",
    // "set gfxpayload=text<enter>", // keep, auto, or text
    // "insmod all_video<enter>",
    "linux /casper/vmlinuz",
    " root=/dev/cd0",
    // " console=ttyS0",
    " initrd=/casper/initrd",
    " autoinstall 'ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter>",
    "initrd /casper/initrd<enter>",
    "boot",
    "<wait5>",
    "<enter>",
    // "<wait15><down><enter>"
  ]

  //
  // Exporting the image
  //
  // Note that bundle_iso copies all attached CDs (ISOs) into the image.
  //

  format           = "qcow2"
  output_directory = "${path.root}/../../build/ubuntu/2004"
  vm_name          = "${var.vm_name.file}"
}