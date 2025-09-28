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

  environment.systemPackages = with pkgs; [
    bash
    bat
    cmake
    coreutils
    curl # Command line tool for transferring files with URL syntax
    file
    linuxPackages.cpupower
    lsof # Tool to list open files
    networkmanager
    openssh
    psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    pwgen
    sudo
    unzip # Extraction utility for archives compressed in .zip format
    wget
    xsel
    bottom # Cross-platform graphical process/system monitor with a customizable interface
    ctags # Tool for fast source code browsing (exuberant ctags)

    autojump # `cd' command that learns
    curlie # The power of curl, the ease of use of httpie.
    broot # Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands
    duf # A better df alternative
    dust # A more intuitive version of du written in rust.
    doggo # Command-line DNS Client for Humans. Written in Golang
    emoji-picker # CLI Emoji picker
    entr # A utility that runs commands when files change, useful for automation.
    fd # Simple, fast and user-friendly alternative to find
    ffmpeg
    gping # Ping, but with a graph
    glances # Glances an Eye on your system. A top/htop alternative for GNU/Linux, BSD, Mac OS and Windows operating systems.
    gtop # System monitoring dashboard for terminal.
    htop # Interactive process viewer
    httpie # A modern, user-friendly command-line HTTP client for the API era.
    jq # Lightweight and flexible command-line JSON processor
    jql # JSON Query Language CLI tool built with Rust
    just # A command runner for managing project-specific tasks with simple commands
    keyd # Key mapping
    ncdu # Disk usage analyzer with an ncurses interface
    nixfmt-rfc-style
    nixfmt-tree
    ntfs3g # FUSE-based NTFS driver with full write support
    pet # CLI Snippet Manager
    plocate # locate replacement
    procs # A modern replacement for ps written in Rust.
    taskwarrior3 # A command-line tool for efficient task management.
    tldr # Simplified and community-driven man pages
    ripgrep # Replacement for grep
    rm-improved # Replacement for rm with focus on safety, ergonomics and performance
    screenfetch # Fetches system/theme information in terminal for Linux desktop screenshots
    worker # Orthodox file manager
    xh # Friendly and fast tool for sending HTTP requests
    yq # Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents
    zenith # Interactive process viewer
  ];
}
