{ config
, lib
, pkgs
, ...
}:

let
  # Custom Quick Settings tile that toggles TLP between the AC and battery
  # profiles. Built from ./tlp-power/ and installed under the standard
  # /usr/share/gnome-shell/extensions/<uuid>/ path.
  tlpPowerExtension = pkgs.stdenvNoCC.mkDerivation {
    pname = "gnome-shell-extension-tlp-power";
    version = "1";
    src = ./tlp-power;
    dontBuild = true;
    installPhase = ''
      uuid="tlp-power@local"
      mkdir -p "$out/share/gnome-shell/extensions/$uuid"
      cp -r $src/* "$out/share/gnome-shell/extensions/$uuid/"
    '';
  };

  # Fixed-path wrapper around pkgs.tlp so polkit can whitelist a stable
  # absolute path (the nix store path changes on every rebuild).
  tlpSet = pkgs.writeShellScript "tlp-set" ''
    exec ${pkgs.tlp}/bin/tlp "$@"
  '';
in

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
    gnomeExtensions.whatcable
    #gnomeExtensions.forge

    tlpPowerExtension
  ];

  # Drop the tlp-set wrapper at /etc/tlp-set so polkit can match on a stable
  # absolute path. The extension invokes `pkexec /etc/tlp-set ac|bat`.
  environment.etc."tlp-set".source = tlpSet;

  # Authorise the active local user to run /etc/tlp-set without a password
  # prompt. Adjust `subject.user` if the desktop account is renamed.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") == "/etc/tlp-set" &&
          subject.local && subject.active &&
          subject.user == "hendrik") {
        return polkit.Result.YES;
      }
    });
  '';

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
