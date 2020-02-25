{ pkgs, lib, ... }:

{
  nix = {
    binaryCaches = [ "https://cache.nixos.org" ];
  };
}
