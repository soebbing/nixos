{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/13-7390>
    ../hardware-scans/syn.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
    ../modules/desktop/manager/gnome.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.gfxmodeEfi = "1600x1200";
#  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/disk/by-uuid/4e55509a-3a96-4792-826d-af55a36c1a60";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "syn";
  services.xserver.layout = "de";
  
  i18n = {
    defaultLocale = "de_DE.UTF-8";
  };
  console.font = "Lat2-Terminus16";
  console.keyMap = "de";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  boot.kernelParams = [ "acpi_rev_override" ];
#  boot.extraModprobeConfig = "install nouveau /run/current-system/sw/bin/false";
#  hardware.bumblebee.enable = true;
#  hardware.bumblebee.connectDisplay = true;
}
