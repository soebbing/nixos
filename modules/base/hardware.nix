{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_5_3;
    cleanTmpDir = true;
  };

  networking.networkmanager.enable = true;
}
