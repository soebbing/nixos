{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../hardware-scans/lenovo-t14.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
    ../modules/desktop/manager/gnome.nix
  ];

  fileSystems = {
    "/".options = [
      "noatime"
      "nodiratime"
      "compress=zstd"
      "discard"
    ];
    "/var/log".options = [
      "noatime"
      "nodiratime"
      "compress=zstd"
      "discard"
    ];
    "/nix".options = [
      "noatime"
      "nodiratime"
      "compress=zstd"
      "discard"
    ];
    "/home".options = [
      "noatime"
      "nodiratime"
      "compress=zstd"
      "discard"
    ];
    "/swap".options = [ "noatime" ];
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/bd92597d-f38f-4b4a-88ed-f26f5eb8466b";

  swapDevices = [ { device = "/swap/swapfile"; } ];

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

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Fingerprint reader
  services = {
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    fwupd.enable = true;

    keyd = {
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
  };

  security.polkit.enable = true;

  security.pam.services = {
    gdm-password.fprintAuth = true;
    gdm-fingerprint.fprintAuth = true;
    sudo.fprintAuth = true;
  };
}
