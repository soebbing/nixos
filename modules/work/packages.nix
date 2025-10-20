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
    php84
    php84Packages.composer
    php84Packages.psalm
    php84Packages.phpstan
    php84Packages.phpmd
    php84Packages.php-codesniffer
    php84Packages.php-parallel-lint

    dotnet-sdk
    temurin-bin # OpenJDK

    devenv
    cachix

    docker
    docker-compose

    soapui # SOAP API testing tool

    #jetbrains.rider
    jetbrains.goland
    jetbrains.phpstorm

    code-cursor-fhs # AI-powered code editor built on vscode

    insomnia # REST API GUI

    arduino # Open-source electronics prototyping platform
  ];
}
