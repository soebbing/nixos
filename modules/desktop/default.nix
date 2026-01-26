{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./users.nix
    ./services.nix
    ./fonts.nix
  ];

  networking.extraHosts = '''';

  programs.ssh.startAgent = false;
}
