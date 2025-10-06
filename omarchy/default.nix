{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "de";
      # kb_variant =
      # kb_model =
      kb_options = "compose:caps";
      # kb_rules =

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = true;
      };
    };

    general = {
      gaps_in = lib.mkForce 2;
      gaps_out = lib.mkForce 2;

      border_size = lib.mkForce 1;

      resize_on_border = lib.mkForce true;

      allow_tearing = lib.mkForce true;

      layout = "dwindle";
    };
  };
}
