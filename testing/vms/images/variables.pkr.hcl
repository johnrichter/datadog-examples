variable "enabled_hypervisors" {
  type        = list(string)
  description = "What builders should we use? vbox, vmware, qemu, parallels"
}
variable "keep_vm_artifact" {
  type = bool
  description = "Keep the resulting VM and do not delete it"
}
variable "host_machine" {
  type = object({
    is_mac = bool
    mac = object({
      use_vmnet = bool
    })
  })
  description = "Host information used for configuring hypervisors"
}
variable "vm_filename" {
  type        = string
  description = "The name of the exported VM file without extension"
}
variable "vm_version" {
  type        = string
  description = "The version of the VM (not the OS)"
}
variable "vm_description" {
  type        = string
  description = "The description of the VM"
  default     = "A base Ubuntu image"
}
variable "vm_os" {
  type = object({
    name    = string
    version = string # Semver
    arch    = string
  })
  description = "VM Operating System metadata"
}
variable "vm_use_uefi" {
  type        = bool
  description = "Use a UEFI bios"
}
variable "qemu" {
  type = object({
    firmware = object({
      bios = string
      uefi = object({
        code = string
        vars = string
      })
    })
  })
  description = "QEMU firmware configuration"
  default = {
    firmware = {
      bios = ""
      uefi = {
        code = ""
        vars = ""
      }
    }
  }
}
variable "virtualbox_guest_additions_version" {
  type        = string
  description = "Version of the Virtualbox Guest Additions to install"
  default     = ""
}
variable "vm_is_vagrant_box" {
  type        = bool
  description = "The VM will be built into a Vagrant box"
}
variable "min_vagrant_version" {
  type        = string
  description = "Minimum version of Vagrant required to run this box. Semver."
}
variable "vagrant_cloud_access_token" {
  type        = string
  description = "Vagrant Cloud access token for uploading boxes"
}
variable "hostname" {
  type        = string
  description = "The host's name"
}
variable "hostname_fqdn" {
  type        = string
  description = "The host's fully qualified domain name"
}
variable "system_groups" {
  type        = map(list(string))
  description = "A map of system user groups to create and what users below to what groups"
}
variable "ntp_enabled" {
  type        = bool
  description = "Enable or disable NTP on the system"
}
variable "ssh_enable_password_authentication" {
  type        = bool
  description = "Let's users login over ssh with a password"
}
variable "ssh_delete_host_keys" {
  type        = bool
  description = "Remove any host ssh keys that may have been included in the base image/OS"
}
variable "packages" {
  type        = object({
    essentials = list(string)
    extras = list(string)
  })
  description = "List of packages to install on boot"
}
variable "packages_update" {
  type        = bool
  description = "Update package caches on boot"
}
variable "packages_upgrade" {
  type        = bool
  description = "Upgrate system packages on boot"
}
variable "packages_reboot_if_required" {
  type        = bool
  description = "Reboot if required to after installing or upgrading packages"
}
variable "user_realname" {
  type        = string
  description = "The user's real name"
}
variable "user_name" {
  type        = string
  description = "The user's username"
}
variable "user_password" {
  type        = string
  description = "The user's password"
}
variable "user_password_crypted" {
  type        = string
  description = "The openssl-passwd crypted text password of the user"
}
variable "user_ssh_authorized_key_blobs" {
  type        = list(string)
  description = "Public SSH Keys for the user"
}
variable "user_groups" {
  type        = list(string)
  description = "Groups the user belongs to"
}
variable "user_sudo_config" {
  type        = string
  description = "The user's sudo configuration (without the leading username)"
}