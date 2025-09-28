{
  config,
  pkgs,
  lib,
  ...
}:

{
  hardware = {
    graphics.enable = true;

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
  services.blueman.enable = true;

  # Systemd stop job timeout.
  # Increase max file descriptors to 1M,
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 1048576;
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";
    }
  ];

  systemd.services.ipfs-daemon.enable = true;
}
