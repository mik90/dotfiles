
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set ruler
set number
set relativenumber
set noexpandtab
set nohlsearch

highlight CursorLine cterm=none ctermbg=235
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled=1

autocmd filetype makefile setlocal noexpandtab 
autocmd filetype python setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4
autocmd filetype java setlocal expandtab 
autocmd filetype cpp setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4 
autocmd filetype markdown setlocal expandtab 
autocmd filetype sh setlocal expandtab 
autocmd filetype cmake setlocal expandtab 