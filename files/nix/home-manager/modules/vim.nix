{ pkgs, ... }:
{
  home.packages = [ pkgs.vim ];

  xdg.configFile."config/vimrc" = {
    text = ''
      scriptencoding utf-8
      set encoding=utf-8

      " XDG support
      set runtimepath^=$XDG_CONFIG_HOME/vim
      set runtimepath+=$XDG_DATA_HOME/vim
      set runtimepath+=$XDG_CONFIG_HOME/vim/after

      set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
      set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

      let g:netrw_home = $XDG_DATA_HOME."/vim"
      call mkdir($XDG_DATA_HOME."/vim/spell", 'p')

      set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
      set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
      set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p')
      set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p')

      if !has('nvim') | set viminfofile=$XDG_STATE_HOME/vim/viminfo | endif

      " setting
      set fenc=utf-8
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
