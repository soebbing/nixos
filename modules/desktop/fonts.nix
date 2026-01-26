{ config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.droid-sans-mono
      nerd-fonts.inconsolata
      nerd-fonts.jetbrains-mono
      nerd-fonts.go-mono
      nerd-fonts.fira-mono
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.roboto-mono
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts.zed-mono
     
      monaspace
      source-code-pro
    ];
  };
}