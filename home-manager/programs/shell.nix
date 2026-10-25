{ config
, pkgs
, lib
, ...
}:

{
  home = {
    sessionVariables = {
      TERMINAL = "gnome-terminal";
      GOPATH = "$HOME/go";
    };

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.vpn-tool/bin"
      "$HOME/.config/nix-cache"
      "$HOME/.composer/vendor/bin"
      "$HOME/.npm-packages/bin"
    ];

    shellAliases = {
      nano = "nvim";
      vim = "nvim";
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
      j = "z";
      more = "most";
      less = "most";
      ps = "procs";
      ls = "eza --long --header --git";
    };
  };

  programs = {
    # Shell History search
    atuin = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        workspaces = true;
        update_check = false;
      };
    };

    bat = {
      enable = true;
      config = {
        theme = "Solarized (light)";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Use the fish shell.
    fish = {
      enable = true;

      # Auto-start zellij, but not in JetBrains IDEs (PHPStorm, GoLand, etc.)
      interactiveShellInit = ''
        if not set -q ZELLIJ
            if test "$TERM_PROGRAM" = "ghostty"; or set -q KITTY_WINDOW_ID
                exec zellij
            end
        end
      '';

      loginShellInit = ''
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

        # Ghostty and Kitty ship terminfo entries missing from the system
        # terminfo database, so ssh and nested sessions cannot resolve them.
        if test "$TERM_PROGRAM" = "ghostty"; or set -q KITTY_WINDOW_ID
            set -x TERM xterm-256color
        end

        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree {} | head -200'"

        function fish_greeting
            printf -n "Fish fzf bindings:
            Keybindings	Remarks
            Ctrl-t		Find a file, paste it into commandline.
            Ctrl-r		Search through command history.
            Alt-c		cd into sub-directories (recursively searched).
            Alt-Shift-c	cd into sub-directories, including hidden ones.
            See: https://github.com/jethrokuan/fzf

            Zoxide:
            z bar    Jump to the most used directory matching "bar"
            zi bar   Interactive directory jump
            "
        end

        # Advanced customization of fzf options via _fzf_comprun function
        # - The first argument to the function is the name of the command.
        # - You should make sure to pass the rest of the arguments to fzf.
        function _fzf_comprun
            set command $argv[1]
            set argv (string split ' ' (string join ' ' $argv[2..-1]))

            switch $command
                case 'cd'
                    fzf --preview 'eza --tree --color=always {} | head -200' $argv
                case 'export' 'unset'
                    fzf --preview "eval 'echo \$'{}" $argv
                case 'ssh'
                    fzf --preview 'dig {}' $argv
                case '*'
                    fzf --preview "bat -n --color=always --line-range :500 {}" $argv
            end
        end

        #${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        fish_add_path --move --prepend $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin ~/.local/bin ~/Code/pcrew-bo/docker/scripts
      '';
    };

    # Generic searching tool
    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
      historyWidget.command = ""; # For compatibility with atuin

      # Solarized Light, Truecolor
      colors = {
        fg = "-1";
        bg = "-1";
        hl = "#268bd2";
        "fg+" = "#073642";
        "bg+" = "#eee8d5";
        "hl+" = "#268bd2";
        info = "#b58900";
        prompt = "#b58900";
        pointer = "#002b36";
        marker = "#002b36";
        spinner = "#b58900";
      };
    };

    # TheFuck-Alternative
    pay-respects = {
      enable = true;
      enableFishIntegration = true;
    };

    # Shell prompt styling
    starship = {
      enable = true;
      enableInteractive = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.readFile ../configs/starship-config.json);
    };

    zellij = {
      enable = true;
      enableFishIntegration = false; # Manually controlled above (Ghostty/Kitty only)
      settings = {
        theme = "gruvbox-light"; # "solarized-light" is hardly readable
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # History search for ctrl-r, backed by an fzf list of atuin history.
  #
  # Inert today: fish sources conf.d/*.fish before config.fish, where atuin's
  # integration binds ctrl-r, so this binding is overridden.
  #
  # The "lls" first-character bug this avoids was a starship prompt width
  # mismatch — the prompt must not end in a variation selector (U+FE0F).
  # See configs/starship-config.json.
  xdg.configFile."fish/conf.d/99-fzf-atuin-history.fish".text = ''
    function _fzf_atuin_history
        set -l current (commandline)
        set -l selected (
            atuin search --format "{command}" --limit 1000 2>/dev/null |
                string uniq |
                fzf --no-sort --query "$current" \
                    --prompt " history> " --height 40% --reverse
        )
        if test -n "$selected"
            # `commandline -r` sets the buffer and fish redraws the line itself.
            commandline -r -- "$selected"
        end
    end

    bind -e ctrl-r
    bind ctrl-r _fzf_atuin_history
  '';
}
