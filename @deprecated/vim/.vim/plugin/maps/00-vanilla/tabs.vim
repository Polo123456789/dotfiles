nnoremap <leader>tn :tabnew 
nnoremap <leader>tl :tabn<CR>
nnoremap <leader>th :tabp<CR>
if has('nvim')
    nnoremap te :tabnew<CR>:term<CR>
else
    " Leave a small buffer at the bottom to be able to switch tabs
    " ... dumb
    nnoremap <leader>te :tabnew<CR>:term<CR><c-w>j:resize 1<CR><c-w>k
endif
