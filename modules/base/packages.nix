{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    sudo
    wget
    curl
    bash
    vim
    rake
    cmake
    git
    psmisc
    bind
    shellcheck
    openssl
    unzip
    bat
    tldr
    lsd
    lsof
    networkmanager
    bash
    fish
    coreutils
    file
    stow
    linuxPackages.cpupower
    ctags
    gnupg
    pwgen
    openssh
    xsel
    nixfmt
  ];
}
