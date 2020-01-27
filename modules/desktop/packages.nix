{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      docker
      docker-compose
      docker-sync
      shyim.phpstorm
      vscode
      kbfs
      keybase
      keybase-gui
      google-chrome
      firefox
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

      gtk3
      hicolor_icon_theme
      shared_mime_info

      dunst
      libnotify
      xautolock

      enpass
      libxkbcommon
      qt5.qtwayland
  ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    nerdfonts
    font-awesome-ttf
    font-awesome_5
    noto-fonts
    noto-fonts-emoji
    source-sans-pro
  ];
}
