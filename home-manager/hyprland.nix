{ config, pkgs, lib, ... }:

# Hyprland user-side config. Loaded on every Linux host; the package is
# only installed when `hendrik.desktop == "hyprland"`, so bins referenced
# in `hl.exec_cmd` / `hl.bind` only resolve there. `default_session` is
# hard-coded to `start-hyprland` in modules/desktop/manager/greetd.nix.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {

  # Gated on osConfig.hendrik.desktop: exporting XDG_CURRENT_DESKTOP=Hyprland
  # on a GNOME host breaks gnome-control-center and other XDG-keyed tools.
  home.sessionVariables = lib.mkIf (config.osConfig.hendrik.desktop or "" == "hyprland") {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "kde";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NO_AT_BRIDGE = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # NixOS already puts the binary on PATH; don't pull a second copy.
    package = null;

    # Hyprland 0.45+ prefers `hyprland.lua` over `hyprland.conf`; 0.55+
    # made the Lua config the default. We write the Lua file directly via
    # `extraConfig` below (raw Lua source) — `settings` is awkward here
    # because it flattens every top-level attribute into a `hl.<name>(...)`
    # call, which doesn't match the `hl.config({...})` API for section
    # config or the multi-arg `hl.curve(name, {...})` form.
    configType = "lua";

    extraConfig = ''
      -- ===== Variables (Lua locals used by the binds below) =====
      local mainMod  = "SUPER"
      local terminal = "kitty"
      local menu     = "rofi -show drun"
      local browser  = "firefox"

      -- ===== Environment exported to every Hyprland child process =====
      -- Hyprland already setenvs XDG_CURRENT_DESKTOP=Hyprland and
      -- XDG_SESSION_TYPE=wayland, so those are NOT repeated here. The
      -- vars below ensure GUI apps (especially Firefox) pick Wayland
      -- even when they inherit a stale WAYLAND_DISPLAY from a
      -- non-Hyprland context.
      hl.env("MOZ_ENABLE_WAYLAND",          "1")
      hl.env("QT_QPA_PLATFORM",             "wayland;xcb")
      -- KDE-style theming so Qt apps inherit system colors/icons.
      hl.env("QT_QPA_PLATFORMTHEME",        "kde")
      hl.env("SDL_VIDEODRIVER",             "wayland")
      -- Keeps IntelliJ/Minecraft from being reparented off the
      -- Hyprland-managed surface.
      hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
      hl.env("NO_AT_BRIDGE",                "1")
      -- GDK_BACKEND intentionally unset: GTK apps should be allowed to
      -- fall back to XWayland when the toolkit can't do Wayland.

      -- ===== Section-style config (general / decoration / animations / input) =====
      hl.config({
        general = {
          gaps_in = 5,
          gaps_out = 10,
          border_size = 2,
          layout = "dwindle",
        },
        decoration = {
          rounding = 5,
          active_opacity = 1.0,
          inactive_opacity = 0.9,
          shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            -- Hyprland 0.55+ renamed `col.shadow` to `color` (the dotted
            -- name was the old Hyprlang quirk for keys colliding with
            -- reserved words — `color` is no longer reserved).
            color = "rgba(00000099)",
          },
          blur = {
            enabled = true,
            size = 3,
            passes = 1,
          },
        },
        animations = {
          enabled = true,
        },
        input = {
          kb_layout = "de",
          follow_mouse = 1,
          -- Hyprland 0.55+ moved mouse `natural_scroll` to the top-level
          -- `input.natural_scroll` (it now applies to both mouse and any
          -- touchpad that doesn't override it).
          natural_scroll = true,
          touchpad = {
            natural_scroll = true,
          },
        },
      })

      -- ===== Bezier curve + animation rules (snappy, not sluggish) =====
      -- Hyprland 0.56.2 INVERTS the documented direction for animation
      -- `speed`: LOWER values are FASTER. The wiki (and the HL meta
      -- stub) describe `higher = faster / shorter`, but in practice the
      -- opposite holds — speed = 2.625 makes the `windows` animation
      -- visibly snap faster than speed = 42. If you're looking at this
      -- after a doc-anchored drive-by edit, you've been warned.
      -- Values below are 1/4 of the originally tried 10.5 / 10.5 / 9 / 15.
      hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

      hl.animation({ leaf = "windows",    enabled = true, speed = 2.625, bezier = "myBezier" })
      hl.animation({ leaf = "fade",       enabled = true, speed = 2.625, bezier = "default" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 2.25,  bezier = "default" })
      hl.animation({ leaf = "border",     enabled = true, speed = 3.75,  bezier = "default" })

      -- ===== Key bindings =====
      -- Apps
      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(menu))
      hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
      hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("hyprlock"))

      -- Window
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

      -- Clipboard history picker (cliphist). $mod+V is taken by
      -- togglefloating, so SHIFT+V opens a rofi dmenu over the cliphist
      -- store. The pipe decodes the picked entry back to plain text and
      -- pushes it onto the Wayland clipboard via wl-copy. To wipe the
      -- history, run `cliphist wipe` from a shell.
      hl.bind(mainMod .. " + SHIFT + V",
        hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

      -- Focus
      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

      -- Move / resize
      hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

      -- Workspaces 1-5
      hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
      hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
      hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
      hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
      hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))

      hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
      hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
      hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
      hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
      hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))

      -- ===== Window rules =====
      -- Hyprland 0.53+ matcher syntax uses `match.class = "regex"` /
      -- `match.title = "regex"` inside the rule table (no more `match:class`
      -- colon-separated strings).
      hl.window_rule({ match = { class = "^pavucontrol$" },       float = true })
      hl.window_rule({ match = { class = "^blueman-manager$" },   float = true })
      hl.window_rule({ match = { title = "^Picture-in-Picture$" }, float = true })

      -- ===== Autostart =====
      -- Wrapped in `hl.on("hyprland.start", ...)` so the commands run
      -- exactly once per Hyprland start, replacing the old hyprlang
      -- `exec-once = ...` directive. Uses bare names because NixOS
      -- `programs.hyprland.enable` puts them on the user PATH.
      hl.on("hyprland.start", function ()
        hl.exec_cmd("waybar")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("mako")
        hl.exec_cmd("hyprpolkitagent")
      end)
    '';
  };

  # NOTE: home-manager writes `~/.config/hypr/hyprland.lua` for us
  # (because configType = "lua"). No `xdg.configFile` entry is needed
  # here and explicitly shipping one would override home-manager's
  # output — that's the opposite of what we want.

  # Hyprpaper picks up this file automatically when launched. Path is
  # sourced from nixpkgs so it's stable across rebuilds.
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos-simple-blue.png
    wallpaper = ,${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos-simple-blue.png
    splash = false
  '';

  # Hyprlock: blurred screenshot of the current desktop + centered time
  # / date / password field. Lockscreen-only label tags (auth_status,
  # time, etc.) are provided by hyprlock itself — no extra config needed.
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
        grace = 0
        no_input_grace = 0
        cursor_out_timeout = 5
    }

    background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 8
    }

    # Auth input — centred horizontally, just under the time label.
    input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.15
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        fail_text = <i>Auth failed</i>
        position = 0, -20
        halign = center
        valign = center
    }

    # Time — large, centred.
    label {
        monitor =
        text = $TIME
        color = rgba(255, 255, 255, 1.0)
        font_size = 96
        font_family = JetBrains Mono Nerd Font
        position = 0, 200
        halign = center
        valign = center
    }

    # Date — smaller, just above the time.
    label {
        monitor =
        text = $DATE
        color = rgba(255, 255, 255, 0.7)
        font_size = 24
        font_family = JetBrains Mono Nerd Font
        position = 0, 100
        halign = center
        valign = center
    }
  '';

  # Hypridle: 5 min idle → lock, 5.5 min → DPMS off, 30 min → suspend.
  # The lock_cmd uses `pidof hyprlock || hyprlock` so a stuck hyprlock
  # isn't replaced mid-auth; if none is running, hyprlock is started.
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 300
        on-timeout = loginctl lock-session
    }

    listener {
        timeout = 330
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

    listener {
        timeout = 1800
        on-timeout = systemctl suspend
    }
  '';

  # Waybar: replaces the stock /etc/xdg/waybar/config.jsonc's sway/*
  # modules with their hyprland/* peers, and drops modules whose
  # backends aren't actually running on this host (mpd, sway-mode,
  # sway-scratchpad, sway-language, power-profiles-daemon, the
  # custom/media python plugin, the GTK custom/power menu XML).
  #
  # Default styling from /etc/xdg/waybar/style.css is used. Add a
  # `xdg.configFile."waybar/style.css"` entry alongside this one when
  # you want to override the look (Gruvbox palette, font, paddings).
  #
  # Applet interactions worth knowing:
  #   pulseaudio → click opens pavucontrol
  #   network    → click toggles the Wi-Fi radio; scroll cycles SSIDs
  #   backlight  → scroll cycles brightness
  #   tray       → networkmanager-applet, blueman, … land here
  xdg.configFile."waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 26,
      "spacing": 4,

      "modules-left":   ["hyprland/workspaces"],
      "modules-center": ["hyprland/window"],
      "modules-right":  [
        "network",
        "pulseaudio",
        "cpu",
        "memory",
        "backlight",
        "battery",
        "clock",
        "tray"
      ],

      "hyprland/workspaces": {
        "format": "{name}",
        "format-icons": {
          "urgent":  "!",
          "focused": "[•]",
          "default": "[ ]"
        }
      },

      "hyprland/window": {
        "format": "{title}",
        "max-length": 80
      },

      "network": {
        "format-wifi":         "{essid} ({signalStrength}%)",
        "format-ethernet":     "{ipaddr}/{cidr}",
        "format-disconnected": "offline",
        "tooltip-format":      "{ifname} via {gwaddr}",
        "format-linked":       "{ifname} (no IP)"
      },

      "pulseaudio": {
        "format":       "{volume}% {icon}",
        "format-muted": "M",
        "format-icons": {
          "default": ["▁","▂","▃","▄","▅","▆","▇","█"]
        },
        "on-click": "pavucontrol"
      },

      "cpu":       { "format": "{usage}%",      "interval": 5 },
      "memory":    { "format": "{percentage}%", "interval": 5 },
      "backlight": { "format": "{percentage}%", "interval": 1 },

      "battery": {
        "format":          "{capacity}% {icon}",
        "format-charging": "▲ {capacity}%",
        "format-plugged":  "⚡ {capacity}%",
        "format-icons": {
          "charging": ["▁","▂","▃","▄","▅","▆","▇","█"],
          "default":  ["▁","▂","▃","▄","▅","▆","▇","█"]
        },
        "tooltip-format": "{time}"
      },

      "clock": {
        "format":         "{:%H:%M}",
        "tooltip-format": "{:%a %d %b %Y  %H:%M}"
      },

      "tray": { "spacing": 10 }
    }
  '';
}
