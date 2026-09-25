{ config, pkgs, ... }:

let

in
{
  services = {
    flatpak = {
      enable = true;
    };

    # Required for flatpak
    dbus.enable = true;

    upower.enable = true;

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

    # For Yubikey
    pcscd.enable = true;

    tailscale = {
      enable = true;
      # Interactive login: run `sudo tailscale up` once per host after rebuild.
      extraUpFlags = [ "--accept-dns=true" ]; # MagicDNS
    };

    udev = {
      packages = with pkgs; [
        yubikey-personalization
        libu2f-host
        solo2-cli
      ];

      extraRules = ''
        KERNEL=="ttyUSB[0-9]*", MODE="0666"
        KERNEL=="ttyACM[0-9]*", MODE="0666"
      '';
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraOptions = "--registry-mirror=https://mirror.gcr.io";
  };

  system.autoUpgrade.enable = true;
}
