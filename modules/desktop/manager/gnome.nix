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
    gnomeExtensions.pop-shell
    gnomeExtensions.whatcable
    #gnomeExtensions.forge
  ];

  # Pop Shell: Hyprland-style auto-tiling on top of GNOME. Schema settings
  # only — the user toggles `enabled-extensions` via Extension Manager,
  # which writes to the user db and wins over this system db. After rebuild:
  #   gnome-extensions enable pop-shell@system76.com
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell/extensions/pop-shell" = {
          "tile-by-default" = true;
          # Gaps must match home-manager/hyprland.nix for parity.
          # lib.gvariant.mkUint32: schema type is `u`, not inferrable from a literal.
          "gap-inner" = lib.gvariant.mkUint32 5;
          "gap-outer" = lib.gvariant.mkUint32 10;
          "smart-gaps" = true;
        };
      };
    }
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
