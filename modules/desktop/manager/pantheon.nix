{ config, pkgs, ... }:

{
  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "hendrik";
      };
    };

    xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          greeters.pantheon.enable = true;
        };
      };
    };

    desktopManager = {
      pantheon.enable = true;
    };

    # Note: services.gnome.gnome-keyring and services.pantheon.contractor
    # are automatically enabled by services.desktopManager.pantheon.enable
  };

  environment.systemPackages = with pkgs; [
    gtk-engine-murrine
    pantheon-tweaks
  ];

  environment.pantheon.excludePackages = with pkgs.pantheon; [
    elementary-camera
    elementary-calculator
    elementary-code
    elementary-videos
    epiphany
  ];
}
