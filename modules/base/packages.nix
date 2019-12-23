{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    sudo
    wget
    neovim
    git
    psmisc # killall
    htop
    openssl
    unzip
    bat
    lsd
    tmux
  ];
}
