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
    gitAndTools.git-annex
    gitAndTools.git-extras
    gitAndTools.git2cl
    gitAndTools.tig
  ];
}
