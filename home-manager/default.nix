{ config
, pkgs
, lib
, ...
}:

{
  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "full";
  };

  home = {
    stateVersion = "25.11";
    username = "hendrik";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/hendrik" else "/home/hendrik";
    shell.enableFishIntegration = true;
    sessionVariables = { };

    # Available in any shell, but one needs to be enabled below
    shellAliases = {
      cat = "bat";
      df = "duf";
      ping = "gping";
      spf = "superfile";
      tree = "tre";
      ga = "git add";
      gc = "git commit --signoff";
      gd = "git diff";
      gs = "git status";
      gp = "git push";
      gpr = "git pull --rebase";
      more = "most";
      less = "most";
      ps = "procs";
      ls = "eza --long --header --git";
    };
  };

  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-light";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur-light"; # Falls im Paket enthalten, sonst z.B. "Papirus-Light"
      package = pkgs.whitesur-icon-theme;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };

  imports = [
    ./packages
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/editors.nix
    ./programs/terminals.nix
    ./programs/files.nix
  ];
}
