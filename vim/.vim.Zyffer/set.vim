set termguicolors
set background=dark
colorscheme catppuccin_mocha

augroup vim_cursor_block
  autocmd!
  autocmd VimEnter * silent !printf '\033[2 q'
  autocmd InsertEnter * silent !printf '\033[2 q'
  autocmd InsertLeave * silent !printf '\033[2 q'
  autocmd VimLeave * silent !printf '\033[2 q'
augroup END

set number
set relativenumber
set mouse=

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent

set scrolloff=8
set signcolumn=no
set isfname+=@-@
set colorcolumn=80
