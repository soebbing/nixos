{ config, lib, pkgs, ... }:

{
  services.xserver.layout = "us";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    keyMap = "us";
    font = lib.mkForce "Fire Code";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
}

