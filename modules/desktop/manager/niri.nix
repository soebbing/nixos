{ config, pkgs, lib, ... }:

lib.mkIf (config.hendrik.desktop == "niri") {
  programs.niri.enable = true;

  environment.systemPackages = with pkgs;
    [
      # Status bar (niri IPC feeds it)
      waybar

      # Launcher
      anyrun

      # Wallpaper (animated)
      swww

      # Lock / idle
      swaylock
      swayidle

      # Notifications
      mako

      # Authentication agent
      polkit-kde-agent
    ];

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
