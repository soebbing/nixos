{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    sudo
    wget
    curl
    vim
    rake
    git
    psmisc # killall
    htop
    openssl
    unzip
    bat
    lsd
    lsof
    tmux
    fzf autojump networkmanager fish starship
    coreutils
    file
    stow
    tree
    silver-searcher
    linuxPackages.cpupower
    ctags
    gnupg
    pwgen
    silver-searcher
    openssh
    xsel
  ];
}
