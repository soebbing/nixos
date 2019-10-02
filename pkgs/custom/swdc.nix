{ nixpkgs ? import <nixpkgs> { }, stdenv ? nixpkgs.stdenv
, fetchFromGitHub ? nixpkgs.fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shopware-docker";
  version = "2018-08-13.1";

  src = fetchFromGitHub {
    owner = "shyim";
    repo = "shopware-docker";
    rev = "bce10e0768252a662b73209ae4d3b1fccfe95c9e";
    sha256 = "1gk0g6d42rr9zcqqxq8xh33p137zkq7qmq85ylaq22ifdi1v8c9z";
  };

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r . $out/lib
    echo "#!/usr/bin/env bash" > $out/bin/swdc
    echo "bash $out/lib/swdc \"\$@\"" >> $out/bin/swdc
    chmod +x $out/bin/swdc
  '';

}
