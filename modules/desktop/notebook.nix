{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;

      videoDrivers = [ "modesetting" "intel" "vesa" ];

      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "true"
      '';

      libinput = {
        enable = true;
        middleEmulation = true;
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
