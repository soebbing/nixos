{ config, pkgs, ... }:

{
  services = {
    libinput = {
      enable = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
      touchpad.disableWhileTyping = true;
      touchpad.scrollMethod = "twofinger";
      touchpad.naturalScrolling = true;
      mouse.naturalScrolling = true;
    };
  };

  # Necessary for Gnome Shell integration
  nixpkgs.config.firefox.enableGnomeExtensions = true;
}
