variable "vm_version" {
  type        = string
  description = "The version of the VM"
}
variable "vm_description" {
  type        = string
  description = "The description of the VM"
  default     = "A base Ubuntu 20.04.x image"
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
  description = "The plain text password of the user"
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