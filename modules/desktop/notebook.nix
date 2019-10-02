{ config, pkgs, ... }:

{
  hardware = { bumblebee = { enable = true; }; };
  services = {
    xserver = {
      libinput = {
        enable = true;
        naturalScrolling = false;
      };
    };
  };
}
