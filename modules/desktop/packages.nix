{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    shyim.phpstorm
    kbfs
    keybase
    keybase-gui
    google-chrome
    firefox
    thunderbird
    vscode-ext
    php74
    php74Packages.composer
    nodejs-13_x
    gnupg
    insomnia
    xclip
    travis
    spotify
    shyim.swdc
    rclone
    nixops
    gnumake
    terraform
    ffsend
    shellcheck
    fzf
    tldr
  ];

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-sans-pro ];
}
