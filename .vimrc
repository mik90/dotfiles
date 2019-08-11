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

Plugin 'vim-ruby/vim-ruby'

Plugin 'vim-scripts/cup.vim'

Plugin 'scrooloose/nerdtree'

Plugin 'davidhalter/jedi-vim'

Plugin 'Yggdroot/indentLine'

" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on    " required
syntax on

set guifont=Tlwg\ Typist\ Medium\ 12
set mousemodel=popup
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set ruler
set number
set relativenumber
set noexpandtab
highlight CursorLine cterm=none ctermbg=235

" Sourced from flazz/vim-colorschemes
colorscheme Dark

" Lctrl+n opens up NERD tree
map <C-n> :NERDTreeToggle<CR>

let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled=1

autocmd filetype makefile setlocal noexpandtab 
autocmd filetype python setlocal expandtab 
autocmd filetype ruby setlocal expandtab 
autocmd filetype java setlocal expandtab 
autocmd filetype cup setlocal expandtab 
autocmd filetype cpp setlocal expandtab 

" For C++17 Syntax checking
let g:syntastic_cpp_compiler_options = '-std=c++17'

" Source a global configuration file if available
if filereadable("/etc/vim/gvimrc.local")
  source /etc/vim/gvimrc.local
endif

augroup filetype                                                     
	au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex         
augroup END                                                          
au Syntax jflex    so ~/.vim/syntax/jflex.vim

augroup filetype                                                     
	au BufRead,BufNewFile *.cup    set filetype=cup         
augroup END                                                          
au Syntax cup    so ~/.vim/syntax/cup.vim
