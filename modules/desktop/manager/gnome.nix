{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      gnome3.gnome-desktop
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome3.enable = true;
  
  fonts.fonts = with pkgs; [
    dejavu_fonts
    nerdfonts
#    font-awesome-ttf
    font-awesome_5
  ];

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}
