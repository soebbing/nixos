{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    python3
    dotnet3-sdk
    adoptopenjdk-bin
    awscli
    s3cmd
    openvpn
    ansible
    linphone

    unstable.docker
    unstable.docker-compose
    unstable.docker-sync
    unstable.kubectl
    unstable.dive
    unstable.virtualboxWithExtpack
    unstable.vagrant

    phpstorm
    unstable.jetbrains.rider
    unstable.postman
  ];
}
