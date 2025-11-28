{ config, pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      nixVersions.latest

      #ansible
      awscli2
      binsider # Perform binary analysis in your terminal.
      csvlens # CSV file viewer and editor
      claude-code
      dive # Docker image analyzer
      dua # Disk Usage Analyzer

      elixir
      gcc

      go
      gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9s
      grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
      protoc-gen-go # Go support for Google's protocol buffers
      protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
      grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buffers
      lnav # Logfile Navigator
      gnumake
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      iredis # Terminal GUI for Redis
      mdfried # Markdown viewer for the terminal that renders headers as Bigger Text than the rest.
      minio-client # S3 client
      mycli # MySQL client
      mariadb.client # For mysqldump

      nodejs # For npx

      oha # HTTP load testing tool
      oxker # A tool for managing Docker containers
      openapi-tui # Unlock the power of APIs with simplicity and speed, right from your terminal. View OpenAPI documentations in your terminal.

      packer # A tool for creating identical machine images for multiple platforms from a single source configuration
      protobuf # Google Protobuf compiler
      python3

      rainfrog # A lightweight and terminal-based tool for interacting with databases.
      rucola # An application to manage markdown notes from your terminal and compile them to HTML

      s3cmd # S3 client
      slumber # Terminal HTTP/REST client
      terraform # Infrastructure as Code tool
      tflint # Terraform linter focused on possible errors, best practices, and so on https://github.com/terraform-linters/tflint
      typos-lsp # Source code spell checker

      usql # General SQL terminal interface
      uv # Fast Python package installer
    ]
    # Only MacOS packages
    ++ lib.optionals pkgs.stdenv.isDarwin [
    ]
    # Linux only packages
    ++ lib.optionals pkgs.stdenv.isLinux [
      tiny-rdm # Redis GUI
      libgcc # GCC library for Linux
    ];
}
