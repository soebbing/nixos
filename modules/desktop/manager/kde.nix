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

    # Password manager for KDE
    unstable.kdeApplications.kwalletmanager
    unstable.kwalletcli

    # Allow automatic unlocking of kwallet if the same password. This seems to
    # work without installing kwallet-pam.
    #kwallet-pam

    # ssh-add prompts a user for a passphrase using KDE. Not sure if it is used
    # by anything? ssh-add just asks passphrase on the console.
    unstable.ksshaskpass

    # Archives (e.g., tar.gz and zip)
    unstable.ark

    # GPG manager for KDE
    unstable.kgpg

    # This is needed for graphical dialogs used to enter GPG passphrases
    pinentry-qt

    kdeplasma-addons

    # Screenshots
    unstable.kdeApplications.spectacle

    # Bluetooth
    bluedevil

    # Text editor
    unstable.kate

    # Torrenting
    unstable.ktorrent

    # Printing and scanning
    unstable.kdeApplications.print-manager
    
    # Document readers
    unstable.okular

    # Email
    unstable.kmail
 
    # Photo/image editor
    unstable.digikam5
 
    # Media player
    unstable.vlc

    # KDE apps
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
    unstable.konsole
    unstable.dolphin
	unstable.kdeFrameworks.kactivities
    unstable.kdeApplications.calendarsupport
    unstable.kdeApplications.kalarm
    unstable.kdeApplications.kalarmcal
    unstable.kdeApplications.dolphin-plugins

  ];
}