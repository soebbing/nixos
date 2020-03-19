{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "xfce";
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    nerdfonts
    font-awesome-ttf
    font-awesome_5
  ];

  environment.systemPackages = with pkgs; [
    rofi
    arandr
    playerctl
    blueman
    feh
    networkmanagerapplet
    kitty
    escrotum

    xfce.exo
    xfce.gvfs
    xfce.terminal
    xfce.thunar
    xfce.thunar_volman
    xfce.xfce4icontheme
    xfce.xfce4settings
    xfce.xfconf
    xfce.xfwm4
    xfce.xfwm4-themes
  ];
}
