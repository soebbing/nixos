{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.powerline-fonts

    gnupg
    xclip
    rclone
    nixops
    gnumake
    terraform

    transmission-gtk
    networkmanagerapplet
    xfontsel

    hicolor_icon_theme
    shared_mime_info

    dunst
    libnotify
    xautolock
    xorg.xkill

    unstable.vscode
    unstable.cura

    unstable.kbfs
    unstable.keybase
    unstable.keybase-gui
    unstable.ffsend
    unstable.shellcheck
    unstable.fzf
    unstable.tldr
    unstable.lm_sensors
    unstable.xorg.xhost
    unstable.wakatime
    unstable.tree
    unstable.silver-searcher
    unstable.ripgrep
    unstable.ncspot
    unstable.starship
    unstable.tmux
    unstable.autojump
    unstable.qemu
    unstable.htop
    unstable.xsel

    unstable.calcurse
    unstable.canto-curses
    unstable.cherrytree
    unstable.ctodo
    unstable.findbugs
    unstable.gitinspector
    unstable.hexcurse
    unstable.khal
    unstable.mairix
    unstable.mediainfo
    unstable.remind
    unstable.rlwrap
    unstable.sipcalc
    unstable.typespeed

    unstable.php74
    unstable.php74Packages.composer
    unstable.php74Packages.phpstan
    unstable.nodejs-12_x
    unstable.go_bootstrap
    unstable.gitAndTools.gitFull
    unstable.gitAndTools.git-annex
    unstable.gitAndTools.git-extras
    unstable.gitAndTools.git2cl
    unstable.gitAndTools.tig

    unstable.enpass
    unstable.mullvad-vpn
    unstable.libxkbcommon
    unstable.gtk3
    unstable.qt5.qtwayland
    unstable.blender

    unstable.powerline-fonts
    unstable.smplayer
    unstable.mpv
    unstable.google-chrome
    unstable.chrome-gnome-shell
    unstable.firefox
    unstable.spotify
    unstable.inkscape
    unstable.libreoffice
    unstable.gimp
    unstable.zoom-us
    unstable.calibre
  ];
}
