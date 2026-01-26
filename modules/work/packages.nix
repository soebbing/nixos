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
  nixpkgs.config.packageOverrides = pkgs: {
    shyim =
      import (builtins.fetchTarball "https://github.com/shyim/nix-packages/archive/master.tar.gz")
        {
          inherit pkgs;
        };
  };
}
