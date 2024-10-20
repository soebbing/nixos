{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "intel" "vesa" ]; # "displaylink"

      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "true"
      '';
    };
    
    libinput = {
      enable = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
      touchpad.disableWhileTyping = true;
      touchpad.scrollMethod = "twofinger";
      touchpad.naturalScrolling = false;
    };
  };

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
}
