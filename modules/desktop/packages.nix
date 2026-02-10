{
  config,
  lib,
  pkgs,
  ...
}:

let

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    # Browsers
    firefox # Web browser built from Firefox source tree
    google-chrome
    gnome-browser-connector

    # Chat
    wasistlos # Whatsapp Client
    signal-desktop # Signal App
    discord

    # Office style
    ctodo
    calibre # Comprehensive e-book software
    canto-curses # Ncurses-based console Atom/RSS feed reader
    cherrytree # Hierarchical note taking application
    cura-appimage # 3D printing slicer
    enpass
    gimp
    inkscape # Vector graphics editor
    yubioath-flutter
    handbrake
    libreoffice
    mqttx # Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools
    remind # Sophisticated calendar and alarm program for the console
    shared-mime-info # Database of common MIME types
    transmission_4-gtk # Fast, easy and free BitTorrent client
    typespeed # Curses based typing game

    # Media
    hypnotix # IP TV player
    mediainfo # Supplies technical and tag information about a video or audio file
    mpv # General-purpose media player, fork of MPlayer and mplayer2
    ncspot # Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes
    smplayer # Complete front-end for MPlayer
    spotify # Play music from the Spotify music service
    vlc # Cross-platform media player and streaming server

    hicolor-icon-theme
    keymapp
    uhk-agent

    github-cli
    kbfs
    keybase
    keybase-gui
    libdvdcss
    libnotify
    lm_sensors # Tools for reading hardware sensors
    mtr-gui # Network diagnostics tool
    networkmanagerapplet
    networkmanager-openvpn
    openssl # Cryptographic library that implements the SSL and TLS protocols
    qemu # Generic and open source machine emulator and virtualizer
    rclone # Command line program to sync files and directories to and from major cloud storage
    shellcheck # Shell script analysis tool
    sipcalc # Advanced console ip subnet calculator
    tree # Command to produce a depth indented directory listing

    xautolock
    xclip
    xfontsel
    libXScrnSaver
    xhost
    xkill
    xsel
  ];
}
