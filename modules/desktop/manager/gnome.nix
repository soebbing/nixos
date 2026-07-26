{ config
, lib
, pkgs
, ...
}:

lib.mkIf (config.hendrik.desktop == "gnome") {
  environment.systemPackages = with pkgs; [
    baobab
    dconf-editor
    geary
    gnome-desktop
    gnome-tweaks
    gnome-shell-extensions
    neovim-gtk
    newsflash
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
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.just-perfection
    gnomeExtensions.panel-corners
    gnomeExtensions.paperwm
    gnomeExtensions.whatcable
    #gnomeExtensions.forge
  ];

  services = {
    displayManager.gdm = {
      enable = true;
      autoSuspend = true;
    };
    desktopManager.gnome.enable = true;
  };

  services.gvfs.enable = true;

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
}
