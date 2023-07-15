packer {
  required_version = ">= 1.9.0"
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "virtualbox-iso" "x86_64" {
  iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
  iso_checksum     = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}
source "virtualbox-iso" "arm64" {
  iso_url          = "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
  iso_checksum     = "file:https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}
// source "vmware-iso" "x86_64" {
//   iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
//   iso_checksum = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
//   shutdown_command = "shutdown -P now"
// }
// source "vmware-iso" "arm64" {
//   iso_url = "https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
//   iso_checksum = "file:https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS"
//   shutdown_command = "shutdown -P now"
// }

build {
  sources = [
    "sources.virtualbox-iso.arm64",
    "sources.vmware-iso.arm64"
  ]
  post-processors {
    post-processor "artifice" {
      files = [
        "output-virtualbox-iso/vbox-example-disk001.vmdk",
        "output-virtualbox-iso/vbox-example.ovf"
      ]
    }
    post-processor "vagrant" {
      keep_input_artifact = true
      provider_override   = "virtualbox"
    }
    post-processor "vagrant" {
      keep_input_artifact  = true
      include              = ["image.iso"]
      output               = "proxycore_{{.Provider}}.box"
      vagrantfile_template = "vagrantfile.tpl"
    }
    post-processor "vagrant-cloud" {
      access_token = "${var.cloud_token}"
      box_tag      = "hashicorp/precise64"
      version      = "${local.version}"
    }
  }
}