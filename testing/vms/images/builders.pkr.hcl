build {
  sources = local.enabled_sources

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
