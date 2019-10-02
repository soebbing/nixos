{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
  };

  networking.networkmanager.enable = true;
}
