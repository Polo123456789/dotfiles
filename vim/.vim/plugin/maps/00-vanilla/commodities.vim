" autocmd InsertEnter * norm zz

inoremap fd <Esc>
vnoremap fd <Esc>

nnoremap <leader>vrc :e ~/.vim/vimrc<CR>

nnoremap <C-l> zz
inoremap <C-l> <C-o>zz
vnoremap <C-l> zz

nnoremap <silent> <leader>nb :set relativenumber!<CR>

" Quick format of text
inoremap <c-k> <Esc>gqgqA
nnoremap <c-k> gqgqA

" Quick remaps
nnoremap <leader>gg :nnoremap <leader<Space><Left>>gg<Right>

" Make missing directory if needed
nnoremap <Leader>md :call mkdir(expand("%:p:h"), "p")<CR>

inoremap <C-BS> <C-w>
