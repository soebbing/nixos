{ config, pkgs, ... }:

{
  services.xserver.layout = "de";

  i18n = { defaultLocale = "de_DE.UTF-8"; };

  console = {
    keyMap = "de";
    font = "Lat2-Terminus16";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
}

