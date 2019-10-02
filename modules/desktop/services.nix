{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager = {
        default = "i3";
        i3 = { enable = true; };
      };

      displayManager = {
        lightdm = {
          autoLogin = {
            enable = true;
            user = "shyim";
          };
        };
      };
      desktopManager = {
        default = "none";
        xterm = { enable = false; };
      };
    };

    keybase = { enable = true; };

    kbfs = { enable = true; };

    gnome3 = { gnome-keyring = { enable = true; }; };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
