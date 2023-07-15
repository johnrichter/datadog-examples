# Useful resources

Packer

- [QEMU Builder](https://developer.hashicorp.com/packer/plugins/builders/qemu)

Linux

- [Kernel Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
- [Grub Manual](https://www.gnu.org/software/grub/manual/grub/grub.html)
- [Ubuntu Autoinstaller Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [Config-Init Reference](https://cloudinit.readthedocs.io/en/latest/reference/index.html)
- [Config-Init Curtain Reference](https://curtin.readthedocs.io/en/latest/topics/config.html)
- [Netplan Documentation](https://netplan.readthedocs.io/en/stable/)

QEMU

- [CLI Ref](https://www.qemu.org/docs/master/system/invocation.html)

KVM and Libvirt

- [Libvirt Networking Ref](https://wiki.libvirt.org/Networking.html)

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
  - https://github.com/lima-vm/socket_vmnet#from-homebrew
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

- https://bugs.launchpad.net/ubuntu/+source/netplan.io/+bug/1906187
- https://askubuntu.com/a/1405307
