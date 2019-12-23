{ config, pkgs, ... }:

{
  imports = [
    ../hardware-scans/aki.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
    ../modules/desktop/manager/i3.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/disk/by-uuid/357e67b2-546d-4632-b197-b03c6facf271";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "aki";
  console.keyMap = "de";
  services.xserver.layout = "de";

  boot.kernelParams = [ "acpi_rev_override" ];
  boot.extraModprobeConfig = "install nouveau /run/current-system/sw/bin/false";
  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "shyim" ];
}
