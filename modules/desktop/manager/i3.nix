{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager = {
        i3 = { enable = true; };
      };

      displayManager = {
        lightdm = {
          autoLogin = {
            enable = true;
            user = "hendrik";
          };
        };
      };
      desktopManager = {
        default = "xfce";
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
    i3 i3lock i3status dmenu
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
