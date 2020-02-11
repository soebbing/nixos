{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/13-7390>
    ../hardware-scans/syn.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
#    ../modules/desktop/manager/xfce.nix
    ../modules/desktop/manager/gnome.nix
#    ../modules/desktop/manager/i3.nix
  ];

  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    version = 2;
    device = "nodev";
    gfxmodeEfi = "1600x1200";
  };
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1f51db2c-4205-4ca7-a4f8-9cc46e836e74";
      fsType = "btrfs";
      options = [ "subvol=nixos" "noatime" "nodiratime" "discard" ];
    };

  boot.initrd.luks.devices."nixenc".device = "/dev/disk/by-uuid/843710eb-d94e-4929-ab29-338525889afe";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C349-E5E2";
      fsType = "vfat";
    };

  swapDevices = [{ device = "/dev/disk/by-uuid/658684d9-f7a1-43d9-b92a-ba011aed4186"; }];

  networking.hostName = "syn";
  networking.hostId = "16bee688";
  networking.hosts = {
    "127.0.0.1" = [
      "traefik.shopmacher.example"
      "portainer.shopmacher.example"
      "traefik.handcoding.example"
      "portainer.handcoding.example"
      "www.unixtimestamp.example"
      "www.convert-unix-timestamp.example"
      "www.download-handbuch.example"
      "www.manuals-online.example"
      "www.canastapp.example"
      "www.djplaymysong.example"
      "www.auctionmap.example"
    ];
    "10.10.20.81" = [
      "virt.loungedreams.com"
    ];
  };

  boot.kernelParams = [ "acpi_rev_override" ];

  hardware.cpu.intel.updateMicrocode = true;
}
