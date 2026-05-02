" -------------------------
" General settings
" -------------------------
set nocompatible
set number
set relativenumber
set laststatus=2
set wrap

" -------------------------
" Indentation
" -------------------------
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent

" -------------------------
" UI / Editing
" -------------------------
set scrolloff=8
set signcolumn=yes
set colorcolumn=80

" Better usability
set mouse=a
set clipboard=unnamedplus
set cursorline

" -------------------------
" File handling
" -------------------------
set isfname+=@-@

" -------------------------
" Performance / behavior
" -------------------------
set hidden
set updatetime=300
set timeoutlen=500

" -------------------------
" Search
" -------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch

" -------------------------
" Plugin loader
" -------------------------
if filereadable(expand("~/.vimrc.plug"))
  source ~/.vimrc.plug
endif
