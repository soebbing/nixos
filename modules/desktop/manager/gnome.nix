{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome3.gnome-desktop
    guake
    numix-icon-theme
    numix-solarized-gtk-theme
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.displayManager.gdm.autoSuspend = true;
  services.xserver.desktopManager.gnome3.enable = true;
  fonts.fonts = with pkgs; [  ];

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}
