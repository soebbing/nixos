self: super: {
  php74 = super.php74.overrideAttrs (oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ super.libffi ];
    configureFlags = oldAttr.configureFlags ++ [ "--with-ffi" ];

    src = super.fetchurl {
      url = "https://www.php.net/distributions/php-7.4.4.tar.bz2";
      sha256 =
        "308e8f4182ec8a2767b0b1b8e1e7c69fb149b37cfb98ee4a37475e082fa9829f";
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
    version = "2019.3.4";

    src = super.fetchurl rec {
      url = "https://download.jetbrains.com/webide/PhpStorm-2020.1.tar.gz";
      sha256 =
        "48620424341008bad90d6ee877553665bd689fceaddd69059f0400b3a5a478fb";
    };
  });
}
