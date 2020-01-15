{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    docker docker-compose docker-sync
    shyim.phpstorm
    kbfs
    keybase
    keybase-gui
    google-chrome
    firefox
    thunderbird
    vscode-ext
    inkscape
    libreoffice
    php73
    php73Packages.composer
    php73Packages.phpstan
    nodejs-12_x
    gnupg
    insomnia
    xclip
    travis
    spotify
    rclone
    nixops
    gnumake
    terraform
    ffsend
    shellcheck
    fzf
    tldr

    transmission
    networkmanagerapplet
    xfontsel

    gtk3 hicolor_icon_theme shared_mime_info

    dunst libnotify
    xautolock

    kbfs keybase keybase-gui
  ];

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-sans-pro ];
}
