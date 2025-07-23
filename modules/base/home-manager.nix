{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.hendrik = { config, pkgs, ... }: {
    home.stateVersion = "25.05"; # match your current NixOS version

    programs.fish.enable = true;

    home.packages = with pkgs; [
      htop
      neovim
      firefox
    ];
  };
}