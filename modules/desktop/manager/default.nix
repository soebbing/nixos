{ config
, lib
, ...
}:

# Desktop manager is chosen per host via `hendrik.desktop`.
# Each manager module (gnome.nix, hyprland.nix, ...) gates its own settings on
# being the selected value, so importing all of them here is safe.
{
  imports = [
    ./gnome.nix
    ./kde.nix
    ./i3.nix
    ./xfce.nix
    ./pantheon.nix
    ./hyprland.nix
    ./sway.nix
    ./niri.nix
    ./river.nix
    ./greetd.nix
  ];

  options.hendrik.desktop = lib.mkOption {
    type = lib.types.enum [
      "gnome"
      "kde"
      "i3"
      "xfce"
      "pantheon"
      "hyprland"
      "sway"
      "niri"
      "river"
    ];
    default = "gnome";
    description = "Desktop environment / window manager to enable for this host.";
  };
}
