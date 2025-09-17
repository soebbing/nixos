{
  config,
  lib,
  pkgs,
  ...
}:

let
  unstable = import <nixos-unstable> { };

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    unstable.autojump # `cd' command that learns
    unstable.broot # Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands
    unstable.calibre # Comprehensive e-book software
    unstable.canto-curses # Ncurses-based console Atom/RSS feed reader
    unstable.cherrytree # Hierarchical note taking application
    unstable.chrome-gnome-shell
    unstable.ctodo
    #unstable.cura # 3D prining slicer
    unstable.enpass
    unstable.firefox # Web browser built from Firefox source tree
    unstable.gimp
    unstable.github-cli
    unstable.google-chrome
    unstable.handbrake
    unstable.hexcurse # ncurses-based console hexeditor written in C
    unstable.hicolor-icon-theme
    unstable.inkscape # Vector graphics editor
    unstable.kbfs
    unstable.keybase
    unstable.keybase-gui
    unstable.libdvdcss
    unstable.libnotify
    unstable.libreoffice
    unstable.lm_sensors # Tools for reading hardware sensors
    unstable.mediainfo # Supplies technical and tag information about a video or audio file
    unstable.mpv # General-purpose media player, fork of MPlayer and mplayer2
    unstable.mqttx # Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools
    unstable.mtr-gui # Network diagnostics tool
    unstable.ncspot # Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes
    unstable.networkmanagerapplet
    unstable.openssl # Cryptographic library that implements the SSL and TLS protocols
    unstable.powerline-fonts
    unstable.qemu # Generic and open source machine emulator and virtualizer
    unstable.rclone # Command line program to sync files and directories to and from major cloud storage
    unstable.remind # Sophisticated calendar and alarm program for the console
    unstable.shared-mime-info # Database of common MIME types
    unstable.shellcheck # Shell script analysis tool
    unstable.signal-desktop # Signal App
    unstable.sipcalc #Advanced console ip subnet calculator
    unstable.smplayer # Complete front-end for MPlayer
    unstable.spotify # Play music from the Spotify music service
    unstable.transmission_4-gtk # Fast, easy and free BitTorrent client
    unstable.tree # Command to produce a depth indented directory listing
    unstable.typespeed # Curses based typing game
    unstable.vlc # Cross-platform media player and streaming server
    unstable.wasistlos  # Whatsapp Client

    unstable.xautolock
    unstable.xclip
    unstable.xfontsel
    unstable.xorg.libXScrnSaver
    unstable.xorg.xhost
    unstable.xorg.xkill
    unstable.xsel
    unstable.yubioath-flutter
  ];
}
