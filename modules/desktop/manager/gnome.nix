{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      gnome3.gnome-desktop
  ];

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}