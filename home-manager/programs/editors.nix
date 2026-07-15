{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Font-Sizes in Zed depend on the platform
  isDarwin = pkgs.stdenv.isDarwin;
  isI3 = config.xsession.windowManager.i3.enable;
  zedBufferFontSize = (if isDarwin then 13 else 15) - (if isI3 then 5 else 0);
  zedUiFontSize = (if isDarwin then 15 else 19) - (if isI3 then 6 else 0);
  zedFontMono = "MesloLGSDZ Nerd Font Mono";
in
{
  programs = {
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
      mutableUserSettings = false;
      themes = builtins.fromJSON (builtins.readFile ../configs/zed-themes.json);

      userSettings = {
        theme = "Solarized Light";
        autosave = "on_focus_change";
        buffer_font_size = zedBufferFontSize;
        buffer_font_family = zedFontMono;
        buffer_font_weight = 400;

        ui_font_size = zedUiFontSize;
        ui_font_family = ".SystemUIFont"; # "JetBrains Mono, MesloLGS Nerd Font";
        ui_font_weight = 400;

        agent_font_size = 15;

        # Terminal Font Settings
        terminal = {
          font_family = zedFontMono;
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
  };
}
