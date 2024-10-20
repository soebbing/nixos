{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  services = {
    flatpak = { enable = true; };
    keybase = { enable = true; };

    kbfs = {
      enable = true;
      mountPoint = "/home/hendrik/keybase";
    };

    samba = {
      enable = false;
      extraConfig = ''
      client min protocol = NT1
    '';
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraOptions = "--registry-mirror=https://mirror.gcr.io";
  };

#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableExtensionPack = true;
#    package = unstable.virtualboxWithExtpack;
#  };

  system.autoUpgrade.enable = true;
}
