{ stdenv, lib, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "frp";
  version = "0.29.0";

  src = fetchurl {
    url =
      "https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz";
    sha256 = "1fqyl6l8z4miwv0gki54pfsgx33ajbmsrawrsdh5dsxxhsh8gavr";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/frp/bin
    cp frpc frps $out/share/frp/bin
    makeWrapper $out/share/frp/bin/frpc $out/bin/frpc
    makeWrapper $out/share/frp/bin/frps $out/bin/frps
  '';

  meta = {
    homepage = "https://github.com/fatedier/frp";
    description =
      "A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.";
    maintainers = with lib.maintainers; [ shyim ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
