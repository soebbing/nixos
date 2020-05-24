{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "xfce";
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableXfwm = true;
      };
    };
    #windowManager.i3.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rofi
    arandr
    playerctl
    blueman
    feh
    networkmanagerapplet
    kitty
    escrotum

    numix-icon-theme
    numix-solarized-gtk-theme

    xfce.exo
    xfce.gvfs
    xfce.parole
    xfce.ristretto
    xfce.tumbler
    xfce.thunar
    xfce.thunar_volman
    xfce.xfce4icontheme
    xfce.xfce4settings
    xfce.xfconf
    xfce.xfce4-session
    xfce.xfce4-settings
    xfce.xfce4-taskmanager
    xfce.xfce4-screenshooter
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-cpugraph-plugin
    xfce.xfce4-power-manager
    xfce.xfce4-netload-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-namebar-plugin
    xfce.xfce4-sensors-plugin
    xfce.xfce4-volumed-pulse
    xfce.xfce4-weather-plugin
    xfce.xfce4-xkb-plugin
    xfce.xfwm4
    xfce.xfwm4-themes
  ];
}
