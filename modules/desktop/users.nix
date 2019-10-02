{ config, pkgs, ... }:

{
  # Allow passwordless sudo for wheel users.
  security.sudo.wheelNeedsPassword = false;

  # User accounts.
  users.users.shyim = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "video" "audio" "networkmanager" "systemd-journal" ];
    shell = "/run/current-system/sw/bin/fish";
  };

  nix.trustedUsers = [ "root" "shyim" ];
}
