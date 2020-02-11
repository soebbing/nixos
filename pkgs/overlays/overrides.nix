self: super: {
  php74 = super.php74.overrideAttrs (oldAttr: {
    buildInputs = oldAttr.buildInputs ++ [ super.libffi ];
    configureFlags = oldAttr.configureFlags ++ [ "--with-ffi" ];

    src = super.fetchurl {
      url = "https://www.php.net/distributions/php-7.4.2.tar.bz2";
      sha256 = "05p8z0ld058yjanxaphy3ka20hn7x7d6nak5sm782w4wprs9k402";
    };
  });
}
