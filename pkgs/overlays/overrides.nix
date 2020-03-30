self: super: {
  php74 = super.php74.overrideAttrs (oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ super.libffi ];
    configureFlags = oldAttr.configureFlags ++ [ "--with-ffi" ];

    src = super.fetchurl {
      url = "https://www.php.net/distributions/php-7.4.3.tar.bz2";
      sha256 =
        "c1517ba49578fb2dcc64c73a3edc76d4fc507c4a7ac639981584cc7d3b4c6d14";
    };
  });

  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttr: {
    version = "3.1.101";
    netCoreVersion = "3.1.1";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/c4b503d6-2f41-4908-b634-270a0a1dcfca/c5a20e42868a48a2cd1ae27cf038044c/dotnet-sdk-3.1.101-linux-x64.tar.gz";
      sha512 =
        "eeee75323be762c329176d5856ec2ecfd16f06607965614df006730ed648a5b5d12ac7fd1942fe37cfc97e3013e796ef278e7c7bc4f32b8680585c4884a8a6a1";
    };
  });

  phpstorm = super.jetbrains.phpstorm.overrideAttrs (old: rec {
    name = "phpstorm";
    version = "2019.3.4";

    src = super.fetchurl rec {
      url = "https://download.jetbrains.com/webide/PhpStorm-2019.3.4.tar.gz";
      sha256 =
        "b564c25855f96a0d9eab715ae464472365e231bda591b52be988dfbe4d14b1af";
    };
  });
}
