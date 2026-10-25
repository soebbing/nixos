{ config
, lib
, pkgs
, ...
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
    helium # Helium Browser

    # Chat
    karere # Whatsapp Client
    signal-desktop # Signal App
    discord

    # Office style
    cherrytree # Hierarchical note taking application
    cura-appimage # 3D printing slicer
    enpass
    gimp
    #handbrake
    inkscape # Vector graphics editor
    libreoffice
    hyphenDicts.en-us
    hyphenDicts.de-de
    mqttx # Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools
    remind # Sophisticated calendar and alarm program for the console
    shared-mime-info # Database of common MIME types
    tailscale
    trayscale # GUI for tailscale
    thunderbird # Email client
    transmission_4-gtk # Fast, easy and free BitTorrent client
    typespeed # Curses based typing game
    yubioath-flutter

    # Media
    calibre # Comprehensive e-book software
    hypnotix # IP TV player
    mpv # General-purpose media player, fork of MPlayer and mplayer2
    smplayer # Complete front-end for MPlayer
    spotify # Play music from the Spotify music service
    vlc # Cross-platform media player and streaming server

    hicolor-icon-theme
    keymapp
    uhk-agent

    kbfs
    keybase
    # keybase-gui # insecure as of 2026-09-07
    libdvdcss
    libnotify
    lm_sensors # Tools for reading hardware sensors
    mtr-gui # Network diagnostics tool
    networkmanager-openvpn
    noson # Noson is a SONOS controller for Linux platforms
    ns-usbloader # All-in-one tool for managing Nintendo Switch homebrew
    openssl # Cryptographic library that implements the SSL and TLS protocols

    #qemu # Generic and open source machine emulator and virtualizer
    qFlipper # Cross-platform desktop tool to manage your flipper device
    shellcheck # Shell script analysis tool
    sipcalc # Advanced console ip subnet calculator
    soco-cli # SONOS controller for Linux platforms
    warp-terminal # A Rust based terminal

    xautolock
    xclip
    xfontsel
    libXScrnSaver
    xhost
    xkill
    xsel
  ];
}
