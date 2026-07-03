" Juancho's vimrc. Plugin-free so it works on stock vim on any box.

" Leader key.
let mapleader = " "

" Line numbers.
set number
set relativenumber

" Two-space indentation.
set expandtab
set shiftwidth=2
set tabstop=2
set smartindent

" Search.
set ignorecase
set smartcase
set hlsearch
set incsearch

" Appearance.
syntax on
set background=dark
set cursorline
set scrolloff=8
set sidescrolloff=8
set laststatus=2

" Behavior.
filetype plugin indent on
set backspace=indent,eol,start
set hidden
set wildmenu
set splitright
set splitbelow
set timeoutlen=300
set ttimeoutlen=50

" Undo history survives closing the file; no swap files.
set noswapfile
set undofile
set undodir=~/.vim/undo
if !isdirectory(&undodir)
  call mkdir(&undodir, "p", 0700)
endif

" Wrapping.
set nowrap
set breakindent

" Clear search highlight; single-Esc mappings break arrow keys in terminal vim.
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Window navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File operations.
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Keep visual mode while indenting.
vnoremap < <gv
vnoremap > >gv

" Move selected lines.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep the cursor centered while moving around.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
