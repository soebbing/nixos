{ config, pkgs, ... }:

{
  imports = [
    ../modules/base
    ../modules/desktop
    ../modules/desktop/manager/pantheon.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "yoko";
  i18n.consoleKeyMap = "de";
  services.xserver.layout = "de";

  programs.adb.enable = true;

  virtualisation.vmware.guest.enable = true;
  environment.systemPackages = with pkgs; [
    discord-ptb
    nixfmt
    go
    shyim.wrangler
    shyim.webdis
  ];
}
