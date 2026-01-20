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
    elixir
    gcc
    gnumake

    go
    grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
    protoc-gen-go # Go support for Google's protocol buffers
    protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
    grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buff

    php84
    php84Packages.composer
    php84Packages.psalm
    php84Packages.phpstan
    php84Packages.phpmd
    #php84Packages.php-codesniffer
    php84Packages.php-parallel-lint
    php84Extensions.xdebug

    dotnet-sdk
    temurin-bin # OpenJDK

    devenv
    cachix

    docker
    docker-compose
  ];
}
