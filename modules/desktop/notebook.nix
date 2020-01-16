{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

#  hardware = { 
#    bumblebee = { 
#      enable = true;
#      connectDisplay = true;
#      driver = "nouveau";
#    };
#  };
  services = {
    xserver = {
      enable = true;

      videoDrivers = [ "intel" "vesa" ];

      libinput = {
        enable = true;
        tapping = true;
        disableWhileTyping = true;
        scrollMethod = "twofinger";
        naturalScrolling = false;
      };
    };
  };


  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome3.chrome-gnome-shell.enable = true;
}
