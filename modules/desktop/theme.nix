{ config, lib, pkgs, ... }:
let
  gtk2rc = pkgs.writeText "gtk2rc" ''
    gtk-icon-theme-name = "${icon-theme.name}"
    gtk-theme-name = "${theme.name}"
  '';
  theme = {
    package = pkgs.theme-vertex;
    name = "Vertex-Dark";
  };
  icon-theme = {
    package = pkgs.numix-icon-theme;
    name = "Numix";
  };
in {

  # I have no idea what is actually needed here, this was just me trying
  # a bunch of different things
  environment.variables = {
    GDK_PIXBUF_MODULE_FILE =
      "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    GTK2_RC_FILES =
      "${gtk2rc}:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
    GTK_DATA_PREFIX = "${theme.package}";
    GTK_EXEC_PREFIX = "${theme.package}";
    GTK_IM_MODULE = "xim";
    GTK_PATH = "${theme.package}:${pkgs.gtk3.out}";
    GTK_THEME = "${theme.name}";
    LC_TIME = "en_DK.UTF-8";
    QT_STYLE_OVERRIDE = "GTK+";
  };

  environment.systemPackages = with pkgs; [
    gtk-engine-murrine
    theme.package
    icon-theme.package
  ];
}
