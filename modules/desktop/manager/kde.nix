{
  config,
  pkgs,
  lib,
  ...
}:

let
  unstable = import <nixos-unstable> { };

in
{
  nixpkgs.config.allowUnfree = true;

  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm = {
          enable = false;
        };
      };
    };
  };

  # Use Plasma 5
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [

    # This is needed for graphical dialogs used to enter GPG passphrases
    pinentry-qt
    unstable.digikam
    unstable.krita
    unstable.kphotoalbum
    unstable.amarok

    # KDE apps
    unstable.kdePackages.kdeplasma-addons
    unstable.kdePackages.spectacle
    unstable.kdePackages.calendarsupport
    unstable.kdePackages.kalarm
    unstable.kdePackages.kdenlive
    unstable.kdePackages.bluedevil
    unstable.kdePackages.dolphin-plugins
    unstable.kdePackages.kwallet
    unstable.kdePackages.kwalletmanager
    unstable.kdePackages.ktorrent
    unstable.kdePackages.okular
    unstable.kdePackages.kmail
    unstable.kdePackages.konsole
    unstable.kdePackages.dolphin
    unstable.kdePackages.ark
    unstable.kdePackages.ksshaskpass
    unstable.kdePackages.elisa
    unstable.kdePackages.falkon
    unstable.kdePackages.kmail
    unstable.kdePackages.marble
    unstable.kdePackages.kontact
    unstable.kdePackages.dragon
    unstable.kdePackages.juk
    unstable.kdePackages.merkuro

    #unstable.kdePackages.liquidshell
    unstable.kdePackages.bomber
    unstable.kdePackages.killbots
    unstable.kdePackages.konquest
    unstable.kdePackages.kubrick
    unstable.kdePackages.filelight
    unstable.kdePackages.yakuake
  ];
}
