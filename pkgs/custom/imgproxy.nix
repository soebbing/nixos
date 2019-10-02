{ lib, vips, glib, nixpkgs ? import <nixpkgs> { }, stdenv ? nixpkgs.stdenv
, fetchurl ? nixpkgs.fetchurl }:

stdenv.mkDerivation rec {
  name = "imgproxy";
  version = "2018-08-13.1";

  src = fetchurl {
    url = "https://files.shyim.de/imgproxy.tar";
    sha256 = "0c598a0q5a2qswq60p267x83ivpjxq9zczcgs76d3rq0c171wj66";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r imgproxy $out/bin
  '';

  preFixup = let libPath = lib.makeLibraryPath [ vips glib ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/imgproxy
  '';
}
