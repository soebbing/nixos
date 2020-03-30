{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ./packages.nix ./users.nix ./services.nix ];

  networking.extraHosts = ''
  '';

  programs.ssh.startAgent = true;
}
