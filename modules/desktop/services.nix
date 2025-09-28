{ config, pkgs, ... }:

let

in
{
  services = {
    flatpak = {
      enable = true;
    };
    keybase = {
      enable = true;
    };

    kbfs = {
      enable = true;
      mountPoint = "/home/hendrik/keybase";
    };

    samba = {
      enable = false;
    };

    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = false;
      support32Bit = true;
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
  #    package = virtualboxWithExtpack;
  #  };

  system.autoUpgrade.enable = true;
}
