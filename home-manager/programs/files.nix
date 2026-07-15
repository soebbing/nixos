{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    bottom = {
      enable = true;
    };

    element-desktop = {
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

    jq = {
      enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      extraConfig = ''
        KeepAlive yes
        TCPKeepAlive no
        IPQoS throughput
      '';

      settings = {
        "*" = {
          controlMaster = "auto";
          controlPath = "/tmp/ssh_mux_%h_%p_%r";

          compression = true;
          forwardAgent = true;
          serverAliveInterval = 120;
        };

        "gitlab.com" = {
          hostname = "gitlab.com";
          user = "git";
          identityFile = "~/.ssh/id_rsa_privat";
        };

        "pwnagotchi" = {
          hostname = "10.0.0.2";
          user = "pi";
          identityFile = "~/.ssh/id_rsa_privat";
        };

        "homeassistant homeassistant.local" = {
          hostname = "192.168.1.4";
          user = "root";
          identityFile = "~/.ssh/id_rsa_privat";
        };

        "flightradar" = {
          hostname = "192.168.1.3";
          user = "hendrik";
          identityFile = "~/.ssh/id_rsa_privat";
        };

        "handcoding.de builder" = {
          hostname = "handcoding.de";
          user = "hendrik";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_rsa_privat";
        };
      };
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

    yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
    };
  };
}
