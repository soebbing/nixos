{ config, pkgs, lib, ... }:

let path = pkgs.lib.concatStringsSep ":" [
    "$HOME/go/bin"
    "$HOME/.vpn-tool/bin"
    "$HOME/.config/nix-cache/"
    "$HOME/.composer/vendor/bin"
    "$HOME/.npm-packages/bin"
    "$PATH"
  ];

in {
  environment = {
    variables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };

    loginShellInit = ''
      export TERM="xterm-256color"
      export GOPATH="$HOME/go"
      export PATH="${path}"
    '';

    shellAliases = {
      nano = "nvim";
      vim = "nvim";
    };
  };

  # Use the fish shell.
  programs.fish = {
    enable = true;
  };
}
