" vim-plug configuration
"-*- coding: utf-8 -*-
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'ajh17/VimCompletesMe'
Plug 'alker0/chezmoi.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'itchyny/lightline.vim'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'kh3phr3n/python-syntax'
Plug 'liuchengxu/vista.vim'
Plug 'nvie/vim-flake8'
Plug 'plytophogy/vim-virtualenv'
Plug 'psf/black'
Plug 'rakr/vim-one'
Plug 'tpope/vim-commentary'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'w0rp/ale'

call plug#end()
