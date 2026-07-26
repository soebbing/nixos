{ config, pkgs, ... }:

{
  imports = [
    ../hardware-scans/mac.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
  ];

  hendrik.desktop = "gnome";

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
  ];

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

  networking.hostName = "mac";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  #  virtualisation.virtualbox.host.enable = true;
  #  users.extraGroups.vboxusers.members = [ "hendrik" ];
}
