{ config, pkgs, ... }:

{
  imports =
    [ ../modules/base ../modules/desktop ../modules/desktop/notebook.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "mei";
  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";
}
