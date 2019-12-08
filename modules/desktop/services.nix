{ config, pkgs, ... }:

{
  services = {
    keybase = { enable = true; };

    kbfs = { enable = true; };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
