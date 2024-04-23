-- File generated automatically, pending manual migration
-- Sourced from ./after/ftplugin/rst.vim

vim.cmd [[ 
" Load pandoc config too
runtime! ftplugin/pandoc/*.vim

inoremap <buffer> <localleader>3 <Esc>"zY"zpVr~o<C-j>
inoremap <buffer> <localleader>4 <Esc>"zY"zpVr^o<C-j>
inoremap <buffer> <localleader>5 <Esc>"zY"zpVr'o<C-j>
]]

-- Generated Tue Apr 23 08:52:50 AM CST 2024
