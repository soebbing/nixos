{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    dotnet3-sdk

    python3
    adoptopenjdk-bin
    awscli
    s3cmd
    openvpn
    ansible
    linphone

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.k3s
    unstable.kubectl
    unstable.kubectx
    unstable.percona-xtrabackup
    unstable.dive
    unstable.virtualboxWithExtpack
    unstable.vagrant
    unstable.minio-client
    unstable.lftp

    jetbrains.rider
    unstable.jetbrains.phpstorm
    unstable.jetbrains.goland
    unstable.jetbrains.idea-ultimate
    unstable.jetbrains.datagrip
    unstable.insomnia
    unstable.redis-desktop-manager

    unstable.etcher
    unstable.arduino
  ];
}
