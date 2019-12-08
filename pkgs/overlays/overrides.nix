self: super: {
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
  vscode-ext = super.vscode-with-extensions.override {
    vscodeExtensions = super.pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      }
      {
        name = "vue-vscode-extensionpack";
        publisher = "sdras";
        version = "0.2.0";
        sha256 = "0xf6bxv922h3y1ckrn25mk6hmavr8c5xc59dprcj7q66z2j87g0s";
      }
    ];
  };
}
