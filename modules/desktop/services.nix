{ config, pkgs, ... }:

{
  services = {
    keybase = { enable = true; };

    kbfs = {
      enable = true;
      mountPoint = "/home/hendrik/keybase";  
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  system.autoUpgrade.enable = true;
}
