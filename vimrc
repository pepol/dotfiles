" Section: General Settings {{{

set nocompatible
set nowrap
set nohlsearch
set backspace=indent,eol,start
set nobackup
set showmatch
syntax on
set ruler
set showcmd
set modelines=1
set ff=unix
set ffs=unix,dos
set sw=2 sts=2 ts=2 et
set bg=dark
set encoding=utf-8

set colorcolumn=80

set updatetime=100

" }}}

" Section: Autocmd {{{

if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" |
    \ endif
  augroup END
  au BufRead,BufNewFile *.go set filetype=go
  autocmd FileType python set sw=4 sts=4 ts=4 et
  autocmd FileType go set sw=8 sts=8 ts=8 noet
  autocmd FileType yaml set sw=2 sts=2 ts=2 et
else
  set autoindent
endif

" }}}

" Section: Folding {{{

set foldenable
set foldlevelstart=99
set foldnestmax=10

set foldmethod=indent

" }}}

" Section: Shortcuts {{{

let mapleader = ","
let maplocalleader = "\\"

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Normal Mode
nmap <leader>n :set invnumber<CR>
nnoremap <space> za
nmap <leader>T :enew<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" Insert Mode
inoremap jj <esc>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" Visual Mode

" }}}
" vim:foldmethod=marker:foldlevel=0
