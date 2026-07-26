{ config
, pkgs
, lib
, ...
}:

{
  programs = {
    # Broken on mac (2025-10-06)
    kitty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;
      themeFile = "Solarized_Light";
    };

    # Broken on mac (2025-09-10)
    ghostty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      enableFishIntegration = true;
      # Configuration: https://ghostty.zerebos.com
      settings = {
        theme = "dark:iTerm2 Solarized Dark,light:iTerm2 Solarized Light";
        # Use a Nerd Font for icons, with a fallback for any missing characters
        font-family = "MesloLGS Nerd Font, Droid Sans Mono";

        font-size = 13;
      };
    };
  };
}
