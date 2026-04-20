{ config, pkgs, ... }:

{
  services = {
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
      };
      mouse = {
        naturalScrolling = true;
      };
    };
    xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
        };
      };

      desktopManager = {
        xterm = {
          enable = false;
        };
      };
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "hendrik";
      };
    };

    gnome = {
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
    thunar
    playerctl
    blueman
    feh
    termite
    escrotum
    lxappearance
    networkmanagerapplet
    brightnessctl

    numix-icon-theme
    numix-solarized-gtk-theme
  ];
}
