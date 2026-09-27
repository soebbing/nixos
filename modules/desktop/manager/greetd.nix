# greetd + tuigreet for the Wayland tiling WMs. Activates only when
# `hendrik.desktop` is one of the listed choices; existing managers
# (gnome/kde/i3/xfce/pantheon) keep their own display manager unchanged.
# Tuigreet reads `/usr/share/wayland-sessions/*.desktop` and shows them
# as a menu; `default_session.command = tuigreet` makes the next boot
# start at the greeter rather than skipping straight to a WM.
{ config, lib, pkgs, ... }:

let
  greetdDesktops = [
    "hyprland"
    "sway"
    "niri"
    "river"
  ];
  useGreetd = lib.any (d: d == config.hendrik.desktop) greetdDesktops;
in
lib.mkIf useGreetd {
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings = {
      # Pre-login: tuigreet over /usr/share/wayland-sessions/*.desktop.
      initial_session = {
        user = "greeter";
        command = "${lib.getExe pkgs.tuigreet}";
      };

      # Hard-coded to Hyprland for now. When other WMs in greetdDesktops
      # are wired up, map config.hendrik.desktop -> matching session here.
      # Must be the NixOS wrapper (`start-hyprland`), not the raw binary —
      # the wrapper sets XDG_CURRENT_DESKTOP / XDG_RUNTIME_DIR / etc.
      default_session = {
        user = "hendrik";
        command = "start-hyprland";
      };
    };
  };
}
