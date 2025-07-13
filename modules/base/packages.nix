{ config, lib, pkgs, ... }:

let
  unstable = import <nixos> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.sudo
    unstable.wget
    unstable.bash
    unstable.bat
    unstable.bind
    unstable.bottom
    unstable.broot
    unstable.cmake
    unstable.curl
    unstable.doggo
    unstable.emoji-picker # CLI Emoji picker
    unstable.fd
    unstable.ffmpeg
    unstable.gnupg
    unstable.gping  
    unstable.jq  
    unstable.jql
    unstable.yq
    unstable.ncdu
    unstable.rm-improved
    unstable.screenfetch
    unstable.starship
    unstable.tmux
    unstable.superfile
    unstable.vim
    unstable.xh
    unstable.zellij
    unstable.rake
    unstable.psmisc
    unstable.shellcheck
    unstable.openssl
    unstable.unzip
    unstable.tldr
    unstable.tre
    unstable.lsd
    unstable.lsof
    unstable.networkmanager
    unstable.fish
    unstable.coreutils
    unstable.file
    unstable.stow
    unstable.linuxPackages.cpupower
    unstable.ctags
    unstable.pwgen
    unstable.openssh
    unstable.xsel
    unstable.nixfmt-rfc-style
    unstable.ntfs3g
    unstable.thefuck
  ];
}
