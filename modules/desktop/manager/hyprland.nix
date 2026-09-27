{ config, pkgs, lib, ... }:

lib.mkIf (config.hendrik.desktop == "hyprland") {
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs;
    [
      # Status bar
      waybar

      # Launcher
      rofi

      # Wallpaper
      hyprpaper

      # Lock / idle
      hyprlock
      hypridle

      # Notifications
      mako

      # Authentication agent (polkit prompts without a terminal)
      hyprpolkitagent

      # wl-clipboard is needed by the cliphist keybind and most Wayland apps.
      wl-clipboard
    ];

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # xdg-desktop-portal 1.17+ no longer auto-picks a backend — see home-manager/default.nix.
  xdg.portal.config.common.default = "*";
}
