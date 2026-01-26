{ config, pkgs, ... }:

let
in
{
  home.packages =
    with pkgs;
    [
      nixVersions.latest

        devenv # Development environment manager
        elixir # Dynamic, functional language designed for building scalable and maintainable applications
        gcc # GNU Compiler Collection
        gnumake # GNU Make utility to maintain groups of programs
        #pre-commit # Pre-Commit Hooks https://pre-commit.com/

        go # The Go programming language compiler, linker, and standard libraries
        grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
        protoc-gen-go # Go support for Google's protocol buffers
        protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
        grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buff

        nodejs # For npx
        python3

        php84
        php84Packages.composer
        php84Packages.psalm
        php84Packages.phpmd
        php84Packages.php-codesniffer
        php84Packages.php-parallel-lint
        php84Extensions.xdebug
        phpstan # PHP Static Analysis Tool

        #dotnet-sdk # .NET SDK
        temurin-bin # OpenJDK

        docker
        docker-compose
    ];
}
    