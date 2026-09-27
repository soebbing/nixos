{ config
, pkgs
, lib
, ...
}:

# Wayland-native clipboard history (shells out to wl-copy / wl-paste).
# home-manager 25.11 has no `programs.cliphist` module yet; install the
# binary directly. Hyprland keybinding in ./hyprland.nix binds it.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = [
    pkgs.cliphist
  ];
}
