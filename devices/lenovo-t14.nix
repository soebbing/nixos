{ config, pkgs, ... }:

{
  imports = [
    ../hardware-scans/lenovo-t14.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
    ../modules/desktop/manager/gnome.nix
  ];

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-3963685d-ea3d-45a0-b41a-cb6d5c472324".device =
    "/dev/disk/by-uuid/3963685d-ea3d-45a0-b41a-cb6d5c472324";

  networking.hostName = "lenovo";
  networking.hosts = {
    "127.0.0.1" = [
      "canastapp.example"
      "www.canastapp.example"
      "api.canastapp.example"
      "db.canastapp.example"
      "mail.canastapp.example"
      "traefik.canastapp.example"

      "www.unixtimestamp.example"
      "www.convert-unix-timestamp.example"
      "www.download-handbuch.example"
      "www.manuals-online.example"
      "www.djplaymysong.example"
      "www.auctionmap.example"
      "www.farbuhr.example"
      "www.utf8-encode.example"
      "www.utf8-decode.example"
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            leftalt = "leftmeta";
            leftmeta = "leftalt";
          };
        };
      };
    };
  };
}
