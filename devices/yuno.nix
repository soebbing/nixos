let
  cloudflareConfig = ''
    allow 173.245.48.0/20;
    allow 103.21.244.0/22;
    allow 103.22.200.0/22;
    allow 103.31.4.0/22;
    allow 141.101.64.0/18;
    allow 108.162.192.0/18;
    allow 190.93.240.0/20;
    allow 188.114.96.0/20;
    allow 197.234.240.0/22;
    allow 198.41.128.0/17;
    allow 162.158.0.0/15;
    allow 104.16.0.0/12;
    allow 172.64.0.0/13;
    allow 131.0.72.0/22;

    # IPv6
    allow 2400:cb00::/32;
    allow 2606:4700::/32;
    allow 2803:f800::/32;
    allow 2405:b500::/32;
    allow 2405:8100::/32;
    allow 2a06:98c0::/29;
    allow 2c0f:f248::/32;

    deny all;
      '';
  streamDomain = builtins.getEnv "STREAM_DOMAIN";
in {
  yuno = { config, lib, pkgs, ... }: {
    imports = [ ../hardware-scans/yuno.nix ../modules/base ../modules/server ];

    deployment.targetHost = "116.203.231.139";

    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "/dev/sda";

    networking.hostName = "yuno.shyim.de";
    i18n.consoleKeyMap = "de";
    services.xserver.layout = "de";

    environment.systemPackages = with pkgs; [ nodejs-12_x frp lego ];

    systemd.services.nut = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      description = "Start the nut server";
      serviceConfig = {
        WorkingDirectory = "/home/nut";
        User = "root";
        ExecStart = "${pkgs.nodejs-12_x}/bin/node index.js";
      };
    };

    systemd.services.frp = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.frp}/bin/frps --config /etc/frp/frps.ini";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 21 25 143 6697 ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = false;
      recommendedOptimisation = false;
      recommendedProxySettings = false;
      recommendedTlsSettings = false;

      virtualHosts."nut.shyim.de" = {
        locations = { "/" = { proxyPass = "http://127.0.0.1:3125"; }; };
      };

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
