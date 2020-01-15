{ config, pkgs, ... }:

{
  imports = [
    ../hardware-scans/mac.nix
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
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = [
    { 
      name = "root";
      device = "/dev/disk/by-uuid/95d43e30-da84-46cf-8051-fcffe34b9cf4";
      allowDiscards = true;
      preLVM = true;
    }
  ];

  networking.hostName = "syn";
  #console.keyMap = "de";
  services.xserver.layout = "de";
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "hendrik" ];
}
