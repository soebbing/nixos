{
  config,
  lib,
  pkgs,
  ...
}:

{
  services = {

    displayManager.defaultSession = "xfce";
    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;
            theme.name = "Zukitre-dark";
          };
        };
      };
      desktopManager.xfce.enable = true;
      #windowManager.i3.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    # Application launchers & menus
    rofi
    rofi-pass

    # Display & monitor management
    arandr
    autorandr
    xrandr

    # Media control & audio
    playerctl
    pamixer
    pavucontrol

    # Bluetooth
    blueman

    # Screenshots & screen recording
    feh
    escrotum
    xfce4-screenshooter
    xfce4-clipman-plugin

    # Themes & appearance
    numix-icon-theme
    numix-solarized-gtk-theme
    gnome-themes-extra
    papirus-icon-theme
    arc-theme
    adwaita-qt
    libsForQt5.qtstyleplugin-kvantum

    # XFCE core components
    exo
    parole
    ristretto
    tumbler
    thunar
    thunar-archive-plugin
    thunar-volman
    xfconf
    xfce4-icon-theme
    xfce4-session
    xfce4-settings
    xfce4-taskmanager
    xfce4-terminal
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
    xfce4-pulseaudio-plugin
    xfce4-cpugraph-plugin
    xfce4-power-manager
    xfce4-netload-plugin
    xfce4-sensors-plugin
    xfce4-volumed-pulse
    xfce4-weather-plugin
    xfce4-xkb-plugin
    xfwm4
    xfwm4-themes

    # System utilities
    gnome-disk-utility
    gparted
    baobab
    #galculator
    catfish
    engrampa
    xfce4-appfinder

    # Network & connectivity
    networkmanagerapplet
    networkmanager-openvpn

    # Power management
    acpi
    tlp
    powertop

    # Input devices
    xf86-input-wacom
    libwacom

    # Notification daemon
    dunst
    libnotify

    # Desktop enhancements
    picom
    nitrogen
    variety
  ];
}
