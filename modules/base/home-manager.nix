{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.hendrik =
    { config, pkgs, ... }:
    {
      home.stateVersion = "25.05"; # match your current NixOS version
      home.shell.enableFishIntegration = true;

      programs = {
        fish = {
          enable = true;
          loginShellInit = ''

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
            alias ={
              fpush = "push --force-with-lease";
            };
            branch = {
              sort  = "--comitterdate";
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
              enable = true;
              autoUpdate = "true";
            };
            user = {
              signingkey = "~/.ssh/id_rsa_privat.pub";
            };
          };
        };

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

        eza = {
          enable = true;
          enableFishIntegration = true;
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        ghostty = {
          enable = true;
          enableFishIntegration = true;
          settings = {
            theme = "dark:Builtin Solarized Dark,light:Builtin Solarized Light";
            font-size = 11;
          };
        };

        autojump = {
          enable = true;
          enableFishIntegration = true;
        };

        alacritty = {
          enable = true;
          theme = "solarized_light";
          settings = {
            font = {
              normal = {
                family = "Anonymous Pro for Powerline";
                style = "Regular";
              };
            };
          };
        };

        atuin = {
          enable = true;
          enableFishIntegration = true;
        };

        tmux = {
          enable = true;
          mouse = true;
          clock24 = true;
        };

        direnv = {
          enable = true;
        };

        bat.enable = true;
        lazygit.enable = true;
        lazydocker.enable = true;
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraConfig = ''
          colorscheme solarized
          :hi Normal guibg=none ctermbg=none
          :hi NonText guibg=none ctermbg=none
        '';

        plugins = with pkgs.vimPlugins; [
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          plenary-nvim
          gruvbox-material
          mini-nvim
        ];

        extraPackages = [
          pkgs.nodePackages_latest.vscode-json-languageserver
          pkgs.lua-language-server
          pkgs.nil
          pkgs.gopls
          pkgs.gofumpt
        ];
      };

      programs.vscode = {
        enable = true;

        profiles.default.userSettings = {
          # This property will be used to generate settings.json:
          # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
          "editor.formatOnSave" = true;

          "workbench.colorTheme" = "Solarized Light";
          "workbench.preferredDarkColorTheme" = "Solarized Dark";
        };

        profiles.default.extensions = [
          pkgs.vscode-extensions.bbenoist.nix
          pkgs.vscode-extensions.vue.volar
          pkgs.vscode-extensions.devsense.phptools-vscode
          pkgs.vscode-extensions.devsense.profiler-php-vscode
          pkgs.vscode-extensions.devsense.composer-php-vscode
          pkgs.vscode-extensions.ms-azuretools.vscode-docker
          pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        ];
      };

      home.packages = with pkgs; [
        vimPlugins.vim-colors-solarized
      ];
    };
}
