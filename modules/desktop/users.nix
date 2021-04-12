{ config, pkgs, ... }:

{
  # Allow passwordless sudo for wheel users.
  security.sudo.wheelNeedsPassword = false;

  # User accounts.
  users.users.hendrik = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    home = "/home/hendrik";
    description = "Hendrik Soebbing";
    hashedPassword =
      "$6$rscYCrM5xadGLXMN$NrziVb4PdnkWmqGYbeOnzmQJYMfCOkLL35oQNWwPsD61GiX06dgu9K7MY4OAJo.pPyUp5aV/wBnIidbpvi48m0"; # "hendrik"
    createHome = true;
    group = "users";
    extraGroups = [
      "adbusers"
      "wheel"
      "docker"
      "video"
      "audio"
      "networkmanager"
      "systemd-journal"
      "libvirtd"
    ];
    #shell = "/run/current-system/sw/bin/fish";
  };

  nix.trustedUsers = [ "root" "hendrik" ];
}
