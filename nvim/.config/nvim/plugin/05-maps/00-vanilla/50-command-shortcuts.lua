-- nnoremap <leader>bd :bd<CR>
-- nnoremap <leader><tab> :bn<CR>
-- nnoremap <leader>Rg :%s//g<left><left>
-- nnoremap <leader>Rw *N:%s///g<left><left>
-- vnoremap <leader>R :s//g<left><left>
-- nnoremap <leader>hs :set hlsearch!<CR>

vim.keymap.set('n', '<leader>bd', ':bd<CR>')
vim.keymap.set('n', '<leader><tab>', ':bn<CR>')
vim.keymap.set('n', '<leader>Rg', [[:%s//g<left><left>]])
vim.keymap.set('n', '<leader>Rw', [[*N:%s///g<left><left>]])
vim.keymap.set('v', '<leader>R', ':s//g<left><left>')
vim.keymap.set('n', '<leader>hs', ':set hlsearch!<CR>')
