set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'

Plugin 'vim-airline/vim-airline'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'flazz/vim-colorschemes'

Plugin 'vim-syntastic/syntastic'

Plugin 'rakr/vim-one'

Plugin 'severin-lemaignan/vim-minimap'

" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on    " required


colorscheme molokai
let g:airline_theme='molokai'

set guifont=Tlwg\ Typist\ Medium\ 12
set mousemodel=popup
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set ruler
syntax on

" Source a global configuration file if available
if filereadable("/etc/vim/gvimrc.local")
  source /etc/vim/gvimrc.local
endif
