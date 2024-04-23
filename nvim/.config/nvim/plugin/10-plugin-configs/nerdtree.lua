-- File generated automatically, pending manual migration
-- Sourced from ./plugin/10-plugin-configs/nerdtree.vim

vim.cmd [[ 
let g:NERDTreeWinPos = "right"
"au VimEnter *  NERDTree
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
]]

-- Generated Tue Apr 23 08:52:50 AM CST 2024
