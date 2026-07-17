# Placeholder — replace with the output of `nixos-generate-config` run on the
# actual handcoding.de hardware. The values below let the flake evaluate and
# build but will NOT boot correctly on real metal.
{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # TODO: fill from nixos-generate-config
  boot.initrd.availableKernelModules = [ ];
  boot.kernelModules = [ ];

  # TODO: replace with the real root device/UUID and fsType
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  nix.settings.max-jobs = lib.mkDefault 4;
}
