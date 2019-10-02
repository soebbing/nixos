{ config, pkgs, ... }:

{
  imports = [ ./services.nix ./packages.nix ];
}
