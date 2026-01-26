{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Only import files if they exist
  optionalImports = lib.filter (path: builtins.pathExists path) [
    ./private.nix
    ./work.nix
    ./programming.nix
  ];
in
{
  imports = optionalImports;
}
