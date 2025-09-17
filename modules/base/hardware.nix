{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot = {
    tmp.cleanOnBoot = true;
    kernelParams = [
      "noibrs"
      "noibpb"
      "nopti"
      "nospectre_v2"
      "nospectre_v1"
      "l1tf=off"
      "nospec_store_bypass_disable"
      "no_stf_barrier"
      "mds=off"
      "mitigations=off"
    ];
  };

  networking.networkmanager.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    500
    4500
  ];
  networking.firewall.allowedUDPPorts = [
    500
    4500
  ];
}
