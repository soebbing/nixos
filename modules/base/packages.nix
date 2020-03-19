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
    htop
    openssl
    unzip
    bat
    tldr
    lsd
    lsof
    tmux
    fzf
    autojump
    networkmanager
    fish
    starship
    coreutils
    file
    stow
    tree
    silver-searcher
    ripgrep
    linuxPackages.cpupower
    ctags
    gnupg
    pwgen
    openssh
    xsel
    nixfmt
    ncspot
  ];
}
