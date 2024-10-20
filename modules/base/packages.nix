{ config, lib, pkgs, ... }:

let
  unstable = import <nixos> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.sudo
    unstable.wget
    unstable.curl
    unstable.bash
    unstable.vim
    unstable.rake
    unstable.cmake
    unstable.git
    unstable.psmisc
    unstable.bind
    unstable.shellcheck
    unstable.openssl
    unstable.unzip
    unstable.bat
    unstable.tldr
    unstable.lsd
    unstable.lsof
    unstable.networkmanager
    unstable.bash
    unstable.fish
    unstable.coreutils
    unstable.file
    unstable.stow
    unstable.linuxPackages.cpupower
    unstable.ctags
    unstable.gnupg
    unstable.pwgen
    unstable.openssh
    unstable.xsel
    unstable.nixfmt-rfc-style
    unstable.ntfs3g
    unstable.thefuck
    unstable.ffmpeg
  ];
}
