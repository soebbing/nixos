{ config, pkgs, ... }:

{
  services = { printing = { enable = true; }; };

  services.davmail.enable = true;
  services.davmail.url = "https://owa.shopware.com/EWS/Exchange.asmx";
  services.davmail.config.davmail.mode = "EWS";
}
