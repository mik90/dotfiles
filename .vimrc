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

<<<<<<< HEAD
Plugin 'vim-scripts/cup.vim'

=======
>>>>>>> da72bcc68dc04fb3e2a48daa52cca4d34dc23df8
" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on    " required
syntax on

set guifont=Tlwg\ Typist\ Medium\ 12
set mousemodel=popup
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set ruler
set cursorline 
highlight CursorLine cterm=none ctermbg=235

" Source a global configuration file if available
if filereadable("/etc/vim/gvimrc.local")
  source /etc/vim/gvimrc.local
endif

augroup filetype                                                     
<<<<<<< HEAD
	au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex         
augroup END                                                          
au Syntax jflex    so ~/.vim/syntax/jflex.vim

augroup filetype                                                     
	au BufRead,BufNewFile *.cup    set filetype=cup         
augroup END                                                          
au Syntax cup    so ~/.vim/syntax/cup.vim
=======
   au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex         
 augroup END                                                          
 au Syntax jflex    so ~/.vim/syntax/jflex.vim
>>>>>>> da72bcc68dc04fb3e2a48daa52cca4d34dc23df8
