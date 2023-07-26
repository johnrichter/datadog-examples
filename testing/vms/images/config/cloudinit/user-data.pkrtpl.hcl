#cloud-config

# TOOD: MATCH CONFIG WITH WHAT IS IN AUTOCONF

# Alpine Linux: Configuration of the /etc/apk/repositories file
apk_repos:
  alpine_repo:
    # Whether to add the Community repo to the repositories file
    community_enabled: true
    version: "latest-stable"

# Configure apt for the user
apt:
  # Entries in the sources list can be disabled (commented out). If the string $RELEASE is
  # present in a suite in the disable_suites list, it will be replaced with the release name
  #   * updates => $RELEASE-updates
  #   * backports => $RELEASE-backports
  #   * security => $RELEASE-security
  #   * proposed => $RELEASE-proposed
  #   * release => $RELEASE
  disable_suites:
    - "backports"
    - "proposed"

# This module configures the final message that cloud-init writes. The message is specified a
# a jinja template with the following variables set
#   * version: cloud-init version
#   * timestamp: time at cloud-init finish
#   * datasource: cloud-init data source
#   * uptime: system uptime
final_message: |
  cloud-init has finished
  version: $version
  timestamp: $timestamp
  datasource: $datasource
  uptime: $uptime

# Growpart resizes partitions to fill the available disk space
growpart:
  # The utility to use for resizing. Possible options
  #   * auto - Use any available utility
  #   * growpart - Use growpart utility
  #   * gpart - Use BSD gpart utility
  #   * off - Take no action
  mode: "auto"

  # he devices to resize. Each entry can either be the path to the device’s mountpoint in the
  # filesystem or a path to the block device in ‘/dev’
  devices:
    - "/"

  # If true, ignore the presence of /etc/growroot-disabled. If false and the file exists, then
  # don’t resize
  ignore_growroot_disabled: false

# Resize a filesystem to use all avaliable space on partition. Will ensure that if the root
# partition has been resized the root filesystem will be resized along with it. False to disable
resize_rootfs: true

# Enable and configure ntp
ntp:
  enabled: ${jsonencode(var.ntp_enabled)}

# A list of packages to install during boot. Each entry in the list can be either a package name
# or a list with two entries, the first being the package name and the second being the specific
# package version to install
packages: ${jsonencode(var.packages.essentials)}

# Set true to update packages. Happens before upgrade or install
package_update: ${jsonencode(var.packages_update)}

# Set true to upgrade packages. Happens before install
package_upgrade: ${jsonencode(var.packages_upgrade)}

# Set true to reboot the system if required by presence of /var/run/reboot-required
package_reboot_if_required: ${jsonencode(var.packages_reboot_if_required)}

# Handles shutdown/reboot after all config modules have been run
power_state:
  # Time in minutes to delay after cloud-init has finished. Can be now or an integer specifying
  # the number of minutes to delay
  delay: "now"

  # Must be one of poweroff, halt, or reboot
  mode: "reboot"

  # Optional message to display to the user when the system is powering off or rebooting
  message: "Rebooting"

  # Time in seconds to wait for the cloud-init process to finish before executing shutdown
  timeout: 30

  # Apply state change only if condition is met
  condition: true

# Provide random seed data
random_seed:
  # File to write random data to
  file: "/dev/urandom"

  # This data will be written to file before data from the datasource. When using a multiline
  # value or specifying binary data, be sure to follow yaml syntax and use the | and !binary
  # yaml format specifiers when appropriate
  data: >-
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}
    ${sha512(uuidv4())}

  # Used to decode data provided. Allowed values are raw, base64, b64, gzip, or gz
  encoding: "raw"

# The hostname to set
hostname: "${var.hostname}"

# The fully qualified domain name to set
fqdn: "${var.hostname_fqdn}"

# If true, the fqdn will be used if it is set. If false, the hostname will be used. If unset,
# the result is distro-dependent
prefer_fqdn_over_hostname: true

# Sets whether or not to accept password authentication
ssh_pwauth: ${jsonencode(var.ssh_enable_password_authentication)}

# Remove host SSH keys. This prevents re-use of a private host key from an image with default
# host SSH keys
ssh_deletekeys: ${jsonencode(var.ssh_delete_host_keys)}

# If true, SSH fingerprints will not be written
no_ssh_fingerprints: false

# The hash type to use when generating SSH fingerprints
authkey_hash: "sha512"

# Disable root login
disable_root: true

# Disable root login options
disable_root_opts: >-
  no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"${var.user_name}\" rather than the user \"$DISABLE_USER\".';echo;sleep 10;exit 142"

# Create users and passwords
chpasswd:
  # Whether to expire all user passwords such that a password will need to be reset on the
  # user’s next login
  expire: false

# Groups to add to the system. Groups are added before users, so any users in a group list
# must already exist on the system
# groups: ${jsonencode(var.system_groups)}

# Users to add to the system. the reserved string default which represents the primary admin
# user used to access the system. The default user varies per distribution and is generally
# configured in /etc/cloud/cloud.cfg by the default_user key.
#
# Specifying a hash of a user’s password with passwd is a security risk if the cloud-config can
# be intercepted. SSH authentication is preferred.
#
# If specifying a sudo rule for a user, ensure that the syntax for the rule is valid, as it is
# not checked by cloud-init.
#
# Most of these configuration options will not be honored if the user already exists. The
# following options are the exceptions; they are applied to already-existing users:
# plain_text_passwd, hashed_passwd, lock_passwd, sudo, ssh_authorized_keys, ssh_redirect_user.
users:
  - name: "${var.user_name}"

    # The user’s ID. Default is next available value
    # uid:

    # Hash of user password to be applied. This will be applied even if the user is
    # pre-existing. To generate this hash, Run
    #  * `python3 -c 'import secrets; print(secrets.token_hex(8))'`
    #  * `openssl passwd -6 -salt 'rounds=4096$<output from above>'
    # hashed_passwd: "${var.user_password_crypted}"
    passwd: "${var.user_password_crypted}"

    # Disable password login
    lock_passwd: false

    # Create user as system user with no home directory
    system: false

    # Optional comment about the user, usually a comma-separated string of real name and
    # contact information
    gecos: "${var.user_realname}"

    # List of groups to add the user to
    #groups: "users,admin"
    #groups: "${join(",", var.user_groups)}"
    groups: ${jsonencode(var.user_groups)}

    # Create specified user groups
    create_groups: true

    # Primary group for user
    primary_group: "${var.user_name}"

    # Do not create a group named after user
    no_user_group: false

    # Do not create home directory
    no_create_home: false

    # Home dir for user
    homedir: "/home/${var.user_name}"

    # Path to the user’s login shell. The default is to set no shell, which results in a
    # system-specific default being used
    shell: "/bin/bash"

    # List of SSH keys to add to user’s authkeys file
    ssh_authorized_keys: ${jsonencode(var.user_ssh_authorized_key_blobs)}

  - name: "${var.user_name}"

    # Sudo rule to use or false. Absence of a sudo value or null will result in no sudo
    # rules added. Seem to only be a valid field for existing users
    # sudo: "${var.user_name} ${var.user_sudo_config}"
    sudo: "${var.user_sudo_config}"
