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
    unstable.dotnet-sdk

    unstable.php84
    unstable.php84Packages.composer
    unstable.php84Packages.psalm
    unstable.php84Packages.phpstan
    unstable.php84Packages.phpmd
    unstable.php84Packages.php-codesniffer
    unstable.php84Packages.php-parallel-lint

    unstable.nodejs
    unstable.go
    unstable.gitAndTools.gitFull
    unstable.gitAndTools.git-extras
    unstable.gitAndTools.git2cl
    unstable.gitAndTools.tig

    unstable.python3
    unstable.temurin-bin # OpenJDK
    unstable.awscli
    unstable.s3cmd
    unstable.mycli
    unstable.ansible
    unstable.httpie

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.dive
    unstable.minio-client
    unstable.mycli
    unstable.usql
    unstable.lftp
    unstable.soapui
    unstable.terraform
    
    unstable.jetbrains.rider
    unstable.jetbrains.goland
    unstable.jetbrains.phpstorm

    unstable.insomnia
    unstable.resp-app

    unstable.arduino
  ];
}
