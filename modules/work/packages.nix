{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
    s3cmd
    openvpn
    ansible
    go-jira
    go-github-to-jira
    php73Packages.phpstan
  ];
}
