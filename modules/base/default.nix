{ config, pkgs, ... }:

{
  imports =
    [ ./hardware.nix ./builder.nix ./packages.nix ./shell.nix ./cache.nix ./i18n-en.nix ];

  nixpkgs.overlays = import ../../pkgs/overlays;

  # Time zone.
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "vm.max_map_count" = 262144;
  };

  environment.etc."php.d/hendrik.ini" = {
    text = ''
      memory_limit=2G
          '';

    mode = "0777";
  };

  # The NixOS release version.
  system.stateVersion = "20.09";
}
