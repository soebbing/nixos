{
  config,
  lib,
  pkgs,
  ...
}:

let
  unstable = import <nixpkgs> { };

in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    shyim =
      import (builtins.fetchTarball "https://github.com/shyim/nix-packages/archive/master.tar.gz")
        {
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

    unstable.iredis # Terminal GUI for Redis
    unstable.temurin-bin # OpenJDK
    unstable.awscli
    unstable.s3cmd
    unstable.mycli # MySQL client
    unstable.usql # General SQL terminal interface
    unstable.ansible
    unstable.httpie # Command line HTTP client whose goal is to make CLI human-friendly

    unstable.devenv
    unstable.cachix

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.dive
    unstable.minio-client
    unstable.soapui
    unstable.terraform
    
    #unstable.jetbrains.rider
    unstable.jetbrains.goland
    unstable.jetbrains.phpstorm

    unstable.code-cursor # AI-powered code editor built on vscode
    unstable.insomnia # REST API GUI
    unstable.tiny-rdm # Redis GUI

    unstable.arduino # Open-source electronics prototyping platform
  ];
}
