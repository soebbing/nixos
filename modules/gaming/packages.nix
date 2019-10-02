{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    steam
    wine-staging
    winetricks
    lutris-unwrapped
    appimage-run
    discord-ptb
  ];
}
