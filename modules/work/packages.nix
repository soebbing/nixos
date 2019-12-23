{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
    s3cmd
    openvpn
    ansible
    go-jira
    php74Packages.phpstan
    zoom-us
  ];
}
