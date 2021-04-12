{ config, lib, pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {};

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

    unstable.php74
    unstable.php74Packages.composer
    unstable.php74Packages.psalm
    unstable.php74Packages.phpcs
    unstable.php74Packages.phpstan
    unstable.php74Packages.phpmd
    unstable.php74Packages.phpcbf
    unstable.php74Packages.php-cs-fixer
    unstable.php74Packages.php-parallel-lint

    unstable.nodejs-12_x
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
    unstable.vagrant
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
