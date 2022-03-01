
" General configuration

syntax on
set noerrorbells
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undordir
set undofile
set incsearch
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=black

" Nvim plugins

call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'    | Plug 'preservim/nerdtree'
Plug 'leafgarland/typescript-vim'  | Plug 'vim-utils/vim-man'
Plug 'vim-airline/vim-airline'     | Plug 'jiangmiao/auto-pairs'        | Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sbdchd/neoformat'            | Plug 'davidhalter/jedi-vim'
Plug 'machakann/vim-highlightedyank' | Plug 'tmhedberg/SimpylFold'
Plug 'terryma/vim-multiple-cursors'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

call plug#end()

" Appearance"

colorscheme nord
set background=dark

" Keybindings

nnoremap <C-Y> :NERDTree<CR>

" Autostart

let g:deoplete#enable_at_startup = 1
let g:jedi#completions_enabled = 0
let g:jedi#use_splits_not_buffers = "right"
