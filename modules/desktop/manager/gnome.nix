{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gnome-desktop
    gnome-tweaks
    dconf-editor
    gnome-shell-extensions
    rhythmbox
    baobab
    neovim-gtk

    whitesur-icon-theme
    adwaita-icon-theme
    numix-icon-theme
    numix-solarized-gtk-theme
    numix-cursor-theme
    breeze-hacked-cursor-theme
    openzone-cursors

    flat-remix-gnome

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
