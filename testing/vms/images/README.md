# Overview

Most Vagrant boxes out there are not compatible with Apple Silicon arm64 chips so we have to make our own. Should also come in handy when testing systems deployed to arm64 VMs in the cloud. This folder contains automated builders of base images and boxes for Vagrant and other hardware or virtual systems using Packer, Virtualbox, VMWare, QEMU, and Parallels.

Current state of the builders

| Builder/App | Status        | Reason                                                                                          |
| :---------- | :------------ | ----------------------------------------------------------------------------------------------- |
| Virtalbox   | `Blocked`     | Virtualbox does not fully support arm64 on Apple Silicon yet                                    |
| VMWare      | `In progress` |
| QEMU        | `Blocked`     | Currently blocked by lack of support for Apple's `vmnet` on Apple's hypervisor framework, `hvf` |
| Parallels   | `Not started` |

## The struggle is real

Apple moved away from traditional TUN/TAP infra for virtualization starting with the M1. They created their own hypervisor framework (`hvf`) and added entitlements that _signed_ apps need to have in order to use this framework in user space, w/o running as root. When combined these work together to automate the creation of network interfaces and bridges that you can attach to VMs like normal. Apple asks you to talk to your sales rep to get official access to the entitlement. This has created another hurdle to overcome when trying to virtualize arm64 machines on macOS.

Current state of virtualization software

- Virtualbox is in beta, but currently crashes when booting a barebones Ubuntu 20.04 arm64 VM.
- QEMU supports `hvf` and `vmnet`, but it is not signed and doesn't seem to have plans to be signed.
  - Currently it does not ship with `vmnet` support built in nor does it seem you can build from source to bake it in easily. `--enable-vnmet` did not produce a build that included `vmnet-*` devices.
  - Libvirt has the same signing and entitlement issues when trying to create network interfaces
  - The UTM app has custom built QEMU and other tools and has full signed support of `vmnet`, but you can't use it with Packer. Manual box builds to raw or qcow2
  - I'm uncertain if qcow2 or raw images are supported by Vagrant.
- VMWare: TBD
- Parallels: TBD - Might be the best option right now given that they are close partners with Apple and claim they support arm64 on Apple Silicon, including automating with Packer.

# Useful resources

<details>
<summary>Packer</summary>

- [QEMU Builder](https://developer.hashicorp.com/packer/plugins/builders/qemu)

</details>

<details>
<summary>Linux</summary>

- [Kernel Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
- [Grub Manual](https://www.gnu.org/software/grub/manual/grub/grub.html)
- [Ubuntu Autoinstaller Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [Config-Init Reference](https://cloudinit.readthedocs.io/en/latest/reference/index.html)
- [Config-Init Curtain Reference](https://curtin.readthedocs.io/en/latest/topics/config.html)
- [Netplan Documentation](https://netplan.readthedocs.io/en/stable/)

</details>
<details>
<summary>QEMU</summary>

- [CLI Ref](https://www.qemu.org/docs/master/system/invocation.html)

</details>
<details>
<summary>KVM, Libvirt, and friends</summary>

- [Libvirt Networking Ref](https://wiki.libvirt.org/Networking.html)

</details>

# Gotchas

## Virtualization

### QEMU

Can't use `vmnet-(host|bridged|shared)` devices on macOS.

- https://gitlab.com/qemu-project/qemu/-/issues/1364

### Libvirt

Can't create a properly named bridge interface on macOS

- https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1449
- https://gitlab.com/libvirt/libvirt/-/issues/75
- Alternatives
  - https://github.com/lima-vm/socket_vmnet
  - https://gist.github.com/max-i-mil/f44e8e6f2416d88055fc2d0f36c6173b
  - https://gist.github.com/max-i-mil/f44e8e6f2416d88055fc2d0f36c6173b
  - https://www.sobyte.net/post/2022-10/mac-qemu-bridge/

## Operating systems

### Ubuntu 20.04

Failing to unmount cdrom (ISOs) leading to installer boot loops

- https://bugs.launchpad.net/subiquity/+bug/1901397
- https://github.com/hashicorp/packer-plugin-qemu/issues/66#issuecomment-1466049817
  > Note that `sed` is also available so it doesn't have to be `perl` doing the regex
- https://www.linuxbabe.com/command-line/how-to-use-linux-efibootmgr-examples

## Alpine v?.?.?

Failing to unmount cdrom (ISOs) leading to installer boot loops

- https://github.com/hashicorp/packer-plugin-qemu/issues/125

## Automation Tools

### Cloud-Init

Failing to apply a proper Netplan config leading to a hung boot at `cloudinit[678]`

- https://askubuntu.com/a/1405307
- https://bugs.launchpad.net/ubuntu/+source/netplan.io/+bug/1906187
- https://bugs.launchpad.net/ubuntu/+source/cloud-init/+bug/1958377
