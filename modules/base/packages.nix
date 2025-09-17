{
  config,
  lib,
  pkgs,
  ...
}:

let
  unstable = import <nixos> { };

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.sudo
    unstable.wget
    unstable.bash
    unstable.bat
    unstable.bottom # Cross-platform graphical process/system monitor with a customizable interface
    unstable.cmake
    unstable.curl # Command line tool for transferring files with URL syntax
    unstable.ctags # Tool for fast source code browsing (exuberant ctags)

    unstable.doggo # Command-line DNS Client for Humans. Written in Golang
    unstable.emoji-picker # CLI Emoji picker
    unstable.fd # Simple, fast and user-friendly alternative to find
    unstable.ffmpeg
    unstable.gping # Ping, but with a graph
    unstable.htop # Interactive process viewer
    unstable.jq # Lightweight and flexible command-line JSON processor
    unstable.jql # JSON Query Language CLI tool built with Rust
    unstable.keyd # Key mapping
    unstable.yq # Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents
    unstable.ncdu # Disk usage analyzer with an ncurses interface
    unstable.rm-improved # Replacement for rm with focus on safety, ergonomics and performance
    unstable.screenfetch # Fetches system/theme information in terminal for Linux desktop screenshots
    unstable.tmux # Terminal multiplexer
    unstable.thefuck # Magnificent app which corrects your previous console command
    unstable.xh # Friendly and fast tool for sending HTTP requests
    unstable.zellij # Terminal workspace with batteries included
    unstable.zenith # Interactive process viewer
    unstable.psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    unstable.unzip # Extraction utility for archives compressed in .zip format
    unstable.tldr # Simplified and community-driven man pages
    unstable.lsof # Tool to list open files
    unstable.networkmanager
    unstable.coreutils
    unstable.file
    unstable.linuxPackages.cpupower
    unstable.pwgen
    unstable.openssh
    unstable.xsel
    unstable.nixfmt-rfc-style
    unstable.nixfmt-tree
    unstable.ntfs3g # FUSE-based NTFS driver with full write support
  ];
}
