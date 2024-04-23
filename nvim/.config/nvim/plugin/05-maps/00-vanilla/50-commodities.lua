-- Great idea from space macs
vim.keymap.set({'i', 'v'}, 'fd', '<Esc>')

vim.keymap.set({'n', 'v'}, '<C-l>', 'zz')
vim.keymap.set({'i'}, '<C-l>', '<C-o>zz')
vim.keymap.set({'n'}, '<leader>nb', ':set relativenumber!<CR>')

-- Text format
vim.keymap.set({'i', 'n'}, '<C-k>', '<Esc>gqgqA')

-- Quick Remaps
vim.keymap.set({'n'}, '<leader>gg', ':nnoremap <leader<Space><Left>>gg<Right>')

-- Make missing directory if needed
vim.keymap.set({'n'}, '<Leader>md', ':call mkdir(expand("%:p:h"), "p")<CR>')

-- For consistency
vim.keymap.set({'i'}, '<C-BS>', '<C-w>')

-- Move to newly created split
vim.keymap.set({'n'}, '<C-w>v', '<C-w>v<C-w>l')
