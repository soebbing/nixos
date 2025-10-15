{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    stateVersion = "25.05";
    username = "hendrik";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/hendrik" else "/home/hendrik";
    shell.enableFishIntegration = true;
    sessionVariables = {
    };

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

  programs = {
    home-manager.enable = true;

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

    autojump = {
      enable = true;
      enableFishIntegration = true;
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

    fish = {
      enable = true;

      loginShellInit = ''
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

        # Fix Ghostty (only on Linux)
        if test "$TERM_PROGRAM" = "ghostty"
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

          Autojump:
          jc bar   Jump to child dir
          jo bar   Open dir in file manager
          jco bar  Open child dir in file manager
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

        fish_add_path --move --prepend $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin ~/.local/bin` ~/Code/pcrew-bo/docker/scripts
      '';
    };

    # Generic searching tool
    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
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

    git = {
      enable = true;
      userName = "Hendrik Söbbing";
      userEmail = "hendrik@soebbing.de";

      delta.enable = true;

      aliases = {
        co = "checkout";
        s = "status";
      };

      extraConfig = {
        alias = {
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
        commit = {
          gpgsign = true;
        };
        gpg = {
          format = "ssh";
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
          default = "simple";
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        user = {
          signingkey = "~/.ssh/id_rsa.pub";
        };
      };
    };

    gitui = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    # Broken on mac (2025-10-06)
    kitty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;
      themeFile = "Solarized_Light";
    };

    lazygit = {
      enable = true;
    };

    lazydocker = {
      enable = true;
    };

    # Directory listing with colors
    eza = {
      enable = true;
      enableFishIntegration = true;
      colors = "always";
      git = true;
      icons = "always";
      theme = "gruvbox-light";
    };

    # Shell prompt styling
    starship = {
      enable = true;
      enableInteractive = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.readFile ./configs/starship-config.json);
    };

    # Broken on mac (2025-09-10)
    ghostty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      enableFishIntegration = true;
      # Configuration: https://ghostty.zerebos.com
      settings = {
        theme = "dark:Builtin Solarized Dark,light:Builtin Solarized Light";
        # Use a Nerd Font for icons, with a fallback for any missing characters
        font-family = "MesloLGS Nerd Font, Droid Sans Mono";

        # Enable programming ligatures (like ->, ===, etc.)
        #font-feature-settings = "\"calt\" 1, \"liga\" 1";

        font-size = 13;
      };
    };

    # TheFuck-Alternative
    pay-respects = {
      enable = true;
      enableFishIntegration = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      mouse = true;
    };

    superfile = {
      enable = true;
      settings = {
        # More details are at https://superfile.netlify.app/configure/superfile-config/
        theme = "gruvbox";

        # The editor files will be opened with. (Leave blank to use the EDITOR environment variable).
        editor = "";

        # The editor directories will be opened with. (Leave blank to use the default editors).
        dir_editor = "";

        # Auto check for update
        auto_check_update = true;

        # Cd on quit (For more details, please check out https://superfile.netlify.app/configure/superfile-config/#cd_on_quit)
        cd_on_quit = false;

        # Whether to open file preview automatically every time superfile is opened.
        default_open_file_preview = true;

        # Whether to show image preview
        show_image_preview = true;

        # Whether to hide additional footer info for file panel.
        show_panel_footer_info = true;

        # The path of the first file panel when superfile is opened.
        default_directory = ".";

        # Display file sizes using powers of 1000 (kB, MB, GB) instead of powers of 1024 (KiB, MiB, GiB).
        file_size_use_si = false;

        # Default sort type (0: Name, 1: Size, 2: Date Modified, 3: Type).
        default_sort_type = 0;

        # Default sort order (false: Ascending, true: Descending).
        sort_order_reversed = false;

        # Case sensitive sort by name (upper "B" comes before lower "a" if true).
        case_sensitive_sort = false;

        # Whether to exit the shell on successful command execution.
        shell_close_on_success = false;

        # Whether to enable debug mode.
        debug = false;

        # Whether to ignore warnings about missing fields in the config file.
        ignore_missing_fields = false;

        # ================   Style =================
        #
        # Whether to use the builtin syntax highlighting with chroma or use bat. Values: "" for builtin chroma, "bat" for bat
        code_previewer = "";

        # If you don't have or don't want Nerdfont installed you can turn this off
        nerdfont = true;

        # Set transparent background or not (this only work when your terminal background is transparent)
        transparent_background = false;

        # File preview width allow '0' (this mean same as file panel),'x' x must be from 2 to 10 (This means that the width of the file preview will be one xth of the total width.)
        file_preview_width = 0;

        # The length of the sidebar. If you don't want to display the sidebar, you can input 0 directly. If you want to display the value, please place it in the range of 3-20.
        sidebar_width = 20;

        # Border style
        # Make sure to add strings exactly one character wide. Use ' ' for borderless
        border_top = "─";
        border_bottom = "─";
        border_left = "│";
        border_right = "│";
        border_top_left = "╭";
        border_top_right = "╮";
        border_bottom_left = "╰";
        border_bottom_right = "╯";
        border_middle_left = "├";
        border_middle_right = "┤";

        # ========== PLUGINS ========== #
        # Plugins means that you need to install some external dependencies to use them.

        # Show more detailed metadata, please install exiftool before enabling this plugin!
        metadata = true;

        # Enable MD5 checksum generation for files
        enable_md5_checksum = false;

        # Zoxide support for the fast navigation
        zoxide_support = true;
      };
      hotkeys = {
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = false;
      withRuby = false;
      plugins = with pkgs.vimPlugins; [
        neovim-sensible
        neovim-fuzzy
        nvim-tree-lua
        nvim-cmp
        solarized-nvim
        lualine-nvim
        telescope-nvim
        scope-nvim
      ];
      extraLuaConfig = ''
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.opt.termguicolors = true

        require("scope").setup({})
        require('telescope').setup()
        require('telescope').load_extension("scope")
        require("telescope")
        require("solarized").set()
        require("nvim-tree").setup({
          sort = {
            sorter = "case_sensitive";
          },
          view = {
            width = 30,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = false,
          },
        })
        require('lualine').setup {
          options = {
            theme = 'solarized'
          }
        }
      '';
      extraConfig = ''
        let mapleader = " "
        set nocompatible
        set backspace=indent,eol,start
        " Turn on syntax highlighting by default
        syntax on
        colorscheme solarized

        " Uses neovim-fuzzy
        nnoremap <C-p> :FuzzyOpen<CR>
        nnoremap <C-b> :Telescope scope buffers<CR>
        nnoremap <C-t> :NvimTreeToggle<CR>
        nnoremap <C-f> :NvimTreeFindFile<CR>
        nnoremap <C-n> :tabnew<CR>

        nnoremap <silent> <leader>b :Telescope scope buffers<cr>
        nnoremap <silent> <leader>t :NvimTreeToggle<cr>
        nnoremap <silent> <leader>f :NvimTreeFindFile<cr>
      '';
    };

    zed-editor = {
      enable = true;
      themes = builtins.fromJSON (builtins.readFile ./configs/zed-themes.json);
      userSettings = {
        theme = "Solarized Light";
        buffer_font_size = 16;
        buffer_font_family = "MesloLGS Nerd Font, Droid Sans Mono";
        ui_font_size = 20;
        ui_font_family = "Adwaita Sans";
        telemetry = {
          metrics = false;
        };
        profiles = {
          presentation = {
            buffer_font_size = 22;
            ui_font_size = 22;
            theme = "Solarized Dark";
          };
        };
      };
      userTasks = [
        {
          label = "Format Nix Code";
          command = "nix";
          args = [
            "fmt"
            "$ZED_WORKTREE_ROOT"
          ];
        }
      ];
      extensions = [
        "adawait"
        "adawait-pastel"
        "caddyfile"
        "csharp"
        "docker-compose"
        "dockerfile"
        "elixir"
        "env"
        "fish"
        "git-firefly"
        "http"
        "ini"
        "java"
        "jetbrains-new-icons"
        "jetbrains-themes"
        "nginx"
        "php"
        "psalm"
        "solarized"
        "solarized-fp"
        "ssh-config"
        "svelte"
        "svelte-snippets"
        "terraform"
        "twig"
        "typos"
        "vue"
        "vue-snippets"
        "vue-theme"
      ];
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        theme = "gruvbox-light"; # "solarized-light" is hardly readable
      };
    };
  };

  imports = [
    ./packages
  ];
}
