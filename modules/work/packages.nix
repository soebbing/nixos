{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gimp
    python3
    dotnet3-sdk
    adoptopenjdk-bin
    awscli
    s3cmd
    openvpn
    ansible
    vagrant
    postman
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
