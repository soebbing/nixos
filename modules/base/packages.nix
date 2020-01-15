{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    sudo
    wget
    curl
    neovim
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
    tree
    silver-searcher
  ];
}
