{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #hardware = { bumblebee = { enable = true; }; };
  services = {
    xserver = {
      libinput = {
        enable = true;
        naturalScrolling = false;
      };
    };
  };


  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}
