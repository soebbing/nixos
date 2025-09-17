{
  config,
  lib,
  pkgs,
  ...
}:

with pkgs;
let
  unstable = import <nixos-unstable> { };

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.gnome-desktop
    unstable.gnome-tweaks
    unstable.dconf-editor
    unstable.gnome-shell-extensions
    unstable.gnomeExtensions.clipboard-indicator
    unstable.gnomeExtensions.sound-output-device-chooser
    unstable.rhythmbox
    unstable.baobab

    unstable.adwaita-icon-theme
    unstable.numix-icon-theme
    unstable.numix-solarized-gtk-theme
    unstable.numix-cursor-theme
    unstable.breeze-hacked-cursor-theme
    unstable.openzone-cursors

    gnomeExtensions.pop-shell
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
      autoSuspend = true;
    };
    desktopManager.gnome.enable = true;
  };

  services.gvfs.enable = true;

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
}
