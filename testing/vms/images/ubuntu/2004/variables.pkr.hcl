variable "vm_host_is_mac" {
  type        = bool
  description = "Is the metal host running macOS?"
}
variable "vm_name" {
  type = object({
    human = string
    file  = string
  })
  description = "The name of the VM and names of its assets"
}
variable "vm_version" {
  type        = string
  description = "The version of the VM"
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
variable "vm_firmware" {
  type = object({
    is_uefi   = bool
    qemu_code = string
    qemu_vars = string
  })
  description = "Firmware configuration"
}
variable "vm_iso_checksum_sha256" {
  type = object({
    arm64  = string
    x86_64 = string
  })
}
variable "vm_iso_url" {
  type = object({
    arm64 = object({
      local  = string
      remote = string
    })
    x86_64 = object({
      local  = string
      remote = string
    })
  })
  description = "Local and remote URLs to the OS ISO image"
}
variable "vm_iso_checksum_url" {
  type = object({
    arm64  = string
    x86_64 = string
  })
  description = "A url to the ISO SHA256 checksums"
}
variable "virtualbox_guest_additions_version" {
  type        = string
  description = "Version of the Virtualbox Guest Additions to install"
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
  type        = list(string)
  description = "A list of system user groups to create"
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
  type        = list(string)
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