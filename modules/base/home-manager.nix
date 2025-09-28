{ pkgs, lib, ... }:
{
  home.stateVersion = "25.05"; # match your current NixOS version
  home.shell.enableFishIntegration = true;

  # Shell aliases from home-manager-main
  home.shellAliases = {
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

  # Packages from home-manager-main
  home.packages = with pkgs; [
    nixVersions.stable

    #ansible
    arduino-cli
    awscli2
    bandwhich # Terminal bandwidth utilization tool
    bottom # A customizable cross-platform graphical process/system monitor inspired by tools like htop, gtop, etc. Command: btm
    broot # A new way to see and navigate directory trees
    cachix
    cmake # Cross-platform make
    devenv
    dive # A tool for exploring each layer in a docker image
    #docker
    delve # Debugger for the Go programming language
    doggo # Command-line DNS client for humans
    dua # View disk space usage and delete unwanted data, fast.
    duf # Disk Usage/Free Utility
    dust # A more intuitive version of du
    elixir
    exiftool # File metadata, used for superfile
    fd # A simple, fast and user-friendly alternative to 'find'
    felix-fm # tui file manager with vim-like key mapping. Command: fx
    fzy # A simple, fast fuzzy finder for the terminal. Used by neovim-fuzzy
    glab # A command line tool for gitlab
    gping # Ping, but with a graph
    go
    #gonzo # https://gonzo.controltheory.com/ - A powerful, real-time log analysis terminal UI inspired by k9s
    grpc # The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)
    protoc-gen-go # Go support for Google's protocol buffers
    protoc-gen-go-grpc # The Go language implementation of gRPC. HTTP/2 based RPC
    grpc-gateway # A gRPC to JSON proxy generator plugin for Google Protocol Buffers
    httpie # Command line HTTP client whose goal is to make CLI human-friendly
    inetutils # A collection of common network programs
    jql # A JSON query language CLI tool
    lemmeknow # Identify mysterious text or analyze hard-coded strings from captured network packets, malwares, and more.
    libusb1
    litecli # SQLlite client
    lnav # Logfile Navigator
    mariadb-client
    mc # Midnight Commander
    most # Better more/less
    mycli # MySQL client
    mysql-client # Für mysqldump
    fastfetch # A maintained, feature-rich and performance oriented, neofetch like system information tool
    ncdu # A disk usage analyzer with an ncurses interface
    ngrok # Secure introspectable tunnels to localhost
    nmap # Network exploration tool and security / port scanner
    nodejs_24 # For npx
    nvd # Nix package diff
    ollama # Get up and running with large language models locally
    onefetch # Stats about git repos
    packer # A tool for creating identical machine images for multiple platforms from a single source configuration
    php84
    php84Extensions.xdebug
    pre-commit # Pre-Commit Hooks https://pre-commit.com/
    procps # Legacy ps command (among others)
    procs  # Modern replacement for ps written in Rust
    protobuf # Google Protobuf compiler
    ripgrep # Recursively searches directories for a regex pattern
    rm-improved # A safe and ergonomic alternative to rm
    screenfetch # System information tool
    sshs # Interface for SSH connections in ssh/config
    symfony-cli
    tealdeer # A very fast implementation of tldr in Rust
    terraform
    tflint # Terraform linter focused on possible errors, best practices, and so on https://github.com/terraform-linters/tflint
    tre-command # Better tree comand
    unrar
    wakeonlan
    watch
    xh # "Friendly and fast tool for sending HTTP requests"
    zellij # "A terminal workspace with batteries included"

    # Linux only packages (from home-manager-main)
    impala # Wifi manager TUI
    flameshot # A screenshot tool, not working on Mac
  ];

  programs = {

    direnv = {
      enable = true;
    };

    fish = {
      enable = true;
      loginShellInit = ''
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

        # Fix Ghostty
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

                fish_add_path --move --prepend $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin /Users/hendrik/Code/pcrew-bo/docker/scripts
      '';
    };

    git = {
      enable = true;
      userName = "Hendrik Söbbing";
      userEmail = "hendrik@soebbing.de";

      aliases = {
        co = "checkout";
        s = "status";
      };

      delta.enable = true;

      extraConfig = {
        alias = {
          fpush = "push --force-with-lease";
        };
        branch = {
          sort = "--comitterdate";
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
          signingkey = "~/.ssh/id_rsa_privat.pub";
        };
      };
    };

    gitui = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    kitty = {
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

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    # Broken on mac (2025-09-10) - disabled to match home-manager-main
    #ghostty = {
    #  enable = true;
    #  enableFishIntegration = true;
    #  settings = {
    #    theme = "dark:Builtin Solarized Dark,light:Builtin Solarized Light";
    #    font-size = 11;
    #  };
    #};

    # Disabled to match home-manager-main configuration
    #alacritty = {
    #  enable = true;
    #  theme = "solarized_light";
    #  settings = {
    #    font = {
    #      normal = {
    #        family = "Anonymous Pro for Powerline";
    #        style = "Regular";
    #      };
    #    };
    #  };
    #};

    atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    autojump = {
      enable = true;
      enableFishIntegration = true;
    };

    # Shell prompt styling
    starship = {
      enable = true;
      enableInteractive = true;
      enableFishIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        format = "[](red)\$os\$username\[](bg:peach fg:red)\$directory\[](bg:yellow fg:peach)\$git_branch\$git_status\[](fg:yellow bg:green)\$c\$rust\$golang\$nodejs\$php\$java\[](fg:green bg:sapphire)\$conda\[](fg:sapphire bg:lavender)\$time\[ ](fg:lavender)\$cmd_duration\$line_break\$character";

        palette = "catppuccin_mocha";

        os = {
          disabled = false;
          style = "bg:red fg:crust";
        };

        os.symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };

        username = {
          show_always = true;
          style_user = "bg:red fg:crust";
          style_root = "bg:red fg:crust";
          format = "[ $user]($style)";
        };

        directory = {
          style = "bg:peach fg:crust";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };

        git_branch = {
          symbol = "";
          style = "bg:yellow";
          format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
        };

        git_status = {
          style = "bg:yellow";
          format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:green";
          format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:sapphire";
          format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:lavender";
          format = "[[  $time ](fg:crust bg:lavender)]($style)";
        };

        line_break.disabled = true;

        character = {
          disabled = false;
          success_symbol = "[❯](bold fg:green)";
          error_symbol = "[❯](bold fg:red)";
          vimcmd_symbol = "[❮](bold fg:green)";
          vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
          vimcmd_replace_symbol = "[❮](bold fg:lavender)";
          vimcmd_visual_symbol = "[❮](bold fg:yellow)";
        };

        cmd_duration = {
          show_milliseconds = true;
          format = " in $duration ";
          style = "bg:lavender";
          disabled = false;
          show_notifications = true;
          min_time_to_notify = 45000;
        };

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
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

    vscode = {
      enable = true;
      profiles.default.userSettings = {
        # This property will be used to generate settings.json:
        # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
        "editor.formatOnSave" = true;

        "workbench.colorTheme" = "Solarized Light";
        "workbench.preferredDarkColorTheme" = "Solarized Dark";

        profiles.default.extensions = [
          pkgs.vscode-extensions.bbenoist.nix
          pkgs.vscode-extensions.vue.volar
          # pkgs.vscode-extensions.devsense.phptools-vscode
          # pkgs.vscode-extensions.devsense.profiler-php-vscode
          # pkgs.vscode-extensions.devsense.composer-php-vscode
          pkgs.vscode-extensions.ms-azuretools.vscode-docker
          pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        ];
      };
    };

    zed-editor = {
      enable = true;
      themes = builtins.fromJSON ''
        {
          "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
          "author": "harmtemolder",
          "name": "Solarized",
          "themes": [
            {
              "appearance": "dark",
              "name": "Solarized Dark",
              "style": {
                "accents": [
                  "#268bd2"
                ],
                "background": "#002b36",
                "background.appearance": "transparent",
                "border": "#586e75",
                "border.disabled": null,
                "border.focused": "#839496",
                "border.selected": "#268bd2",
                "border.transparent": null,
                "border.variant": null,
                "conflict": "#dc322f",
                "conflict.background": "#002b36",
                "conflict.border": "#dc322f",
                "created": "#859900",
                "created.background": "#002b36",
                "created.border": "#859900",
                "deleted": "#cb4b16",
                "deleted.background": "#002b36",
                "deleted.border": "#cb4b16",
                "drop_target.background": "#073642",
                "editor.active_line.background": "#073642",
                "editor.active_line_number": "#839496",
                "editor.active_wrap_guide": "#586e75",
                "editor.background": "#002b36",
                "editor.document_highlight.bracket_background": "#268bd266",
                "editor.document_highlight.read_background": "#268bd233",
                "editor.document_highlight.write_background": "#268bd233",
                "editor.foreground": "#839496",
                "editor.gutter.background": "#002b36",
                "editor.highlighted_line.background": "#002b36",
                "editor.indent_guide": "#073642",
                "editor.indent_guide_active": "#cb4b16",
                "editor.invisible": "#073642",
                "editor.line_number": "#586e75",
                "editor.subheader.background": "#002b36",
                "editor.wrap_guide": "#073642",
                "element.active": "#073642",
                "element.background": "#073642",
                "element.disabled": "#073642",
                "element.hover": "#073642",
                "element.selected": "#268bd266",
                "elevated_surface.background": "#002b36",
                "error": "#dc322f",
                "error.background": "#002b36",
                "error.border": "#dc322f",
                "ghost_element.active": "#839496",
                "ghost_element.background": "#002b36",
                "ghost_element.disabled": "#586e75",
                "ghost_element.hover": "#073642",
                "ghost_element.selected": "#268bd266",
                "hidden": "#586e75",
                "hidden.background": "#002b36",
                "hidden.border": "#002b36",
                "hint": "#586e75",
                "hint.background": "#073642",
                "hint.border": "#586e75",
                "icon": "#839496",
                "icon.accent": "#268bd2",
                "icon.disabled": "#586e75",
                "icon.muted": "#586e75",
                "icon.placeholder": "#586e75",
                "ignored": "#586e75",
                "ignored.background": "#002b36",
                "ignored.border": "#586e75",
                "info": "#268bd2",
                "info.background": "#002b36",
                "info.border": "#268bd2",
                "link_text.hover": "#268bd2",
                "modified": "#b58900",
                "modified.background": "#002b36",
                "modified.border": "#b58900",
                "pane.focused_border": "#839496",
                "pane_group.border": "#586e75",
                "panel.background": "#073642",
                "panel.focused_border": "#268bd2",
                "panel.indent_guide": "#586e75",
                "panel.indent_guide_active": "#cb4b16",
                "panel.indent_guide_hover": "#839496",
                "players": [
                  {
                    "background": "#268bd2",
                    "cursor": "#268bd2",
                    "selection": "#268bd266"
                  },
                  {
                    "background": "#2aa198",
                    "cursor": "#2aa198",
                    "selection": "#2aa19866"
                  },
                  {
                    "background": "#859900",
                    "cursor": "#859900",
                    "selection": "#85990066"
                  },
                  {
                    "background": "#d33682",
                    "cursor": "#d33682",
                    "selection": "#d3368266"
                  },
                  {
                    "background": "#cb4b16",
                    "cursor": "#cb4b16",
                    "selection": "#cb4b1666"
                  },
                  {
                    "background": "#dc322f",
                    "cursor": "#dc322f",
                    "selection": "#dc322f66"
                  },
                  {
                    "background": "#6c71c4",
                    "cursor": "#6c71c4",
                    "selection": "#6c71c466"
                  },
                  {
                    "background": "#b58900",
                    "cursor": "#b58900",
                    "selection": "#b5890066"
                  }
                ],
                "predictive": "#d33682",
                "predictive.background": "#002b36",
                "predictive.border": "#d33682",
                "renamed": "#d33682",
                "renamed.background": "#002b36",
                "renamed.border": "#d33682",
                "scrollbar.thumb.background": "#83949666",
                "scrollbar.thumb.border": null,
                "scrollbar.thumb.hover_background": "#83949699",
                "scrollbar.track.background": null,
                "scrollbar.track.border": "#073642",
                "search.match_background": "#b5890099",
                "status_bar.background": "#073642",
                "success": "#859900",
                "success.background": "#002b36",
                "success.border": "#859900",
                "surface.background": "#002b36",
                "syntax": {
                  "attribute": {
                    "color": "#268bd2"
                  },
                  "boolean": {
                    "color": "#b58900"
                  },
                  "comment": {
                    "color": "#586e75",
                    "font_style": "italic"
                  },
                  "comment.doc": {
                    "color": "#586e75",
                    "font_style": "italic"
                  },
                  "constant": {
                    "color": "#2aa198"
                  },
                  "constructor": {
                    "color": "#268bd2"
                  },
                  "embedded": {
                    "color": "#839496"
                  },
                  "emphasis": {
                    "color": "#268bd2"
                  },
                  "emphasis.strong": {
                    "color": "#268bd2",
                    "font_weight": 700
                  },
                  "enum": {
                    "color": "#cb4b16"
                  },
                  "function": {
                    "color": "#268bd2"
                  },
                  "hint": {
                    "color": "#4f8297ff",
                    "font_weight": 700
                  },
                  "keyword": {
                    "color": "#859900"
                  },
                  "label": {
                    "color": "#268bd2"
                  },
                  "link_text": {
                    "color": "#268bd2",
                    "font_style": "italic"
                  },
                  "link_uri": {
                    "color": "#6c71c4"
                  },
                  "number": {
                    "color": "#d33682"
                  },
                  "operator": {
                    "color": "#859900"
                  },
                  "predictive": {
                    "background_color": "#002b36",
                    "color": "#d33682"
                  },
                  "preproc": {
                    "color": "#cb4b16"
                  },
                  "primary": {
                    "color": "#839496"
                  },
                  "property": {
                    "color": "#268bd2"
                  },
                  "punctuation": {
                    "color": "#586e75"
                  },
                  "punctuation.bracket": {
                    "color": "#586e75"
                  },
                  "punctuation.delimiter": {
                    "color": "#586e75"
                  },
                  "punctuation.list_marker": {
                    "color": "#586e75"
                  },
                  "punctuation.special": {
                    "color": "#586e75"
                  },
                  "string": {
                    "color": "#2aa198"
                  },
                  "string.escape": {
                    "color": "#586e75"
                  },
                  "string.regex": {
                    "color": "#cb4b16"
                  },
                  "string.special": {
                    "color": "#cb4b16"
                  },
                  "string.special.symbol": {
                    "color": "#cb4b16"
                  },
                  "tag": {
                    "color": "#dc322f"
                  },
                  "text.literal": {
                    "color": "#2aa198"
                  },
                  "title": {
                    "color": "#cb4b16",
                    "font_weight": 700
                  },
                  "type": {
                    "color": "#b58900"
                  },
                  "variable": {
                    "color": "#839496"
                  },
                  "variant": {
                    "color": "#268bd2"
                  }
                },
                "tab.active_background": "#002b36",
                "tab.inactive_background": "#073642",
                "tab_bar.background": "#073642",
                "terminal.ansi.background": "#002b36",
                "terminal.ansi.black": "#073642",
                "terminal.ansi.blue": "#268bd2",
                "terminal.ansi.bright_black": "#002b36",
                "terminal.ansi.bright_blue": "#839496",
                "terminal.ansi.bright_cyan": "#93a1a1",
                "terminal.ansi.bright_green": "#586e75",
                "terminal.ansi.bright_magenta": "#6c71c4",
                "terminal.ansi.bright_red": "#cb4b16",
                "terminal.ansi.bright_white": "#fdf6e3",
                "terminal.ansi.bright_yellow": "#657b83",
                "terminal.ansi.cyan": "#2aa198",
                "terminal.ansi.dim_black": "#073642",
                "terminal.ansi.dim_blue": "#268bd2",
                "terminal.ansi.dim_cyan": "#2aa198",
                "terminal.ansi.dim_green": "#859900",
                "terminal.ansi.dim_magenta": "#d33682",
                "terminal.ansi.dim_red": "#dc322f",
                "terminal.ansi.dim_white": "#eee8d5",
                "terminal.ansi.dim_yellow": "#b58900",
                "terminal.ansi.green": "#859900",
                "terminal.ansi.magenta": "#d33682",
                "terminal.ansi.red": "#dc322f",
                "terminal.ansi.white": "#eee8d5",
                "terminal.ansi.yellow": "#b58900",
                "terminal.background": "#002b36",
                "terminal.bright_foreground": "#93a1a1",
                "terminal.dim_foreground": "#586e75",
                "terminal.foreground": "#839496",
                "text": "#839496",
                "text.accent": "#93a1a1",
                "text.disabled": "#586e75",
                "text.muted": "#586e75",
                "text.placeholder": "#586e75",
                "title_bar.background": "#073642",
                "title_bar.inactive_background": "#073642",
                "toolbar.background": "#002b36",
                "unreachable": "#6c71c4",
                "unreachable.background": "#002b36",
                "unreachable.border": "#6c71c4",
                "warning": "#cb4b16",
                "warning.background": "#002b36",
                "warning.border": "#cb4b16"
              }
            },
            {
              "appearance": "light",
              "name": "Solarized Light",
              "style": {
                "accents": [
                  "#268bd2"
                ],
                "background": "#fdf6e3",
                "background.appearance": "transparent",
                "border": "#93a1a1",
                "border.disabled": null,
                "border.focused": "#657b83",
                "border.selected": "#268bd2",
                "border.transparent": null,
                "border.variant": null,
                "conflict": "#dc322f",
                "conflict.background": "#fdf6e3",
                "conflict.border": "#dc322f",
                "created": "#859900",
                "created.background": "#fdf6e3",
                "created.border": "#859900",
                "deleted": "#cb4b16",
                "deleted.background": "#fdf6e3",
                "deleted.border": "#cb4b16",
                "drop_target.background": "#eee8d5",
                "editor.active_line.background": "#eee8d5",
                "editor.active_line_number": "#657b83",
                "editor.active_wrap_guide": "#93a1a1",
                "editor.background": "#fdf6e3",
                "editor.document_highlight.bracket_background": "#268bd266",
                "editor.document_highlight.read_background": "#268bd233",
                "editor.document_highlight.write_background": "#268bd233",
                "editor.foreground": "#657b83",
                "editor.gutter.background": "#fdf6e3",
                "editor.highlighted_line.background": "#fdf6e3",
                "editor.indent_guide": "#eee8d5",
                "editor.indent_guide_active": "#cb4b16",
                "editor.invisible": "#eee8d5",
                "editor.line_number": "#93a1a1",
                "editor.subheader.background": "#fdf6e3",
                "editor.wrap_guide": "#eee8d5",
                "element.active": "#eee8d5",
                "element.background": "#eee8d5",
                "element.disabled": "#eee8d5",
                "element.hover": "#eee8d5",
                "element.selected": "#268bd266",
                "elevated_surface.background": "#fdf6e3",
                "error": "#dc322f",
                "error.background": "#fdf6e3",
                "error.border": "#dc322f",
                "ghost_element.active": "#657b83",
                "ghost_element.background": "#fdf6e3",
                "ghost_element.disabled": "#93a1a1",
                "ghost_element.hover": "#eee8d5",
                "ghost_element.selected": "#268bd266",
                "hidden": "#93a1a1",
                "hidden.background": "#fdf6e3",
                "hidden.border": "#fdf6e3",
                "hint": "#93a1a1",
                "hint.background": "#eee8d5",
                "hint.border": "#93a1a1",
                "icon": "#657b83",
                "icon.accent": "#268bd2",
                "icon.disabled": "#93a1a1",
                "icon.muted": "#93a1a1",
                "icon.placeholder": "#93a1a1",
                "ignored": "#93a1a1",
                "ignored.background": "#fdf6e3",
                "ignored.border": "#93a1a1",
                "info": "#268bd2",
                "info.background": "#fdf6e3",
                "info.border": "#268bd2",
                "link_text.hover": "#268bd2",
                "modified": "#b58900",
                "modified.background": "#fdf6e3",
                "modified.border": "#b58900",
                "pane.focused_border": "#657b83",
                "pane_group.border": "#93a1a1",
                "panel.background": "#eee8d5",
                "panel.focused_border": "#268bd2",
                "panel.indent_guide": "#93a1a1",
                "panel.indent_guide_active": "#cb4b16",
                "panel.indent_guide_hover": "#657b83",
                "players": [
                  {
                    "background": "#268bd2",
                    "cursor": "#268bd2",
                    "selection": "#268bd266"
                  },
                  {
                    "background": "#2aa198",
                    "cursor": "#2aa198",
                    "selection": "#2aa19866"
                  },
                  {
                    "background": "#859900",
                    "cursor": "#859900",
                    "selection": "#85990066"
                  },
                  {
                    "background": "#d33682",
                    "cursor": "#d33682",
                    "selection": "#d3368266"
                  },
                  {
                    "background": "#cb4b16",
                    "cursor": "#cb4b16",
                    "selection": "#cb4b1666"
                  },
                  {
                    "background": "#dc322f",
                    "cursor": "#dc322f",
                    "selection": "#dc322f66"
                  },
                  {
                    "background": "#6c71c4",
                    "cursor": "#6c71c4",
                    "selection": "#6c71c466"
                  },
                  {
                    "background": "#b58900",
                    "cursor": "#b58900",
                    "selection": "#b5890066"
                  }
                ],
                "predictive": "#d33682",
                "predictive.background": "#fdf6e3",
                "predictive.border": "#d33682",
                "renamed": "#d33682",
                "renamed.background": "#fdf6e3",
                "renamed.border": "#d33682",
                "scrollbar.thumb.background": "#657b8366",
                "scrollbar.thumb.border": null,
                "scrollbar.thumb.hover_background": "#657b8399",
                "scrollbar.track.background": null,
                "scrollbar.track.border": "#eee8d5",
                "search.match_background": "#b5890099",
                "status_bar.background": "#eee8d5",
                "success": "#859900",
                "success.background": "#fdf6e3",
                "success.border": "#859900",
                "surface.background": "#fdf6e3",
                "syntax": {
                  "attribute": {
                    "color": "#268bd2"
                  },
                  "boolean": {
                    "color": "#b58900"
                  },
                  "comment": {
                    "color": "#93a1a1",
                    "font_style": "italic"
                  },
                  "comment.doc": {
                    "color": "#93a1a1",
                    "font_style": "italic"
                  },
                  "constant": {
                    "color": "#2aa198"
                  },
                  "constructor": {
                    "color": "#268bd2"
                  },
                  "embedded": {
                    "color": "#657b83"
                  },
                  "emphasis": {
                    "color": "#268bd2"
                  },
                  "emphasis.strong": {
                    "color": "#268bd2",
                    "font_weight": 700
                  },
                  "enum": {
                    "color": "#cb4b16"
                  },
                  "function": {
                    "color": "#268bd2"
                  },
                  "hint": {
                    "color": "#4f8297ff",
                    "font_weight": 700
                  },
                  "keyword": {
                    "color": "#859900"
                  },
                  "label": {
                    "color": "#268bd2"
                  },
                  "link_text": {
                    "color": "#268bd2",
                    "font_style": "italic"
                  },
                  "link_uri": {
                    "color": "#6c71c4"
                  },
                  "number": {
                    "color": "#d33682"
                  },
                  "operator": {
                    "color": "#859900"
                  },
                  "predictive": {
                    "background_color": "#fdf6e3",
                    "color": "#d33682"
                  },
                  "preproc": {
                    "color": "#cb4b16"
                  },
                  "primary": {
                    "color": "#657b83"
                  },
                  "property": {
                    "color": "#268bd2"
                  },
                  "punctuation": {
                    "color": "#93a1a1"
                  },
                  "punctuation.bracket": {
                    "color": "#93a1a1"
                  },
                  "punctuation.delimiter": {
                    "color": "#93a1a1"
                  },
                  "punctuation.list_marker": {
                    "color": "#93a1a1"
                  },
                  "punctuation.special": {
                    "color": "#93a1a1"
                  },
                  "string": {
                    "color": "#2aa198"
                  },
                  "string.escape": {
                    "color": "#93a1a1"
                  },
                  "string.regex": {
                    "color": "#cb4b16"
                  },
                  "string.special": {
                    "color": "#cb4b16"
                  },
                  "string.special.symbol": {
                    "color": "#cb4b16"
                  },
                  "tag": {
                    "color": "#dc322f"
                  },
                  "text.literal": {
                    "color": "#2aa198"
                  },
                  "title": {
                    "color": "#cb4b16",
                    "font_weight": 700
                  },
                  "type": {
                    "color": "#b58900"
                  },
                  "variable": {
                    "color": "#657b83"
                  },
                  "variant": {
                    "color": "#268bd2"
                  }
                },
                "tab.active_background": "#fdf6e3",
                "tab.inactive_background": "#eee8d5",
                "tab_bar.background": "#eee8d5",
                "terminal.ansi.background": "#fdf6e3",
                "terminal.ansi.black": "#073642",
                "terminal.ansi.blue": "#268bd2",
                "terminal.ansi.bright_black": "#002b36",
                "terminal.ansi.bright_blue": "#839496",
                "terminal.ansi.bright_cyan": "#93a1a1",
                "terminal.ansi.bright_green": "#586e75",
                "terminal.ansi.bright_magenta": "#6c71c4",
                "terminal.ansi.bright_red": "#cb4b16",
                "terminal.ansi.bright_white": "#fdf6e3",
                "terminal.ansi.bright_yellow": "#657b83",
                "terminal.ansi.cyan": "#2aa198",
                "terminal.ansi.dim_black": "#073642",
                "terminal.ansi.dim_blue": "#268bd2",
                "terminal.ansi.dim_cyan": "#2aa198",
                "terminal.ansi.dim_green": "#859900",
                "terminal.ansi.dim_magenta": "#d33682",
                "terminal.ansi.dim_red": "#dc322f",
                "terminal.ansi.dim_white": "#eee8d5",
                "terminal.ansi.dim_yellow": "#b58900",
                "terminal.ansi.green": "#859900",
                "terminal.ansi.magenta": "#d33682",
                "terminal.ansi.red": "#dc322f",
                "terminal.ansi.white": "#eee8d5",
                "terminal.ansi.yellow": "#b58900",
                "terminal.background": "#fdf6e3",
                "terminal.bright_foreground": "#586e75",
                "terminal.dim_foreground": "#93a1a1",
                "terminal.foreground": "#657b83",
                "text": "#657b83",
                "text.accent": "#586e75",
                "text.disabled": "#93a1a1",
                "text.muted": "#93a1a1",
                "text.placeholder": "#93a1a1",
                "title_bar.background": "#eee8d5",
                "title_bar.inactive_background": "#eee8d5",
                "toolbar.background": "#fdf6e3",
                "unreachable": "#6c71c4",
                "unreachable.background": "#fdf6e3",
                "unreachable.border": "#6c71c4",
                "warning": "#cb4b16",
                "warning.background": "#fdf6e3",
                "warning.border": "#cb4b16"
              }
            }
          ]
        }
      '';
      userSettings = {
        theme = "Solarized Light";
        telemetry = {
          metrics = false;
        };
      };
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
}
