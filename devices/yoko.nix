{ config, pkgs, ... }:

{
  imports = [ ../modules/base ../modules/desktop ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "yoko";
  i18n.consoleKeyMap = "de";
  services.xserver.layout = "de";
  services.xserver.videoDrivers = [ "nvidia" ];

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [ discord-ptb nixfmt go ];
}
