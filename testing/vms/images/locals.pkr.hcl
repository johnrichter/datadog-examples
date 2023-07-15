locals {
    #
    # Lookup maps
    #
    hypervisors = {
      vbox = "virtualbox-iso"
      vmware = "vmware-iso"
      qemu = "qemu"
      parallels = "parallels"
    }
    architectures = {
        aarch64 = "arm64"
        x86_64 = "x86_64"
    }
    os_installers = {
        ubuntu_2004_arm64 = {
            iso_url = {
                local = ""
                remote ="https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.5-live-server-arm64.iso"
            }
            iso_checksum = {
                sha256 = "e42d6373dd39173094af5c26cbf2497770426f42049f8b9ea3e60ce35bebdedf"
                file = "https://cdimage.ubuntu.com/releases/20.04/release/SHA256SUMS"
            }
            build_command = [
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
            ]
        }
        ubuntu_2004_x86_64 = {
            iso_url = {
                local = ""
                remote ="https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
            }
            iso_checksum = {
                sha256 = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
                file = "https://releases.ubuntu.com/20.04/SHA256SUMS"
            }
            build_command = []
        }
        ubuntu_2204_arm64 = {
            iso_url = {
                local = ""
                remote ="https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.2-live-server-arm64.iso"
            }
            iso_checksum = {
                sha256 = ""
                file = "https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS"
            }
            build_command = []
        }
        ubuntu_2204_x84_64 = {
            iso_url = {
                local = ""
                remote ="https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
            }
            iso_checksum = {
                sha256 = ""
                file = "https://releases.ubuntu.com/22.04/SHA256SUMS"
            }
            build_command = []
        }
    }

    #
    # Runtime configuration
    #

    # Builders
    enabled_sources = [
      for hv in var.enabled_hypervisors : "source.${lookup(local.hypervisors, hv, "unknown")}"
    ]
}
