{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #prismatik

    unstable.autojump
    unstable.broot
    unstable.calcurse
    #unstable.calibre
    unstable.canto-curses
    unstable.cherrytree
    unstable.chrome-gnome-shell
    unstable.clutter-gtk
    unstable.ctodo
    #unstable.cura
    unstable.dunst
    unstable.enpass
    unstable.findbugs
    unstable.firefox
    unstable.ffsend
    unstable.fzf
    unstable.gimp
    unstable.github-cli
    unstable.gnumake
    unstable.gnupg
    unstable.google-chrome
    unstable.handbrake
    unstable.hexcurse
    unstable.hicolor-icon-theme
    unstable.htop
    unstable.inkscape
    unstable.jq
    unstable.kbfs
    unstable.keybase
    unstable.keybase-gui
    unstable.khal
    unstable.ghostty
    unstable.libdvdcss
    unstable.libnotify
    unstable.libreoffice
    unstable.libxkbcommon
    unstable.lm_sensors
    unstable.mairix
    unstable.mediainfo
    unstable.mpv
    unstable.mqttx
    unstable.mtr
    unstable.ncspot
    unstable.networkmanagerapplet
    unstable.powerline-fonts
    unstable.qemu
    unstable.rclone
    unstable.remind
    unstable.rlwrap
    unstable.ripgrep
    unstable.shared-mime-info
    unstable.shellcheck
    unstable.signal-desktop
    unstable.sipcalc
    unstable.silver-searcher
    unstable.smplayer
    unstable.spotify
    unstable.transmission_4-gtk
    unstable.tree
    unstable.typespeed
    unstable.unclutter-xfixes
    unstable.vlc
    unstable.wakatime

    unstable.xautolock
    unstable.xclip
    unstable.xfontsel
    unstable.xorg.libXScrnSaver
    unstable.xorg.xhost
    unstable.xorg.xkill
    unstable.xsel
    unstable.yubioath-flutter

    (unstable.vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        vue.volar
        devsense.phptools-vscode
        devsense.profiler-php-vscode
        devsense.composer-php-vscode
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ];
      }
    )
  ];
}
