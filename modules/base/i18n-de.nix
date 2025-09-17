{ config, pkgs, ... }:

{
  services.xserver.xkb.layout = "de";

  i18n = {
    defaultLocale = "en_IE.UTF-8";
  };

  console = {
    keyMap = "de";
    font = "Lat2-Terminus16";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
}
