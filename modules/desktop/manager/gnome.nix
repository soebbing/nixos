{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    baobab
    dconf-editor
    geary
    gnome-desktop
    gnome-tweaks
    gnome-shell-extensions
    neovim-gtk
    rhythmbox

    whitesur-icon-theme
    adwaita-icon-theme
    numix-icon-theme
    numix-solarized-gtk-theme
    numix-cursor-theme
    breeze-hacked-cursor-theme
    openzone-cursors

    flat-remix-gnome

    gnome-extension-manager
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.panel-corners
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
  ];

  services = {
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
