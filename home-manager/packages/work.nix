{ pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      nixVersions.latest

      # LLM coding tools
      amp-cli # Amp CLI (https://ampcode.com/)
      gemini-cli # Gemini client
      claude-code # A command line interface for Anthropic's Claude AI models

      awscli2
      binsider # Perform binary analysis in your terminal.
      csvlens # CSV file viewer and editor

      devenv # Development environment manager
      dive # Docker image analyzer
      docker
      docker-compose

      elixir # Dynamic, functional language designed for building scalable and maintainable applications

      gcc # GNU Compiler Collection
      glab # A command line tool for gitlab
      gnumake # GNU Make utility to maintain groups of programs
      gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9sers

      go # The Go programming language compiler, linker, and standard libraries
      grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
      protobuf # Google Protobuf compiler
      protoc-gen-go # Go support for Google's protocol buffers
      protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
      grpc-gateway # A gRPC to JSON proxy generator plugin for Go

      lnav # Logfile Navigator
      happy-coder # A command line tool for happy-coder
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      insomnia # REST API GUI
      iredis # Terminal GUI for Redis

      jetbrains.goland
      #jetbrains.phpstorm

      mariadb.client # For mysqldump
      mdfried # Markdown viewer for the terminal that renders headers as Bigger Text than the rest.
      minio-client # S3 client
      mycli # MySQL client

      nodejs # For npx
      oha # HTTP load testing tool
      oxker # A tool for managing Docker containers
      openapi-tui # Unlock the power of APIs with simplicity and speed, right from your terminal. View OpenAPI documentations in your terminal.

      packer # A tool for creating identical machine images for multiple platforms from a single source configuration

      pre-commit # Pre-Commit Hooks https://pre-commit.com/
      python3

      php85
      php85Packages.composer
      php85Packages.psalm
      php85Packages.phpmd
      php85Packages.php-codesniffer
      php85Packages.php-parallel-lint
      php85Extensions.xdebug
      phpstan # PHP Static Analysis Tool

      dotnet-sdk # .NET SDK

      rainfrog # A lightweight and terminal-based tool for interacting with databases.
      rucola # An application to manage markdown notes from your terminal and compile them to HTML

      s3cmd # S3 client
      slumber # Terminal HTTP/REST client
      symfony-cli

      temurin-bin # OpenJDK
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
      arduino # Open-source electronics prototyping platform
      tiny-rdm # Redis GUI
      libgcc # GCC library for Linux
      soapui # SOAP API testing tool

      antigravity-fhs # Agentic development platform, evolving the IDE into the agent-first era, wrapped variant of antigravity which launches in a FHS compatible environment, should allow for easy usage of extensions without nix-specific modifications
      code-cursor-fhs # AI-powered code editor built on vscode
      kiro-fhs # IDE for Agentic AI workflows based on VS Code, wrapped variant of kiro which launches in a FHS compatible environment, should allow for easy usage of extensions without nix-specific modifications
    ];
}
