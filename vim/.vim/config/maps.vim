if has('nvim')
    tnoremap <C-w>N <C-\><C-n>
    tnoremap fd <C-\><C-n>
endif

" Lideres
let maplocalleader = "\-"
let mapleader = "\<Space>"

" Mover lineas.
"nnoremap <A-j> :m .+1<CR>==
"nnoremap <A-k> :m .-2<CR>==
"inoremap <A-j> <Esc>:m .+1<CR>==gi
"inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Comodidades
" autocmd InsertEnter * norm zz
nnoremap <leader>vrc :e ~/.vim/config/vimrc.vim<CR>
nnoremap <C-l> zz
inoremap <C-l> <C-o>zz
vnoremap <C-l> zz

" Numeros relativos
nnoremap <silent> <leader>nb :set relativenumber!<CR>

" Placeholders
nnoremap <C-j> <Esc>/<++><CR><Esc>"_cf>
inoremap <C-J> <Esc>/<++><CR><Esc>"_cf>

" Shortcuts
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bt :e ~/temp.md<CR>
nnoremap <leader><tab> :bn<CR>
nnoremap <leader>Rg :%s//g<left><left>
nnoremap <leader>Rw *N:%s///g<left><left>
vnoremap <leader>R :s//g<left><left>
nnoremap <leader>hs :set hlsearch!<CR>
inoremap <c-k> <Esc>gqgqA
nnoremap <c-k> gqgqA

" Windows
nnoremap <C-w>v <C-w>v<C-w>L

" Tabs
nnoremap <leader>tn :tabnew 
nnoremap <leader>tl :tabn<CR>
nnoremap <leader>th :tabp<CR>
if has('nvim')
    nnoremap te :tabnew<CR>:term<CR>
else
    nnoremap <leader>te :tabnew<CR>:term<CR><c-w>j:resize 1<CR><c-w>k
endif

" Spell
" zg: Añade palabras al diccionario
" zwu: Remueve palabras del diccionario
nnoremap <leader>se :setlocal spell spelllang=es_es<CR>
nnoremap <leader>si :setlocal spell spelllang=en_us<CR>
nnoremap <leader>so :setlocal spell!<CR>
nnoremap <leader>sr z=
nnoremap <leader>sn ]s
nnoremap <leader>sd ]sz=1

" Para no mover la mano del teclado
inoremap fd <Esc>
vnoremap fd <Esc>

" Autocompletar ", (, {  
inoremap " ""<Esc>i
inoremap "<leader> "

inoremap ' ''<Esc>i
inoremap '<leader> '

inoremap ( ()<Esc>i
inoremap (<CR> (<CR><CR>)<Esc>k"_cc
inoremap (<leader> (

inoremap { {}<Esc>i
inoremap {<CR> {<CR><CR>}<Esc>k"_cc
inoremap {<leader> {

inoremap [ []<Esc>i
inoremap [<CR> [<CR><CR>]<Esc>k"_cc
inoremap [<leader> [

inoremap "" ""
inoremap '' ''
inoremap () ()
inoremap {} {}
inoremap [] []

" Cheatsheet
nnoremap <leader>cs :tabnew<CR>:term curl cht.sh/

" Remap rapido
" No puede tener <leader> como un literal, asi que esta es la forma que se me
" ocurrio para arreglarlo
nnoremap <leader>gg :nnoremap <leader<Space><Left>>gg<Right>

augroup Binary
  au!
  au BufReadPre   *.bin let &bin=1
  au BufReadPost  *.bin if &bin | %!xxd
  au BufReadPost  *.bin set ft=xxd | endif
  au BufWritePre  *.bin if &bin | %!xxd -r
  au BufWritePre  *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
