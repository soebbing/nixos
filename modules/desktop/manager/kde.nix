{
  config,
  pkgs,
  lib,
  ...
}:

let

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
    digikam
    krita
    kphotoalbum
    amarok

    # KDE apps
    kdePackages.kdeplasma-addons
    kdePackages.spectacle
    kdePackages.calendarsupport
    kdePackages.kalarm
    kdePackages.kdenlive
    kdePackages.bluedevil
    kdePackages.dolphin-plugins
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.ktorrent
    kdePackages.okular
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.ksshaskpass
    kdePackages.elisa
    kdePackages.falkon
    kdePackages.marble
    kdePackages.kontact
    kdePackages.kpeople
    kdePackages.kcontacts
    kdePackages.akonadi
    kdePackages.akonadi-contacts
    kdePackages.dragon
    kdePackages.juk
    kdePackages.merkuro

    #kdePackages.liquidshell
    kdePackages.bomber
    kdePackages.killbots
    kdePackages.konquest
    kdePackages.kubrick
    kdePackages.filelight
    kdePackages.yakuake
  ];
}
