# nix

My NixOS configuration files.

# Structure

`modules/` contains NixOS configuration modules. Each device has its
"entry point" in `devices/<name>.nix`. `/etc/nixos/configuration.nix` is
empty and only contains an import of the corresponding entry point.

`pkgs/` contains overlays, custom packages and overrides.

# Prerequisits

Install channels, e.g. for Home Manager
`nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager`