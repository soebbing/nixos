{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
    s3cmd
    openvpn
    ansible
    go-jira
    php73Packages.phpstan
  ];
}
