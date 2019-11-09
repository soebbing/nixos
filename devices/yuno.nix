let
  shyim-no-pkgs = import (builtins.fetchTarball
    "https://github.com/shyim/nix-packages/archive/master.tar.gz") { };
  frpToken = builtins.getEnv "FRP_TOKEN";
  frpPassword = builtins.getEnv "FRP_PASSWORD";
in {
  yuno = { config, lib, pkgs, ... }: {
    imports = [
      ../hardware-scans/yuno.nix
      ../modules/base
      ../modules/server
      shyim-no-pkgs.modules.frp
    ];

    deployment.targetHost = "116.203.231.139";

    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "/dev/sda";

    networking.hostName = "yuno.shyim.de";
    networking.interfaces.ens3.ipv6.addresses = [ { address = "2a01:4f8:c2c:d1ea::1"; prefixLength = 64; } ];
    networking.defaultGateway6 = { address = "fe80::1"; interface = "ens3"; };
    i18n.consoleKeyMap = "de";
    services.xserver.layout = "de";

    environment.systemPackages = with pkgs; [ lego ];

    services.frp.enable = true;
    services.frp.config = {
      common = {
        "bind_addr" = "0.0.0.0";
        "bind_port" = "21";
        "vhost_http_port" = "180";
        "vhost_https_port" = "1443";
        "dashboard_addr" = "0.0.0.0";
        "dashboard_port" = "7500";
        "dashboard_user" = "admin";
        "dashboard_pwd" = frpPassword;
        "token" = frpToken;
        "subdomain_host" = "shy.ovh";
      };
    };

    networking.firewall.enable = false;

    services.nginx = {
      enable = true;
      sslProtocols = "SSLv2 SSLv3 TLSv1 TLSv1.1 TLSv1.2 TLSv1.3";
      sslCiphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA";
      recommendedGzipSettings = false;
      recommendedOptimisation = false;
      recommendedProxySettings = false;
      recommendedTlsSettings = false;

      virtualHosts."*.shy.ovh" = {
        forceSSL = true;
        sslCertificate = "/root/.lego/certificates/_.shy.ovh.crt";
        sslCertificateKey = "/root/.lego/certificates/_.shy.ovh.key";
        locations = { "/" = { proxyPass = "http://127.0.0.1:180"; }; };
      };

      virtualHosts."frp.shy.ovh" = {
        forceSSL = true;
        sslCertificate = "/root/.lego/certificates/_.shy.ovh.crt";
        sslCertificateKey = "/root/.lego/certificates/_.shy.ovh.key";
        locations = { "/" = { proxyPass = "http://127.0.0.1:7500"; }; };
      };
    };
  };
}
