{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xfce.exo
    xfce.gtk-xfce-engine
    xfce.gvfs
    xfce.terminal
    xfce.thunar
    xfce.thunar_volman
    xfce.xfce4icontheme
    xfce.xfce4settings
    xfce.xfconf
  ];
}