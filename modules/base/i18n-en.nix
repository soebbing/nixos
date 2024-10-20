{ config, lib, pkgs, ... }:

{
  services.xserver.xkb.layout = "us";

  # English language, sensible time/date/currency formats
  i18n = { defaultLocale = "en_IE.UTF-8"; };

  console = {
    keyMap = "us";
    font = lib.mkForce "Fire Code";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
}

