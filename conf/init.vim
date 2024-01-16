" Load/initialize plugins
call plug#begin()

Plug 'itchyny/lightline.vim'

call plug#end()

set relativenumber " Relative line numbers
set number " Also show current absolute line

" Yank into system clipboard
set clipboard+=unnamedplus
