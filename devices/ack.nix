{ config, pkgs, ... }:

{
  imports = [
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
  ];

  hendrik.desktop = "i3";

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "ack";
  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";
}
