{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
        };
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          autoLogin = {
            enable = true;
            user = "hendrik";
          };
        };
      };
      desktopManager = {
        xterm = {
          enable = false;
        };
      };
    };

    gnome3 = {
      gnome-keyring = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    (polybar.override {
      i3Support = true;
      pulseSupport = true;
    })
    rofi
    arandr
    i3
    i3lock
    i3status
    clipmenu
    dmenu
    pavucontrol
    xfce.thunar
    playerctl
    blueman
    feh
    termite
    escrotum
    lxappearance

    numix-icon-theme
    numix-solarized-gtk-theme
  ];
}
