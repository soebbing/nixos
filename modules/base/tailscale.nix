{ config, pkgs, lib, ... }:

let
  cfg = config.hendrik.tailscale;
in
{
  options.hendrik.tailscale = {
    enable = lib.mkEnableOption "the Tailscale client";

    operator = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "hendrik";
      description = ''
        User allowed to drive `tailscale` without `sudo`. Set to null on hosts
        that have no interactive user.
      '';
    };

    useRoutingFeatures = lib.mkOption {
      type = lib.types.enum [ "none" "client" "server" "both" ];
      default = "client";
      description = ''
        "client" for consuming exit nodes or subnet routes, "server" for
        advertising routes or acting as an exit node.
      '';
    };

    acceptDns = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Accept MagicDNS. Only applied by `tailscaled-autoconnect`, i.e. when
        {option}`hendrik.tailscale.authKeyFile` is set; after an interactive
        login apply it once with `sudo tailscale set --accept-dns`.
      '';
    };

    ssh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Tailscale SSH. Needs an `ssh` grant in the tailnet ACLs, else
        every login is denied.
      '';
    };

    exitNode = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Tailnet peer to route through, e.g. \"vps-fra\".";
    };

    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file holding a Tailscale auth key. When set, upstream
        authenticates automatically; leave null to log in interactively once
        per host.

        Must be readable by root at boot and must not point into the Nix
        store, e.g. `/run/secrets/tailscale-authkey` via sops-nix or agenix.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      inherit (cfg) useRoutingFeatures authKeyFile;

      # Without this the node falls back to a DERP relay behind NAT.
      openFirewall = true;

      # Only applied by tailscaled-autoconnect, i.e. when authKeyFile is set.
      extraUpFlags =
        [ "--accept-dns=${lib.boolToString cfg.acceptDns}" ]
        ++ lib.optional cfg.ssh "--ssh"
        ++ lib.optional (cfg.exitNode != null) "--exit-node=${cfg.exitNode}";

      # Applied by tailscaled-set on every daemon start.
      extraSetFlags =
        lib.optional (cfg.operator != null) "--operator=${cfg.operator}"
        ++ lib.optional (cfg.exitNode != null) "--exit-node=${cfg.exitNode}";
    };
  };
}
