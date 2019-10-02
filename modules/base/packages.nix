{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    sudo
    wget
    neovim
    git
    fzf
    psmisc # killall
    htop
    openssl
    iftop
    unzip
  ];
}
