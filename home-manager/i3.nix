{ pkgs, ... }:

let
  solarized = {
    base03 = "#002b36";
    base02 = "#073642";
    base01 = "#586e75";
    base00 = "#657b83";
    base0 = "#839496";
    base1 = "#93a1a1";
    base2 = "#eee8d5";
    base3 = "#fdf6e3";
    yellow = "#b58900";
    orange = "#cb4b16";
    red = "#dc322f";
    magenta = "#d33682";
    violet = "#6c71c4";
    blue = "#268bd2";
    cyan = "#2aa198";
    green = "#859900";
  };
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4"; # Super key
      
      fonts = {
        names = [ "MesloLGS Nerd Font" ];
        size = 11.0;
      };

      colors = {
        background = solarized.base3;
        focused = {
          border = solarized.blue;
          background = solarized.blue;
          text = solarized.base3;
          indicator = solarized.orange;
          childBorder = solarized.blue;
        };
        focusedInactive = {
          border = solarized.base2;
          background = solarized.base2;
          text = solarized.base01;
          indicator = solarized.base2;
          childBorder = solarized.base2;
        };
        unfocused = {
          border = solarized.base2;
          background = solarized.base2;
          text = solarized.base01;
          indicator = solarized.base2;
          childBorder = solarized.base2;
        };
        urgent = {
          border = solarized.red;
          background = solarized.red;
          text = solarized.base3;
          indicator = solarized.orange;
          childBorder = solarized.red;
        };
        placeholder = {
          border = solarized.base2;
          background = solarized.base2;
          text = solarized.base01;
          indicator = solarized.base2;
          childBorder = solarized.base2;
        };
      };

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = [ "MesloLGS Nerd Font" ];
            size = 11.0;
          };
          colors = {
            background = solarized.base2;
            statusline = solarized.base01;
            separator = solarized.base1;
            focusedWorkspace = {
              border = solarized.blue;
              background = solarized.blue;
              text = solarized.base3;
            };
            activeWorkspace = {
              border = solarized.base1;
              background = solarized.base1;
              text = solarized.base3;
            };
            inactiveWorkspace = {
              border = solarized.base2;
              background = solarized.base2;
              text = solarized.base01;
            };
            urgentWorkspace = {
              border = solarized.red;
              background = solarized.red;
              text = solarized.base3;
            };
            bindingMode = {
              border = solarized.orange;
              background = solarized.orange;
              text = solarized.base3;
            };
          };
        }
      ];

      keybindings = let
        modifier = "Mod4";
      in pkgs.lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show run";
        "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+Shift+q" = "kill";
        
        # Audio controls
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        
        # Media controls
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        # Brightness
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # Apps
        "${modifier}+b" = "exec ${pkgs.google-chrome}/bin/google-chrome-stable";
        "${modifier}+f" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+n" = "exec ${pkgs.thunar}/bin/thunar";
        "${modifier}+s" = "exec ${pkgs.spotify}/bin/spotify";
        "${modifier}+m" = "exec ${pkgs.signal-desktop}/bin/signal-desktop";
        "${modifier}+c" = "exec ${pkgs.discord}/bin/discord";
        "${modifier}+t" = "exec ${pkgs.thunderbird}/bin/thunderbird";
      };

      startup = [
        { command = "feh --bg-color '#fdf6e3'"; notification = false; }
        { command = "nm-applet"; notification = false; }
        { command = "blueman-applet"; notification = false; }
      ];
    };
  };

  programs.rofi = {
    enable = true;
    theme = "solarized";
    font = "MesloLGS Nerd Font 12";
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
    };
  };
}
