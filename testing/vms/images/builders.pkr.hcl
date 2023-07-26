build {
  sources = local.enabled_sources

  provisioner "file" {
    sources = [
      abspath("${local.provisioning_config_dir}/netplan")
    ]
    destination = "/tmp/"
  }

  provisioner "shell" {
    pause_before      = "30s"
    execute_command   = "echo '${var.user_password}' | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    env = {
      DEBIAN_FRONTEND     = "noninteractive"
      PACKAGES_TO_INSTALL = join(" ", var.packages.extras)
      USER_PASSWORD       = var.user_password
    }
    scripts = [
      for f in fileset("${local.provisioning_config_dir}", "${var.vm_os.name}/**/*.sh") : "${local.provisioning_config_dir}/${f}"
    ]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = var.keep_vm_artifact
      compression_level    = 9
      output               = abspath("${local.vagrant_boxes_dir}/${var.vm_os.name}-${var.vm_os.version}-${var.vm_os.arch}-{{.Provider}}.box")
      vagrantfile_template = abspath("${local.vagrant_config_dir}/Vagrantfile")
    }
    post-processor "vagrant-cloud" {
      access_token        = var.vagrant_cloud_access_token
      box_tag             = var.vagrant.cloud.box_tag != "" ? var.vagrant.cloud.box_tag : local.vagrant_cloud_box_tag
      no_release          = var.vagrant.cloud.skip_upload
      keep_input_artifact = true
      version             = var.vm_version
      version_description = <<EOT
        ${var.vm_description}${var.vagrant.cloud.version_description}
      EOT
    }
  }
}
