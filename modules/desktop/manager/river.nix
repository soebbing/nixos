{ config, pkgs, lib, ... }:

lib.mkIf (config.hendrik.desktop == "river") {
  # No `programs.river` NixOS module on locked nixpkgs; install the pkg
  # directly so greetd finds river.desktop.
  environment.systemPackages = [
    pkgs.river
  ]
  ++ (with pkgs; [
    # Status bar
    waybar

    # Launcher (river's customary pick)
    fuzzel

    # Wallpaper
    swaybg

    # Lock / idle
    swaylock
    swayidle

    # Notifications
    mako

    # Authentication agent
    polkit-kde-agent
  ]);

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
