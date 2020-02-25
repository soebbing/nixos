{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      docker
      docker-compose
      docker-sync
      dive
      phpstorm
      jetbrains.rider
      vscode
      kbfs
      keybase
      keybase-gui
      google-chrome
      firefox
      inkscape
      libreoffice
      php74
      php74Packages.composer
      php74Packages.phpstan
      nodejs-12_x
      gnupg
      insomnia
      xclip
      spotify
      rclone
      nixops
      gnumake
      terraform
      ffsend
      shellcheck
      fzf
      tldr
      lm_sensors

      transmission-gtk
      networkmanagerapplet
      xfontsel

      gtk3
      hicolor_icon_theme
      shared_mime_info

      dunst
      libnotify
      xautolock

      enpass
      mullvad-vpn
      libxkbcommon
      qt5.qtwayland
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-emoji
    source-sans-pro
    fira-code
  ];
}
