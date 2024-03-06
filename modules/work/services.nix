{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = [
	pkgs.splix
	pkgs.samsungUnifiedLinuxDriver
	pkgs.samsung-unified-linux-driver
 ];
}
