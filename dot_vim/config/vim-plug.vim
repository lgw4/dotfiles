" vim-plug configuration
"-*- coding: utf-8 -*-
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'ajh17/VimCompletesMe'
Plug 'altercation/vim-colors-solarized'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'itchyny/lightline.vim'
Plug 'kh3phr3n/python-syntax'
Plug 'nvie/vim-flake8'
Plug 'plytophogy/vim-virtualenv'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-scripts/indentpython.vim'
Plug 'w0rp/ale'

call plug#end()
