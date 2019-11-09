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
}
