{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nixpkgs.config.packageOverrides = pkgs: {
    shyim = import (builtins.fetchTarball
      "https://github.com/shyim/nix-packages/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  environment.systemPackages = with pkgs; [
    dotnet3-sdk

    unstable.php80
    unstable.php80Packages.composer2
    unstable.php80Packages.psalm
    unstable.php80Packages.phpcs
    unstable.php80Packages.phpstan
    unstable.php80Packages.phpmd
    unstable.php80Packages.phpcbf
    unstable.php80Packages.php-cs-fixer
    unstable.php80Packages.php-parallel-lint

    unstable.nodejs-12_x
    unstable.go_bootstrap
    unstable.gitAndTools.gitFull
    unstable.gitAndTools.git-annex
    unstable.gitAndTools.git-extras
    unstable.gitAndTools.git2cl
    unstable.gitAndTools.tig

    unstable.python3
    unstable.adoptopenjdk-bin
    unstable.awscli
    unstable.s3cmd
    unstable.openvpn
    unstable.ansible
    linphone # Kaputt am 07.01.2021

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.k3s
    unstable.kubectl
    unstable.kubectx
    unstable.percona-xtrabackup
    unstable.dive
    vagrant
    unstable.minio-client
    unstable.lftp
    unstable.soapui

    unstable.jetbrains.rider
    unstable.jetbrains.datagrip
    unstable.jetbrains.phpstorm

    unstable.insomnia
    unstable.redis-desktop-manager

    unstable.etcher
    unstable.arduino
  ];
}
