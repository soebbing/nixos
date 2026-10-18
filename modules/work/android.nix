{ config, pkgs, lib, ... }:

let
  cfg = config.hendrik.android;
in
{
  options.hendrik.android = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      When true, load the KVM kernel module, add the user to the
      `kvm` group, install qemu/libvirt/adb system-wide, and act as
      the gate for the matching home-manager Android module.
    '';
  };

  config = lib.mkIf cfg {
    # 12th-gen Intel exposes VMX; loading `kvm-intel` eagerly avoids a
    # first-emulator race where the module isn't ready in time. `tun` is
    # needed by the emulator's user-mode networking fallback on some
    # libc / kernel combinations.
    boot.kernelModules = [ "kvm-intel" "tun" ];

    # Membership in `kvm` is what lets qemu open /dev/kvm as the user
    # without setuid. Additive — `libvirtd` is added in devices/lenovo-t14.nix.
    users.users.hendrik.extraGroups = [ "kvm" ];

    environment.systemPackages = with pkgs; [
      qemu # qemu-kvm, qemu-img, qemu-system-x86_64
      libguestfs-with-appliance # virt-cat, virt-ls for VM image inspection
      libvirt # virsh + virt-install CLIs
      adb # adb / fastboot on system PATH
    ];
  };
}
