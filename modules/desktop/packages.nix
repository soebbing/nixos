{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    jetbrains.phpstorm
    jetbrains.jdk
    kbfs
    keybase
    keybase-gui
    google-chrome
    firefox
    thunderbird
    vscodium
    shyim.php74
    php73Packages.composer
    nodejs-13_x
    gnupg
    insomnia
    xclip
    travis
    spotify
    shyim.swdc
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
