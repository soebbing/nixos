self: super: {
  php74 = super.php74.overrideAttrs (oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ super.libffi ];
    configureFlags = oldAttr.configureFlags ++ [ "--with-ffi" ];

    src = super.fetchurl {
      url = "https://www.php.net/distributions/php-7.4.5.tar.bz2";
      sha256 =
        "39daa533d5b63c3394da711dc12867dd76c2ec31c940bbba16f14e577df13d6f";
    };
  });

  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttr: {
    version = "3.1.101";
    netCoreVersion = "3.1.1";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/f65a8eb0-4537-4e69-8ff3-1a80a80d9341/cc0ca9ff8b9634f3d9780ec5915c1c66/dotnet-sdk-3.1.201-linux-x64.tar.gz";
      sha512 =
        "934bf29734776331691a4724f2174c4e9d2d1dde160f18397fd01abf0f96f2ec1bdd2874db9f0e25dce6993d527ea9c19031a0e67383fd813dcfcb9552ea0c70";
    };
  });

  phpstorm = super.jetbrains.phpstorm.overrideAttrs (old: rec {
    name = "phpstorm";
    version = "2020.1.0";

    src = super.fetchurl rec {
      url = "https://download-cf.jetbrains.com/webide/PhpStorm-2020.1.1.tar.gz";
      sha256 =
        "bce141cccd847d2d6cf030ba82f65b842fb0a717ab034f2fc49fa5f6d9a2ec99";
    };
  });
}
