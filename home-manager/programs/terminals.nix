{ config
, pkgs
, lib
, ...
}:

let
  fontFamily = "MesloLGS Nerd Font";
  fontSize = 13;
in
{
  programs = {
    # Broken on mac (2025-10-06)
    kitty = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;

      font = {
        name = fontFamily;
        size = fontSize;
      };

      # Kitty follows the OS light/dark preference, like Ghostty's
      # `dark:`/`light:` theme pair. Auto themes override all color settings.
      autoThemeFiles = {
        dark = "Solarized_Dark";
        light = "Solarized_Light";
        # No color preference counts as light.
        noPreference = "Solarized_Light";
      };
    };

    # Broken on mac (2025-09-10)
    ghostty = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      enableFishIntegration = true;
      # Configuration: https://ghostty.zerebos.com
      settings = {
        theme = "dark:iTerm2 Solarized Dark,light:iTerm2 Solarized Light";
        # Use a Nerd Font for icons, with a fallback for any missing characters
        font-family = "${fontFamily}, Droid Sans Mono";

        font-size = fontSize;
      };
    };
  };
}
