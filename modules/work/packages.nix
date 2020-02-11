{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    adoptopenjdk-bin
    awscli
    s3cmd
    openvpn
    ansible
    vagrant
    linphone
    virtualboxWithExtpack
    kubectl
    gitAndTools.gitFull
    gitAndTools.git-annex
    gitAndTools.git-extras
    gitAndTools.git2cl
    gitAndTools.tig
  ];
}
