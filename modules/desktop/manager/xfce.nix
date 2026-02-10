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
    rofi
    arandr
    playerctl
    blueman
    feh
    escrotum

    numix-icon-theme
    numix-solarized-gtk-theme

    xfce.exo
    xfce.parole
    xfce.ristretto
    xfce.tumbler
    xfce.thunar
    xfce.xfconf
    xfce.xfce4-icon-theme
    xfce.xfce4-session
    xfce.xfce4-settings
    xfce.xfce4-taskmanager
    xfce.xfce4-screenshooter
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-cpugraph-plugin
    xfce.xfce4-power-manager
    xfce.xfce4-netload-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-sensors-plugin
    xfce.xfce4-volumed-pulse
    xfce.xfce4-weather-plugin
    xfce.xfce4-xkb-plugin
    xfce.xfwm4
    xfce.xfwm4-themes
  ];
}
