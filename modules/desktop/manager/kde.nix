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

  # Use Plasma 6
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    # Security & Tools
    pinentry-qt
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.ksshaskpass
    kdePackages.filelight
    kdePackages.yakuake

    # Graphics & Photography
    digikam
    krita
    kphotoalbum
    kdePackages.gwenview
    kdePackages.spectacle

    # Multimedia
    kdePackages.elisa
    kdePackages.kdenlive
    haruna

    # Communication & PIM
    kdePackages.merkuro
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.kontact
    kdePackages.kpeople
    kdePackages.kcontacts
    kdePackages.akonadi
    kdePackages.akonadi-contacts
    kdePackages.akregator

    # Internet & Network
    kdePackages.ktorrent
    kdePackages.kdeconnect-kde
    kdePackages.bluedevil

    # Utilities
    kdePackages.okular
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.kcalc
    kdePackages.kalarm
    kdePackages.calendarsupport
    kdePackages.marble

    # System & Addons
    kdePackages.kdeplasma-addons

    # macOS-like look and feel
    whitesur-kde
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    mojave-gtk-theme
    qogir-kde
    apple-cursor
    nordzy-icon-theme
    plasma-panel-colorizer

    # Solarized support
    numix-solarized-gtk-theme
    dircolors-solarized
    kdePackages.qtstyleplugin-kvantum
  ];
}
