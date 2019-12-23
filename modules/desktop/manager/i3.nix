{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager = {
        i3 = { enable = true; };
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          autoLogin = {
            enable = true;
            user = "shyim";
          };
        };
      };
      desktopManager = {
        xterm = { enable = false; };
      };
    };

    gnome3 = { gnome-keyring = { enable = true; }; };
  };

  fonts.fonts = with pkgs; [ font-awesome_5 ];

  environment.systemPackages = with pkgs; [
    (polybar.override { i3Support = true; })
    rofi
    arandr
    pavucontrol
    xfce.thunar
    playerctl
    blueman
    feh
    networkmanagerapplet
    kitty
    escrotum
  ];
}
