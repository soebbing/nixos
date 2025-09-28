{ config, pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      nixVersions.stable

      #ansible
      arduino-cli
      awscli2
      bandwhich # Terminal bandwidth utilization tool
      bottom # A customizable cross-platform graphical process/system monitor inspired by tools like htop, gtop, etc. Command: btm
      broot # A new way to see and navigate directory trees
      cachix
      cmake # Cross-platform make
      devenv
      dive # A tool for exploring each layer in a docker image
      #docker
      delve # Debugger for the Go programming language
      doggo # Command-line DNS client for humans
      dua # View disk space usage and delete unwanted data, fast.
      duf # Disk Usage/Free Utility
      dust # A more intuitive version of du
      elixir
      exiftool # File metadata, used for superfile
      fd # A simple, fast and user-friendly alternative to 'find'
      felix-fm # tui file manager with vim-like key mapping. Command: fx
      fzy # A simple, fast fuzzy finder for the terminal. Used by neovim-fuzzy
      glab # A command line tool for gitlab
      gping # Ping, but with a graph
      go
      #gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9s
      grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
      protoc-gen-go # Go support for Google's protocol buffers
      protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
      grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buffers
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      inetutils # A collection of common network programs
      jql # A JSON query language CLI tool
      lemmeknow # Identify mysterious text or analyze hard-coded strings from captured network packets, malwares, and more.
      libusb1
      litecli # SQLlite client
      lnav # Logfile Navigator
      mariadb-client
      mc # Midnight Commander
      most # Better more/less
      mycli # MySQL client
      mysql-client # Für mysqldump
      fastfetch # A maintained, feature-rich and performance oriented, neofetch like system information tool
      ncdu # A disk usage analyzer with an ncurses interface
      ngrok # Secure introspectable tunnels to localhost
      nmap # Network exploration tool and security / port scanner
      nodejs_24 # For npx
      nvd # Nix package diff
      ollama # Get up and running with large language models locally
      onefetch # Stats about git repos
      packer # A tool for creating identical machine images for multiple platforms from a single source configuration
      php84
      php84Extensions.xdebug
      pre-commit # Pre-Commit Hooks https://pre-commit.com/
      procps # Legacy ps command (among others)
      procs # Modern replacement for ps written in Rust
      protobuf # Google Protobuf compiler
      ripgrep # Recursively searches directories for a regex pattern
      rm-improved # A safe and ergonomic alternative to rm
      screenfetch # System information tool
      sshs # Interface for SSH connections in ssh/config
      symfony-cli
      tealdeer # A very fast implementation of tldr in Rust
      terraform
      tflint # Terraform linter focused on possible errors, best practices, and so on https://github.com/terraform-linters/tflint
      tre-command # Better tree comand
      unrar
      wakeonlan
      watch
      xh # "Friendly and fast tool for sending HTTP requests"
      zellij # "A terminal workspace with batteries included"

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    # Only MacOS packages
    ++ lib.optionals pkgs.stdenv.isDarwin [
      #colima
      maccy
    ]
    # Linux only packages
    ++ lib.optionals pkgs.stdenv.isLinux [
      impala # Wifi manager TUI
      flameshot # A screenshot tool, not working on Mac
    ];
}
