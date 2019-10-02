{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = import ../../pkgs/overlays;
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    phpstorm
    jetbrains.jdk
    kbfs
    keybase
    keybase-gui
    google-chrome
    firefox
    thunderbird
    vscodium
    php73
    php73Packages.composer
    gnupg
    insomnia
    xclip
    travis
    spotify
    swdc
    rclone
    nixops

    # I3
    (polybar.override { i3Support = true; })
    rofi
    arandr
    pavucontrol
    filezilla
    xfce.thunar
    playerctl
    blueman
    feh
    networkmanagerapplet
    kitty
    escrotum
  ];

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-sans-pro ];
}
