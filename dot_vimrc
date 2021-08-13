" ${HOME}/.vimrc
" -*- coding: utf-8 -*-

" Disable Python 3 deprication warnings
if has('python3')
    silent! python3 1
endif

" Enable all Vim-specific features
set nocompatible

" Black Python code formatter
if filereadable(glob("~/.local/pipx/venvs/black/pyvenv.cfg"))
    let g:black_virtualenv="~/.local/pipx/venvs/black"
endif

" vim-plug
if filereadable(glob("~/.vim/config/vim-plug.vim"))
    source ~/.vim/config/vim-plug.vim
endif

if has("autocmd")
    filetype plugin indent on
endif

" Enable syntax highlighting
if has("syntax")
    syntax enable
endif

" Enable access to the macOS clipboard
if has("macunix")
    set clipboard=unnamed
endif

"  Save files in UTF-8
set encoding=utf-8
set fileencoding=utf8

" Remember marks/undo for unsaved buffers
set hidden

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set default tab stop
set tabstop=4

" Spaces inserted for indentation
set shiftwidth=4

" Expand tabs as spaces
set expandtab

" Set soft tabstop
set softtabstop=4

" Activate TAB auto-completion for file paths
set wildmode=list:longest,full

" Improve statusline tab completion
set wildmenu

" Keep 1024 lines of command line history
set history=1024

" Show the cursor position at all times
set ruler

" Display incomplete commands
set showcmd

" Make search wrap around the file
set wrapscan

" Colorscheme
set background=light
let g:solarized_termtrans=1
let g:solarized_termcolors=256
silent! colorscheme solarized

" Highlight current line
set cursorline
highlight CursorLine cterm=NONE ctermbg=187

" Search case sensitive only if contains upper-case
set ignorecase smartcase

" Make the comma the leader key
let mapleader=","

" Informative statusline
set laststatus=2
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ }

" Enable mouse in terminal mode
if has('mouse')
    set mouse=a
endif

" Enable autoindent
set autoindent

" Line numbering
set number
set relativenumber

" Better line wrapping
if has("linebreak") && exists("&breakindent")
    set linebreak
    set breakindent
    set showbreak=\ \ \ \
endif

" Split defaults and navigation
set splitbelow
set splitright
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Set default line ending warning columns
set colorcolumn=79,99
highlight ColorColumn cterm=NONE ctermbg=187
