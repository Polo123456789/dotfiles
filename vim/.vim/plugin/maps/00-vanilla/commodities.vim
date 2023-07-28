" autocmd InsertEnter * norm zz
inoremap fd <Esc>
vnoremap fd <Esc>
nnoremap <leader>vrc :e ~/.vim/vimrc<CR>
nnoremap <C-l> zz
inoremap <C-l> <C-o>zz
vnoremap <C-l> zz

nnoremap <silent> <leader>nb :set relativenumber!<CR>

inoremap <c-k> <Esc>gqgqA
nnoremap <c-k> gqgqA

"
nnoremap <leader>gg :nnoremap <leader<Space><Left>>gg<Right>
