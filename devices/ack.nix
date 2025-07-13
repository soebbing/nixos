{ config, pkgs, ... }:

{
  imports = [
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/desktop/manager/i3.nix
  ];

  boot.loader.grub.enable = true;^
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "ack";
  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";
}
