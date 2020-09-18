{ config, lib, pkgs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> {};
  gnome-shell-extension-pop-shell = stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-pop-shell";
    version = "2020-10-18";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = "shell";
      rev = "e5a80ea39a4f0217989cb681eecd182ddc9a7c5d";
      sha256 = "13cq5g3bzl1myj5f1ccv6986acrf9n2l455zhz3n10q3d678346p";
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
