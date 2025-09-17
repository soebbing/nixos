{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          autoLogin = {
            enable = true;
            user = "hendrik";
          };
          greeters.pantheon.enable = true;
        };
      };
      desktopManager = {
        pantheon.enable = true;
      };
    };

    gnome3 = {
      gnome-keyring = {
        enable = true;
      };
    };

    pantheon.contractor.enable = true;
  };

  environment.systemPackages = with pkgs; [ gtk-engine-murrine ];

  environment.pantheon.excludePackages = [
    pkgs.pantheon.elementary-camera
    pkgs.pantheon.elementary-calculator
    pkgs.pantheon.elementary-code
    pkgs.pantheon.elementary-videos
  ];
}
