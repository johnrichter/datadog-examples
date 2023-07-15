build {
  sources = locals.enabled_sources

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = abspath("${path.root}/../../../boxes/ubuntu-2004-{{.Provider}}-${source.name}.box")
      vagrantfile_template = "${path.root}/../../config/vagrant/Vagrantfile"
      // provider_override = "" // Required if using Artifice
    }
    // post-processor "vagrant-cloud" {
    //   access_token = "${var.vagrant_cloud_access_token}"
    //   box_tag      = "hashicorp/precise64"
    //   version      = "${local.version}"
    // }
  }
}
