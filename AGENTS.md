# AI Agent Guide (GEMINI.md)

This file provides guidance to AI assistants (like Gemini CLI, Claude Code, GitHub Copilot) when working with code in this repository.

## Overview

This is a NixOS + Home Manager configuration repository using flakes. It manages both NixOS systems (Linux) and Darwin (macOS) configurations with a modular structure.

## Build Commands

### NixOS (Linux)
Switch configuration for device `lenovo`:
```bash
sudo nixos-rebuild switch --flake .#lenovo
```

Switch configuration for device `lenovo-omarchy` (with custom omarchy theme):
```bash
sudo nixos-rebuild switch --flake .#lenovo-omarchy
```

### Darwin (macOS)
Switch configuration for device `megatron`:
```bash
darwin-rebuild switch --flake .#megatron
```

### Formatting
Format Nix code:
```bash
nix fmt
```

Update flake inputs:
```bash
nix flake update
```

## Architecture

### Device Entry Points
Each device has its own entry point in `devices/<name>.nix`:
- `lenovo-t14.nix` - Main Linux workstation configuration
- Device files import relevant modules and device-specific hardware scans

### Module Structure
- `modules/base/` - Core NixOS settings (hardware, packages, shell, cache, i18n)
- `modules/desktop/` - Desktop environment configurations
  - `manager/` - Desktop manager modules (xfce.nix, gnome.nix, kde.nix, i3.nix, pantheon.nix)
  - `notebook.nix` - Laptop-specific settings (power management, etc.)
- `modules/work/` - Work-related packages and services
- `modules/server/` - Server configurations

### Home Manager
- `home-manager/default.nix` - Main user configuration (shell, programs, themes)
- `home-manager/packages/` - Optional package sets (private.nix, work.nix) that are conditionally imported if they exist

### Custom Packages
- `pkgs/overlays/` - Nixpkgs overlays for package overrides

### External Dependencies
The flake uses these external inputs:
- `nixpkgs` - Nix package repository (unstable branch)
- `home-manager` - User configuration management
- `nur` - Nix User Repository
- `omarchy-nix` - Custom theme and configuration system (used by lenovo-omarchy)
- `darwin` - nix-darwin for macOS support

## Key Configuration Details

### User
All configurations are for the user `hendrik` with Email and full name.

### Shell & Tools
- Default shell: Fish with auto-started Zellij (in Ghostty terminal only)
- Starship prompt with custom Solarized Light theme
- FZF for fuzzy finding with custom Solarized colors
- Atuin for shell history sync
- Git signing with SSH key

### Desktop Environment
Current devices use:
- `lenovo` - XFCE desktop environment
- `lenovo-omarchy` - Custom omarchy configuration with theme support (gruvbox-light)

### Platform-Specific Conditionals
Many packages use `lib.mkIf pkgs.stdenv.isLinux` or `lib.mkIf pkgs.stdenv.isDarwin` to conditionally enable packages based on platform.

### Configuration Files
- Starship config: `home-manager/configs/starship-config.json`
- Zed themes: `home-manager/configs/zed-themes.json`

### Hardware Specifics
- Hardware scans are stored in `hardware-scans/` directory
- Each device references its corresponding hardware scan file
