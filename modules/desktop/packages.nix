{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #prismatik

    unstable.clutter-gtk
    unstable.unclutter-xfixes

    unstable.powerline-fonts
    unstable.gnupg
    unstable.xclip
    unstable.rclone
    unstable.gnumake
    unstable.terraform

    unstable.transmission-gtk
    unstable.networkmanagerapplet
    unstable.xfontsel

    unstable.hicolor_icon_theme
    unstable.shared_mime_info

    unstable.dunst
    unstable.libnotify
    unstable.xautolock
    unstable.xorg.xkill

    unstable.vscode
    unstable.handbrake
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
    unstable.jq

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
    unstable.xorg.libXScrnSaver

    unstable.enpass
    unstable.mullvad-vpn
    unstable.libxkbcommon
    unstable.gtk3
    unstable.qt5.qtwayland
    unstable.blender

    unstable.powerline-fonts
    unstable.smplayer
    unstable.mpv
    unstable.ferdi
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
