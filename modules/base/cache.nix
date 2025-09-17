{ pkgs, lib, ... }:

{
  nix = {
    settings.substituters = [ "https://cache.nixos.org" ];
  };
}
