vim.g.NERDTreeWinPos = 'right'
vim.g.NERDTreeDirArrowExpandable = '▸'
vim.g.NERDTreeDirArrowCollapsible = '▾'

-- au VimEnter *  NERDTree
vim.api.nvim_create_autocmd('VimEnter', {
  command = 'wincmd p',
})
vim.api.nvim_create_autocmd('BufEnter', {
  command = [[if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif]],
})
