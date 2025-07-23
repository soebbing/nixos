{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ../hardware-scans/mac.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
#    ../modules/desktop/manager/pantheon.nix
#    ../modules/desktop/manager/xfce.nix
    ../modules/desktop/manager/gnome.nix
#    ../modules/desktop/manager/kde.nix
#    ../modules/desktop/manager/i3.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/95d43e30-da84-46cf-8051-fcffe34b9cf4";
      allowDiscards = true;
      preLVM = true;
    };
  };

  networking.hostName = "syn";
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

#  virtualisation.virtualbox.host.enable = true;
#  users.extraGroups.vboxusers.members = [ "hendrik" ];
}
