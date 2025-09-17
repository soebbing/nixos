{
  config,
  pkgs,
  lib,
  ...
}:

let
  path = pkgs.lib.concatStringsSep ":" [
    "$HOME/go/bin"
    "$HOME/.vpn-tool/bin"
    "$HOME/.config/nix-cache/"
    "$HOME/.composer/vendor/bin"
    "$HOME/.npm-packages/bin"
    "$PATH"
  ];

in
{
  environment = {
    variables = {
      EDITOR = "vim";
      TERMINAL = "gnome-terminal";
    };

    loginShellInit = ''
      export TERM="xterm-256color"
      export GOPATH="$HOME/go"
      export PATH="${path}"
    '';

    shellAliases = {
      nano = "nvim";
      vim = "nvim";
      cat = "bat";
      ls = "lsd";
      gs = "git status";
    };
  };

  # Use the fish shell.
  programs.fish = {
    enable = true;
  };
}
