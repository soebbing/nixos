{ config, lib, pkgs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> {};
  gnome-shell-extension-pop-shell = stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-pop-shell";
    version = "2020-03-18";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = "shell";
      rev = "841632872d77abc3c45cd13540ffae755839655a";
      sha256 = "053csqmbj37f7kilsav9z1q7b0v0rrqvbqzk28qkpddkpvysvh7m";
    };

    nativeBuildInputs = [ glib ];
    buildInputs = [ nodePackages.typescript ];

    # the gschema doesn't seem to be installed properly (see dconf)
    makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
  };

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.gnome3.gnome-desktop
    unstable.gnome3.gnome-tweaks
    unstable.gnome3.dconf-editor
    unstable.gnome3.gnome-shell-extensions
    unstable.gnomeExtensions.clipboard-indicator
    unstable.gnomeExtensions.sound-output-device-chooser
    unstable.rhythmbox
    unstable.baobab
    unstable.numix-icon-theme
    unstable.numix-solarized-gtk-theme
    gnome-shell-extension-pop-shell
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
      autoSuspend = true;
    };
    desktopManager = { gnome3 = { enable = true; }; };
  };

  services.gvfs.enable = true;

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}
