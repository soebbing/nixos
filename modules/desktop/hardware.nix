{ config, pkgs, lib, ... }:

{
  sound.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };

    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
      support32Bit = true;
    };
  };
  services.blueman.enable = true;

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

 systemd.services.keychron = {
   enable = false;
   description = "Set Function keys by default instead of multimedia keys";
    unitConfig = {
      Type = "simple";
    };
   serviceConfig = {
     Type = "oneshot";
     ExecStart = "/bin/bash -c \"test -e /sys/module/hid_apple/parameters/fnmode && echo 0 > /sys/module/hid_apple/parameters/fnmode\"";
   };
   wantedBy = [ "multi-user.target" ];
 };

 systemd.services.ipfs-daemon.enable = true;
}
