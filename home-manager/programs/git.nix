{ config
, pkgs
, lib
, ...
}:

{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };

    git = {
      enable = true;

      signing = {
        format = "ssh";
        key = "~/.ssh/id_rsa.pub";
        signByDefault = true;
      };

      settings = {
        user = {
          name = "Hendrik Söbbing";
          email = "hendrik@soebbing.de";
        };

        delta.enable = true;

        aliases = {
          co = "checkout";
          s = "status";
          fpush = "push --force-with-lease";
        };

        branch = {
          sort = "-committerdate";
        };
        color = {
          ui = "auto";
        };
        column = {
          ui = "auto";
        };
        init = {
          defaultBranch = "main";
        };
        merge = {
          tool = "splice";
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
      };
    };

    # Broken on mac (2025-10-20)
    gitui = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
    };

    # Interface for jujutsu
    jjui = {
      enable = true;
    };

    # Git-compatible DVCS that is both simple and powerful
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "hendrik@soebbing.de";
          name = "Hendrik Söbbing";
        };
      };
    };

    lazygit = {
      enable = true;
    };

    lazydocker = {
      enable = true;
    };
  };
}
