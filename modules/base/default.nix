{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ./packages.nix ./shell.nix ./cache.nix ];

  nixpkgs.overlays = import ../../pkgs/overlays;

  nixpkgs.config.packageOverrides = pkgs: {
    shyim = import (builtins.fetchTarball
      "https://github.com/shyim/nix-packages/archive/master.tar.gz") {
        inherit pkgs;
      };
    # shyim = import /home/shyim/Code/nix-packages/default.nix { inherit pkgs; };
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };

  # Time zone.
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "vm.max_map_count" = 262144;
  };

  # The NixOS release version.
  system.stateVersion = "19.03";
}
