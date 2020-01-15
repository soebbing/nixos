{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
    s3cmd
    openvpn
    ansible
    vagrant
    virtualbox
    gitAndTools.gitFull
  ];
}
