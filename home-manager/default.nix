{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Font-Sizes in Zed depend on the platform
  isDarwin = pkgs.stdenv.isDarwin;
  zedBufferFontSize = if isDarwin then 13 else 15;
  zedUiFontSize = if isDarwin then 14 else 19;
in
{
  home = {
    stateVersion = "25.11";
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

    bottom = {
      enable = true;
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
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
            if test "$TERM_PROGRAM" = "ghostty"
                exec zellij
            end
        end
      '';

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

        fish_add_path --move --prepend $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin ~/.local/bin ~/Code/pcrew-bo/docker/scripts
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
          default = "simple";
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

    superfile = {
      enable = true;
      settings = {
        # More details are at https://superfile.netlify.app/configure/superfile-config/
        theme = "Solarized_Light";

        # The editor files will be opened with. (Leave blank to use the EDITOR environment variable).
        editor = "";

        # The editor directories will be opened with. (Leave blank to use the default editors).
        dir_editor = "";

        # Auto check for update
        auto_check_update = false;

        # Cd on quit (For more details, please check out https://superfile.netlify.app/configure/superfile-config/#cd_on_quit)
        cd_on_quit = true;

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
        code_previewer = "bat";

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

      themes = {
        Solarized_Light = {
          # Solarized Light for superfile
          # Palette source: https://github.com/altercation/solarized

          # ========= Syntax Highlighting =========
          # Chroma style name
          code_syntax_highlight = "solarized-light";

          # ========= Border =========
          file_panel_border = "#93a1a1"; # base1
          sidebar_border = "#93a1a1"; # base2
          footer_border = "#93a1a1"; # base1

          # ========= Border Active =========
          file_panel_border_active = "#268bd2"; # blue
          sidebar_border_active = "#cb4b16"; # orange
          footer_border_active = "#859900"; # green
          modal_border_active = "#6c71c4"; # violet

          # ========= Background (bg) =========
          full_screen_bg = "#fdf6e3"; # base3
          file_panel_bg = "#fdf6e3"; # base3
          sidebar_bg = "#fdf6e3"; # base2
          footer_bg = "#fdf6e3"; # base2
          modal_bg = "#fdf6e3"; # base3

          # ========= Foreground (fg) =========
          full_screen_fg = "#657b83"; # base00
          file_panel_fg = "#657b83"; # base00
          sidebar_fg = "#657b83"; # base00
          footer_fg = "#657b83"; # base00
          modal_fg = "#657b83"; # base00

          # ========= Special Color =========
          cursor = "#586e75"; # base01
          correct = "#859900"; # green
          error = "#dc322f"; # red
          hint = "#2aa198"; # cyan
          cancel = "#cb4b16"; # orange

          # Gradient color can only have two colors!
          gradient_color = [
            "#268bd2"
            "#6c71c4"
          ]; # blue → violet

          # ========= File Panel Special Items =========
          file_panel_top_directory_icon = "#859900"; # green
          file_panel_top_path = "#268bd2"; # blue
          file_panel_item_selected_fg = "#073642"; # base02 (good contrast on base2)
          file_panel_item_selected_bg = "#eee8d5"; # base2

          # ========= Sidebar Special Items =========
          sidebar_title = "#b58900"; # yellow
          sidebar_item_selected_fg = "#073642"; # base02
          sidebar_item_selected_bg = "#eee8d5"; # base2
          sidebar_divider = "#93a1a1"; # base1

          # ========= Modal Special Items =========
          modal_cancel_fg = "#073642"; # base02
          modal_cancel_bg = "#cb4b16"; # orange
          modal_confirm_fg = "#073642"; # base02
          modal_confirm_bg = "#859900"; # green

          # ========= Help Menu =========
          help_menu_hotkey = "#268bd2"; # blue
          help_menu_title = "#d33682"; # magenta
        };
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
        plenary-nvim
        telescope-nvim
        scope-nvim
      ];
      initLua = ''
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
        autosave = "on_focus_change";
        buffer_font_size = zedBufferFontSize;
        buffer_font_family = "JetBrains Mono, MesloLGS Nerd Font, Droid Sans Mono";
        buffer_font_weight = 400;

        ui_font_size = zedUiFontSize;
        ui_font_family = ".SystemUIFont"; # "JetBrains Mono, MesloLGS Nerd Font";
        ui_font_weight = 400;

        agent_font_size = 15;

        # Terminal Font Settings
        terminal = {
          font_family = "JetBrainsMono Nerd Font, MesloLGL Nerd Font, Droid Sans Mono";
          font_size = 13;
          # Terminal line height: comfortable (1.618), standard(1.3) or `{ "custom": 2 }`
          line_height = "standard";
        };

        profiles = {
          presentation = {
            buffer_font_size = 22;
            ui_font_size = 22;
            theme = "Solarized Dark";
          };
        };

        telemetry = {
          metrics = false;
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
      enableFishIntegration = false; # Manually controlled in shell.nix to only run in Ghostty
      settings = {
        theme = "gruvbox-light"; # "solarized-light" is hardly readable
      };
    };
  };

  imports = [
    ./packages
  ];
}
