{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  services = {
    xserver = {
      enable = true;
      desktopManager = { xterm = { enable = false; }; };
    };
  };

  # Use Plasma 5
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs; [

    # This is needed for graphical dialogs used to enter GPG passphrases
    pinentry-qt

    unstable.vlc
    unstable.kdeplasma-addons
    unstable.bluedevil
    unstable.kate
    unstable.ktorrent
    unstable.okular
    unstable.kmail
    unstable.konsole
    unstable.dolphin
    unstable.digikam
    unstable.kgpg
    unstable.ark
    # ssh-add prompts a user for a passphrase using KDE. Not sure if it is used
    # by anything? ssh-add just asks passphrase on the console.
    unstable.ksshaskpass
    unstable.kwalletcli

    # KDE apps
    unstable.kdePackages.spectacle
    # unstable.kdePackages.print-manager
    unstable.kdePackages.calendarsupport
    unstable.kdePackages.kalarm
    unstable.kdePackages.dolphin-plugins
    unstable.kdePackages.kwalletmanager

    unstable.libsForQt5.attica
    unstable.libsForQt5.baloo
    unstable.libsForQt5.karchive
    unstable.libsForQt5.kauth
    unstable.libsForQt5.kcompletion
    unstable.libsForQt5.kcontacts
    unstable.libsForQt5.kded
    unstable.libsForQt5.kdesu
    unstable.libsForQt5.kemoticons
    unstable.libsForQt5.kdnssd
    unstable.libsForQt5.kfilemetadata
    unstable.libsForQt5.kguiaddons
    unstable.libsForQt5.kglobalaccel
    unstable.libsForQt5.ki18n
    unstable.libsForQt5.kiconthemes
    unstable.libsForQt5.kidletime
    unstable.libsForQt5.kimageformats
    unstable.libsForQt5.kinit
    unstable.libsForQt5.kio
    unstable.libsForQt5.kmediaplayer
    unstable.libsForQt5.knotifications
    unstable.libsForQt5.knotifyconfig
    unstable.libsForQt5.kparts
    unstable.libsForQt5.krunner
    unstable.libsForQt5.ktexteditor
    unstable.libsForQt5.kwallet
    unstable.libsForQt5.networkmanager-qt
    unstable.libsForQt5.kxmlgui
    unstable.libsForQt5.plasma-framework
    unstable.libsForQt5.prison
    unstable.libsForQt5.oxygen-icons5
    unstable.libsForQt5.kconfig
    unstable.libsForQt5.kconfigwidgets
	  unstable.libsForQt5.kactivities
  ];
}