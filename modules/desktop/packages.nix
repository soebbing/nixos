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
    calibre # Comprehensive e-book software
    canto-curses # Ncurses-based console Atom/RSS feed reader
    cherrytree # Hierarchical note taking application
    gnome-browser-connector
    ctodo
    cura-appimage # 3D printing slicer
    enpass
    firefox # Web browser built from Firefox source tree
    gimp
    github-cli
    google-chrome
    handbrake
    hexcurse # ncurses-based console hexeditor written in C
    hicolor-icon-theme
    inkscape # Vector graphics editor
    kbfs
    keybase
    keybase-gui
    libdvdcss
    libnotify
    libreoffice
    lm_sensors # Tools for reading hardware sensors
    mediainfo # Supplies technical and tag information about a video or audio file
    mpv # General-purpose media player, fork of MPlayer and mplayer2
    mqttx # Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools
    mtr-gui # Network diagnostics tool
    ncspot # Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes
    networkmanagerapplet
    openssl # Cryptographic library that implements the SSL and TLS protocols
    powerline-fonts
    qemu # Generic and open source machine emulator and virtualizer
    rclone # Command line program to sync files and directories to and from major cloud storage
    remind # Sophisticated calendar and alarm program for the console
    shared-mime-info # Database of common MIME types
    shellcheck # Shell script analysis tool
    signal-desktop # Signal App
    sipcalc # Advanced console ip subnet calculator
    smplayer # Complete front-end for MPlayer
    spotify # Play music from the Spotify music service
    transmission_4-gtk # Fast, easy and free BitTorrent client
    tree # Command to produce a depth indented directory listing
    typespeed # Curses based typing game
    vlc # Cross-platform media player and streaming server
    wasistlos # Whatsapp Client

    xautolock
    xclip
    xfontsel
    xorg.libXScrnSaver
    xorg.xhost
    xorg.xkill
    xsel
    yubioath-flutter
  ];
}
