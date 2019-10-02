{ config, pkgs, lib, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  # Use the fish shell.
  programs.fish = {
    enable = true;
    shellAliases = {
      nano = "nvim";
      vim = "nvim";
    };
  };
}
