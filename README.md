# nix

My NixOS configuration files.

# Structure

Each device that needs a different setup has it's own "entry point" in `devices/<name>.nix`.
The flake `flake.nix` contains an import of the corresponding entry point for the device you
want to configure.

`home/` contains a [Home Manager](https://nix-community.github.io/home-manager/) setup for the user `hendrik`.

`modules/` contains NixOS configuration modules for a base system, graphical, desktop, laptop, etc.

`pkgs/` contains overlays, custom packages and overrides.

# Prerequisits

Install channels, e.g. for Home Manager and unstable channel as root

`sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable`

`sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager`

`sudo nix flake update -–extra-experimental-features nix-command -–extra-experimental-features flakes`

# Building of the configuration

Modify the paths to match your local configuration!

## On Darwin

`sudo darwin-rebuild switch --flake ~/.config/home-manager/#megatron` (`megatron` is the device name)

## On Linux/NixOS

`sudo nixos-rebuild -- switch --flake ~/.config/home-manager/#lenovo` (`lenovo` is the device name)
