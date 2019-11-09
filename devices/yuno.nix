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
    i18n.consoleKeyMap = "de";
    services.xserver.layout = "de";

    environment.systemPackages = with pkgs; [ shyim.frp lego ];

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
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

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
