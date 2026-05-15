-- Probably should be from a plugin, but this has been in my config probably
-- since I have started using vim.

vim.keymap.set('i', '"', '""<Esc>i')
vim.keymap.set('i', '"<Leader>', '"')

vim.keymap.set('i', "'", "''<Esc>i")
vim.keymap.set('i', "'<Leader>", "'")

vim.keymap.set('i', '(', '()<Esc>i')
vim.keymap.set('i', '(<CR>', '(<CR><CR>)<Esc>k"_cc')
vim.keymap.set('i', '(<Leader>', '(')

vim.keymap.set('i', '{', '{}<Esc>i')
vim.keymap.set('i', '{<CR>', '{<CR><CR>}<Esc>k"_cc')
vim.keymap.set('i', '{<Leader>', '{')

vim.keymap.set('i', '[', '[]<Esc>i')
vim.keymap.set('i', '[<CR>', '[<CR><CR>]<Esc>k"_cc')
vim.keymap.set('i', '[<Leader>', '[')

vim.keymap.set('i', '""', '""')
vim.keymap.set('i', "''", "''")
vim.keymap.set('i', '()', '()')
vim.keymap.set('i', '{}', '{}')
vim.keymap.set('i', '[]', '[]')
