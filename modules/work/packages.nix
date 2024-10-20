{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs> {};

in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    shyim = import (builtins.fetchTarball
      "https://github.com/shyim/nix-packages/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  environment.systemPackages = with pkgs; [
    unstable.dotnet-sdk_8

    unstable.php83
    unstable.php83Packages.composer
    unstable.php83Packages.psalm
    unstable.php83Packages.phpstan
    unstable.php83Packages.phpmd
    unstable.php83Packages.php-codesniffer
    unstable.php83Packages.php-parallel-lint

    unstable.nodejs
    unstable.go
    unstable.gitAndTools.gitFull
    unstable.gitAndTools.git-extras
    unstable.gitAndTools.git2cl
    unstable.gitAndTools.tig

    unstable.python3
    unstable.adoptopenjdk-bin
    unstable.awscli
    unstable.s3cmd
    unstable.openvpn
    unstable.ansible
    unstable.linphone

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.k3s
    unstable.kubectl
    unstable.kubectx
    unstable.percona-xtrabackup
    unstable.dive
    unstable.minio-client
    unstable.lftp
    unstable.soapui

    unstable.jetbrains.rider
    unstable.jetbrains.datagrip
    unstable.jetbrains.phpstorm

    unstable.insomnia
    unstable.resp-app

    unstable.arduino
  ];
}
