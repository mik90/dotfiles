set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin(stdpath('data') . '/plugged')

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'scrooloose/nerdtree'

Plug 'Yggdroot/indentLine'

call plug#end()
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
set nohlsearch
highlight CursorLine cterm=none ctermbg=235

" Ctags/Ctrlp stuff
" Create mappings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Default to working directory
let g:ctrlp_working_path_mode = 'ra'

" Lctrl+n opens up NERD tree
map <C-n> :NERDTreeToggle<CR>

let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled=1

autocmd filetype makefile setlocal noexpandtab 
autocmd filetype python setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4
autocmd filetype java setlocal expandtab 
autocmd filetype cpp setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4 
autocmd filetype markdown setlocal expandtab 
autocmd filetype sh setlocal expandtab 
autocmd filetype cmake setlocal expandtab 


