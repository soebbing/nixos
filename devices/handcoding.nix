{ config, pkgs, ... }:

{
  imports = [
    ../hardware-scans/handcoding.nix
    ../modules/base
    ../modules/server
  ];

  # Headless server: no desktop module.
  networking.hostName = "handcoding";
  networking.domain = "handcoding.de";

  # TODO: replace with the real boot loader once the hardware-scan is filled in.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "25.05";
}
