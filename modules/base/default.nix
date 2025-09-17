{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./home-manager.nix
    ./builder.nix
    ./packages.nix
    ./shell.nix
    ./cache.nix
    ./i18n-de.nix
  ];

  nixpkgs.overlays = import ../../pkgs/overlays;

  # Time zone.
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "vm.max_map_count" = 262144;
  };

  nixpkgs.config.allowUnfree = true;

  environment.etc."php.d/hendrik.ini" = {
    text = ''
      memory_limit=2G
    '';

    mode = "0777";
  };

  # The NixOS release version.
  system.stateVersion = "25.05";
}
