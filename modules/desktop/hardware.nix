{ config, pkgs, lib, ... }:

{
  sound.enable = true;
  hardware = {
    opengl.driSupport32Bit = true;
    bluetooth = {
      enable = true;
      config = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      enable = true;
      support32Bit = true;
    };
  };

  # Systemd stop job timeout.
  # Increase max file descriptors to 1M,
  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];
}
