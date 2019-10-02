{ config, pkgs, ... }:

{
  imports = [ ../base ./packages.nix ./services.nix ];
}
