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
  services.xserver.displayManager.defaultSession = "plasma5";
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
    unstable.digikam5
    unstable.kgpg
    unstable.ark
    # ssh-add prompts a user for a passphrase using KDE. Not sure if it is used
    # by anything? ssh-add just asks passphrase on the console.
    unstable.ksshaskpass
    unstable.kwalletcli

    # KDE apps
    unstable.kdeApplications.spectacle
    unstable.kdeApplications.print-manager
    unstable.kdeApplications.calendarsupport
    unstable.kdeApplications.kalarm
    unstable.kdeApplications.kalarmcal
    unstable.kdeApplications.dolphin-plugins
    unstable.kdeApplications.kwalletmanager

    unstable.kdeFrameworks.attica
    unstable.kdeFrameworks.baloo
    unstable.kdeFrameworks.karchive
    unstable.kdeFrameworks.kauth
    unstable.kdeFrameworks.kcompletion
    unstable.kdeFrameworks.kcontacts
    unstable.kdeFrameworks.kded
    unstable.kdeFrameworks.kdesu
    unstable.kdeFrameworks.kemoticons
    unstable.kdeFrameworks.kdnssd
    unstable.kdeFrameworks.kfilemetadata
    unstable.kdeFrameworks.kguiaddons
    unstable.kdeFrameworks.kglobalaccel
    unstable.kdeFrameworks.ki18n
    unstable.kdeFrameworks.kiconthemes
    unstable.kdeFrameworks.kidletime
    unstable.kdeFrameworks.kimageformats
    unstable.kdeFrameworks.kinit
    unstable.kdeFrameworks.kio
    unstable.kdeFrameworks.kmediaplayer
    unstable.kdeFrameworks.knotifications
    unstable.kdeFrameworks.knotifyconfig
    unstable.kdeFrameworks.kparts
    unstable.kdeFrameworks.krunner
    unstable.kdeFrameworks.ktexteditor
    unstable.kdeFrameworks.kwallet
    unstable.kdeFrameworks.networkmanager-qt
    unstable.kdeFrameworks.kxmlgui
    unstable.kdeFrameworks.plasma-framework
    unstable.kdeFrameworks.prison
    unstable.kdeFrameworks.oxygen-icons5
    unstable.kdeFrameworks.kconfig
    unstable.kdeFrameworks.kconfigwidgets
	  unstable.kdeFrameworks.kactivities
  ];
}