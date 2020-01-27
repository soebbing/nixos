{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/13-7390>
    ../hardware-scans/syn.nix
    ../modules/base
    ../modules/desktop
    ../modules/desktop/notebook.nix
    ../modules/work
#    ../modules/desktop/manager/xfce.nix
    ../modules/desktop/manager/gnome.nix
#    ../modules/desktop/manager/i3.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.gfxmodeEfi = "1600x1200";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/4e55509a-3a96-4792-826d-af55a36c1a60";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "syn";
  networking.hostId = "16bee688";
  networking.hosts = {
    "127.0.0.1" = [
      "traefik.handcoding.example"
      "portainer.handcoding.example"
      "www.unixtimestamp.example"
      "www.convert-unix-timestamp.example"
      "www.download-handbuch.example"
      "www.manuals-online.example"
      "www.canastapp.example"
      "www.djplaymysong.example"
      "www.auctionmap.example"
    ];
  };
  i18n = {
    defaultLocale = "de_DE.UTF-8";
  };
  console.font = "Lat2-Terminus16";
  console.keyMap = "de";
  services.xserver.layout = "de";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  boot.kernelParams = [ "acpi_rev_override" ];
}
