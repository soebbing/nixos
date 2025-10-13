{ config, pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      nixVersions.latest

      #awscli2
      elixir
      go
      #gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9s
      grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
      protoc-gen-go # Go support for Google's protocol buffers
      protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
      grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buffers
      lnav # Logfile Navigator
      mariadb-client
      mycli # MySQL client
      mysql-client # Für mysqldump
      nodejs_24 # For npx
      packer # A tool for creating identical machine images for multiple platforms from a single source configuration
      protobuf # Google Protobuf compiler
      terraform
      tflint # Terraform linter focused on possible errors, best practices, and so on https://github.com/terraform-linters/tflint
      tre-command # Better tree comand
      typos-lsp # Source code spell checker
    ]
    # Only MacOS packages
    ++ lib.optionals pkgs.stdenv.isDarwin [
    ]
    # Linux only packages
    ++ lib.optionals pkgs.stdenv.isLinux [
    ];
}
