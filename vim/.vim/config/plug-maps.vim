" Taglist
" nnoremap <leader>Ts :Tlist<CR>

" NERDTree
nnoremap <leader>ee :NERDTreeToggle<CR>

" Tagbar
nnoremap <leader>Ts :TagbarToggle<CR>
nnoremap <leader>Tc :!ctags --c-kinds=+p -R .<CR>

" Undotree
nnoremap <leader>ut :UndotreeToggle<CR>

" FZF
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fh :History
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>ft :Filetypes<CR>

" Fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Git commit -s<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git whatchanged<CR>


" Goyo
nnoremap <leader>Go :Goyo 50%<CR>
nnoremap <leader>Gc :Goyo<CR>

" Repeat
nnoremap <silent> zG zG:silent! call repeat#set("zG", v:count)<CR>

" Copilot
nnoremap <leader>cp :Copilot panel<CR>
nnoremap <leader>cr :Copilot restart<CR>
nnoremap <leader>cd :Copilot disable<CR>
nnoremap <leader>ce :Copilot enable<CR>
