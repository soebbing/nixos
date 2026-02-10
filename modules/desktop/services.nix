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

    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
      solo2-cli
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraOptions = "--registry-mirror=https://mirror.gcr.io";
  };

  system.autoUpgrade.enable = true;
}
