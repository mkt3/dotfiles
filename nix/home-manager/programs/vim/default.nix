{ pkgs, ... }:
{
  home.packages = [ pkgs.vim ];

  xdg.configFile."vim/vimrc" = {
    text = ''
      scriptencoding utf-8
      set encoding=utf-8

      " setting
      set fenc=utf-8
      set viminfo=
      set nobackup
      set noswapfile
      set autoread
      set hidden
      set showcmd
      set backspace=indent,eol,start
      set display=lastline
      set pumheight=10

      syntax enable
      set background=dark
      set number
      set cursorline
      "set cursorcolumn
      set virtualedit=onemore
      set smartindent
      set visualbell
      set showmatch
      set laststatus=2
      set wildmode=list:longest
      nnoremap j gj
      nnoremap k gk
      inoremap <silent> jj <ESC>
      inoremap <silent> <C-g> <ESC>

      set list listchars=tab:\▸\-
      set expandtab
      set tabstop=4
      set shiftwidth=4

      set ignorecase
      set smartcase
      set incsearch
      set wrapscan
      set hlsearch
      nmap <Esc><Esc> :nohlsearch<CR><Esc>

      cmap w!! w !sudo tee > /dev/null %W
    '';
  };
}
