filetype indent plugin on
syntax on
set nobackup
set fileencoding=utf8
set encoding=utf-8
set number relativenumber
set backspace=indent,eol,start
set nocompatible
set hidden
set wildmenu
set showcmd
set ignorecase
set smartcase
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set cmdheight=2
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F12>
set background=dark
set textwidth=80
set lazyredraw

set undofile
set undodir=~/.vim/undo
set undolevels=500
set undoreload=10000

set shiftwidth=4
set softtabstop=4
set expandtab

set incsearch
set nohlsearch

set conceallevel=0
set colorcolumn=81

" set exrc
" set secure

" En tty tiene como alternativa slate o blue
colorscheme industry

if (has("termguicolors"))
    set termguicolors
    colorscheme desert
endif

let maplocalleader = "\-"
let mapleader = "\<Space>"

vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <leader>vrc :e ~/.vim/minirc.vim<CR>
nnoremap <C-l> zz
inoremap <C-l> <C-o>zz
vnoremap <C-l> zz

noremap <C-j> <Esc>/<++><CR><Esc>"_cf>

nnoremap <leader>bd :bd<CR>
nnoremap <leader><tab> :bn<CR>
nnoremap <leader>hs :set hlsearch!<CR>
inoremap <c-k> <Esc>gqgqA
nnoremap <c-k> gqgqA

nnoremap <leader>tn :tabnew 
nnoremap <leader>tl :tabn<CR>
nnoremap <leader>th :tabp<CR>
nnoremap <leader>te :tabnew<CR>:term<CR><c-w>j:resize 1<CR><c-w>k

" Spell
" zg: Añade palabras al diccionario
" zwu: Remueve palabras del diccionario
nnoremap <leader>se :setlocal spell spelllang=es_es<CR>
nnoremap <leader>si :setlocal spell spelllang=en_us<CR>
nnoremap <leader>so :setlocal spell!<CR>
nnoremap <leader>sr z=
nnoremap <leader>sn ]s
nnoremap <leader>sd ]sz=1

inoremap fd <Esc>
vnoremap fd <Esc>

nnoremap <leader>cs :tabnew<CR>:term curl cht.sh/

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
nnoremap <leader>ee :Vexplore<CR>

function! MarkdownMaps()
    "Creacion de Headers
    nnoremap <localleader>nc :set conceallevel=0<CR>
    nnoremap <leader>mh1 "zY"zpVr=
    nnoremap <leader>mh2 "zY"zpVr-
    inoremap <localleader>1 <Esc>"zY"zpVr=o<C-j>
    inoremap <localleader>2 <Esc>"zY"zpVr-o<C-j>

    " Para crear una archivo de un link
    nnoremap <localleader>cf "zyi(:e %:h/<c-r>z<cr>
    " Para ir al archivo que esta debajo del cursor usa gF

    " Items de listas
    inoremap <localleader>li <Esc>"zyy"zp<c-a>f.ll"_C
    nnoremap <localleader>li "zyy"zp<c-a>f.ll"_C
    inoremap <localleader>ui <c-j>*<Space>
    nnoremap <localleader>ui o*<Space>
    inoremap <localleader>cs <Esc>gqgqI> <Esc>A
    nnoremap <C-.> vipJ$dT.xgqgq<Space>
endfunction
autocmd BufRead,BufNewFile *.md call MarkdownMaps()
command MarkMode call MarkdownMaps()
