{
  config,
  lib,
  pkgs,
  flake,
  environment,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  documentation.enable = false;
  documentation.man.enable = false;

  system.stateVersion = 5;
  system.primaryUser = "hendrik";

  system.defaults.dock.autohide = true;
  system.defaults.dock.magnification = false;
  system.defaults.dock.orientation = "left";

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  ids.gids.nixbld = 30000;

  security.pam.services.sudo_local.touchIdAuth = true;
  environment.etc."hosts".text = ''
    ##
    # Host Database
    ##
    127.0.0.1 localhost motorsport.de motorsport.test www.idontknow.gov myforsaledomain.de motorsport.example www.download-handbuch.example www.manuals-online.example www.canastapp.example
    255.255.255.255 broadcasthost
    fe80::1%lo0 localhost
    ::1 localhost
    192.168.1.2 rackspace
    192.168.1.2 flightradar
    192.168.1.4 homeassistant
    192.168.1.9 octoprint
    192.168.1.27 printserver
  '';

  networking = {
    knownNetworkServices = [
      "VPN"
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];

    dns = [
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
  };

  users.users = {
    hendrik = {
      name = "hendrik";
      home = "/Users/hendrik";
    };
  };

  # Will be overriden by home-managers version
  #environment.loginShellInit = "fish_add_path --move --prepend $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

  nix = {
    enable = true;
    extraOptions = ''
        experimental-features = nix-command flakes auto-allocate-uids #repl-flake
        auto-allocate-uids = true
      #  builders-use-substitutes = true
      #  builders = @/etc/nix/machines
        log-lines = 100
        nix-path = nixpkgs=${flake.inputs.nixpkgs}
        extra-platforms = x86_64-darwin aarch64-darwin
    '';

    settings.trusted-users = [
      "root"
      "hendrik"
    ];
  };

  environment.systemPackages = [
    (pkgs.php.buildEnv {
      extensions = (
        { enabled, all }:
        enabled
        ++ (with all; [
          xdebug
        ])
      );
      extraConfig = ''
        xdebug.mode=debug
      '';
    })
  ];
}
