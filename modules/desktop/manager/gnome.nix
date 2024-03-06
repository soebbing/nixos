{ config, lib, pkgs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> {};
#  gnome-shell-extension-pop-shell = stdenv.mkDerivation rec {
#    pname = "gnome-shell-extension-pop-shell";
#    version = "1.2.0";
#    src = fetchFromGitHub {
#      owner = "pop-os";
#      repo = "shell";
#      rev = "891525b74b706683301d7415a62b012472a03ad4";
#      sha256 = "1ba1nrnk4cqgjx5mygqdkw74xlankrkiib9rw0vwkjcgv9bj024a";
#    };

#    nativeBuildInputs = [ glib ];
#    buildInputs = [ nodePackages.typescript ];

    # the gschema doesn't seem to be installed properly (see dconf)
#    makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
#  };

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.gnome-desktop
    unstable.gnome.gnome-tweaks
    unstable.gnome.dconf-editor
    unstable.gnome.gnome-shell-extensions
    unstable.gnomeExtensions.clipboard-indicator
    unstable.gnomeExtensions.sound-output-device-chooser
    unstable.rhythmbox
    unstable.baobab
    unstable.numix-icon-theme
    unstable.numix-solarized-gtk-theme
#    gnome-shell-extension-pop-shell
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
      autoSuspend = true;
    };
    desktopManager = { gnome = { enable = true; }; };
  };

  services.gvfs.enable = true;

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome.chrome-gnome-shell.enable = true;
}
