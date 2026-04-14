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

  # Use mandoc instead of man-db to avoid sphinx/python3.11 compatibility issue
  documentation.man = {
    man-db.enable = false;
    mandoc.enable = true;
  };

  fileSystems =
    let
      btrfsOptions = [
        "noatime"
        "nodiratime"
        "compress=zstd"
        "discard=async"
      ];
    in
    {
      "/".options = btrfsOptions;
      "/var/log".options = btrfsOptions;
      "/nix".options = btrfsOptions;
      "/home".options = btrfsOptions;
      "/swap".options = [ "noatime" ];
    };
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/bd92597d-f38f-4b4a-88ed-f26f5eb8466b";

  swapDevices = [ { device = "/swap/swapfile"; } ];
  zramSwap.enable = true;

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

  # Disabled due to incompatibility with Linux kernel 6.19.8
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "hendrik" ];

  # Virtualization with GNOME Boxes
  virtualisation.libvirtd.enable = true;
  users.users.hendrik.extraGroups = [ "libvirtd" ];

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

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
          ids = [ "0001:0001" ];
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
