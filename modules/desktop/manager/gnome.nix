{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.gnome3.gnome-desktop
    unstable.gnome3.gnome-tweaks
    unstable.gnome3.dconf-editor
    unstable.rhythmbox
    unstable.numix-icon-theme
    unstable.numix-solarized-gtk-theme
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
