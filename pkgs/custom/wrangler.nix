{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, zlib, openssl }:

with rustPlatform;

buildRustPackage rec {
  pname = "wrangler";
  version = "1.4.0";

  cargoSha256 = "0c2g6yghwqjy21yfdcri4v9aqizd06ww3zx2snns51gnqqk8r57k";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "1agl1cg34iklvniygrkq8dqsampvg17d3nsm0dcr6c3n5rj09gbi";
  };

  nativeBuildInputs = [ cmake pkgconfig openssl.dev ];
  buildInputs = [ zlib ];

  outputs = [ "out" ];

  # Tests trying to create an folder which fails in /nix/store
  doCheck = false;

  meta = with stdenv.lib; {
    description = "wrangle your cloudflare workers";
    longDescription = ''
      wrangler is a CLI tool designed for folks who are interested in using Cloudflare Workers.
    '';
    homepage = "https://github.com/cloudflare/wrangler";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
