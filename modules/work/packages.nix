{
  config,
  lib,
  pkgs,
  ...
}:

let

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
    dotnet-sdk

    php84
    php84Packages.composer
    php84Packages.psalm
    php84Packages.phpstan
    php84Packages.phpmd
    php84Packages.php-codesniffer
    php84Packages.php-parallel-lint

    nodejs
    go
    gitAndTools.gitFull
    gitAndTools.git-extras
    gitAndTools.git2cl
    gitAndTools.tig

    iredis # Terminal GUI for Redis
    temurin-bin # OpenJDK
    awscli
    s3cmd
    mycli # MySQL client
    usql # General SQL terminal interface
    uv # Fast Python package installer
    python314
    ansible
    httpie # Command line HTTP client whose goal is to make CLI human-friendly

    devenv
    cachix

    docker
    docker-compose
    dive
    minio-client
    soapui
    terraform

    #jetbrains.rider
    jetbrains.goland
    jetbrains.phpstorm

    code-cursor-fhs # AI-powered code editor built on vscode
    insomnia # REST API GUI
    tiny-rdm # Redis GUI

    arduino # Open-source electronics prototyping platform
  ];
}
