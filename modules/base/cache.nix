{ pkgs, lib, ... }:

{
  nix = {
    binaryCaches = [ "https://cache.nixos.org" "https://snix.ovh" ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "snix.ovh:ALIRUOtoiM/NKfVaL+I+AFU9/BYDOqBbm081csf8Xz0="
    ];
  };
}
