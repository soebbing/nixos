{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ./packages.nix ./shell.nix ./cache.nix ./podman.nix ];

  nixpkgs.overlays = import ../../pkgs/overlays;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };

  # Time zone.
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;

  # The NixOS release version.
  system.stateVersion = "19.03";
}
