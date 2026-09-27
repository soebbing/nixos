{ config, pkgs, lib, ... }:

lib.mkIf (config.hendrik.desktop == "sway") {
  programs.sway.enable = true;

  environment.systemPackages = with pkgs;
    [
      # Status bar
      waybar

      # Launcher
      wofi

      # Wallpaper
      swaybg

      # Lock / idle
      swaylock
      swayidle

      # Notifications
      mako

      # Authentication agent
      polkit-kde-agent
    ];

  # wlroots-based screen-share portal (works for Sway too).
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
