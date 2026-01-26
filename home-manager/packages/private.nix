{ config, pkgs, ... }:

let
in
{
  home.packages =
    with pkgs;
    [
      nixVersions.latest

      bandwhich # Terminal bandwidth utilization tool
      bottom # A customizable cross-platform graphical process/system monitor inspired by tools like htop, gtop, etc. Command: btm
      broot # A new way to see and navigate directory trees
      cachix # Cache binary Nix builds
      cmake # Cross-platform make
      dive # A tool for exploring each layer in a docker image
      delve # Debugger for the Go programming language
      doggo # Command-line DNS client for humans
      dua # View disk space usage and delete unwanted data, fast.
      duf # Disk Usage/Free Utility
      dust # A more intuitive version of du
      exiftool # File metadata, used for superfile
      fd # A simple, fast and user-friendly alternative to 'find'
      felix-fm # tui file manager with vim-like key mapping. Command: fx
      fzy # A simple, fast fuzzy finder for the terminal. Used by neovim-fuzzy
      glab # A command line tool for gitlab
      gping # Ping, but with a graph
      gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9s
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      inetutils # A collection of common network programs
      jql # A JSON query language CLI tool
      lemmeknow # Identify mysterious text or analyze hard-coded strings from captured network packets, malwares, and more.
      libusb1
      litecli # SQLlite client
      (pkgs.writeShellScriptBin "mco" ''
        exec ${pkgs.mc}/bin/mc "$@"
      '') # Midnight Commander wrapper with different binary name, conflicts with minio-client
      most # Better more/less
      fastfetch # A maintained, feature-rich and performance oriented, neofetch like system information tool
      ncdu # A disk usage analyzer with an ncurses interface
      nil # Nix language server
      nixd # Nix language server
      ngrok # Secure introspectable tunnels to localhost
      nmap # Network exploration tool and security / port scanner
      nvd # Nix package diff
      ollama # Get up and running with large language models locally
      onefetch # Stats about git repos
      procps # Legacy ps command (among others)
      procs # Modern replacement for ps written in Rust
      ripgrep # Recursively searches directories for a regex pattern
      rm-improved # A safe and ergonomic alternative to rm
      screenfetch # System information tool
      sshs # Interface for SSH connections in ssh/config
      symfony-cli
      tealdeer # A very fast implementation of tldr in Rust
      tre-command # Better tree command
      unrar # RAR file extractor
      wakeonlan # Send magic packets to wake up sleeping computers
      watch # Executes a program periodically, showing output fullscreen
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
      arduino # Open-source electronics prototyping platform
      impala # Wifi manager TUI
      flameshot # A screenshot tool, not working on Mac
      networkmanager-openvpn
      openvpn3
    ];
}
