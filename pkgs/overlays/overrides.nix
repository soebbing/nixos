self: super: {
  phpstorm = super.jetbrains.phpstorm.overrideAttrs (old: rec {
    name = "phpstorm";
    version = "2019.3-193.3793.21";
    src = super.fetchurl rec {
      url =
        "https://download-cf.jetbrains.com/webide/PhpStorm-193.3793.21.tar.gz";
      sha256 = "0rfdw89ar6z1nza9f2kw6lj4krdwhwwscka1nqan1m04z2sjkhqq";
    };
  });
  mysql80 = super.mysql80.overrideAttrs (old: rec { version = "8.0.17"; });
  neovim = super.neovim.override {
    configure = {
      customRC = ''
        set encoding=utf-8
        set tabstop=4
        set shiftwidth=4
        set autoindent

        set backupdir=~/.cache
        set directory=~/.cache
              '';
      packages.myVimPackage = with super.vimPlugins; {
        start = [ vim-nix syntastic nerdtree ];
        opt = [ ];
      };
    };
  };
}
