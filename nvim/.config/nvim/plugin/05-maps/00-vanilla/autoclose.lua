-- File generated automatically, pending manual migration
-- Sourced from ./plugin/05-maps/00-vanilla/autoclose.vim

vim.cmd [[ 
" Probably should be from a plugin, but this has been in my config probably
" since I have started using vim.

inoremap " ""<Esc>i
inoremap "<leader> "

inoremap ' ''<Esc>i
inoremap '<leader> '

inoremap ( ()<Esc>i
inoremap (<CR> (<CR><CR>)<Esc>k"_cc
inoremap (<leader> (

inoremap { {}<Esc>i
inoremap {<CR> {<CR><CR>}<Esc>k"_cc
inoremap {<leader> {

inoremap [ []<Esc>i
inoremap [<CR> [<CR><CR>]<Esc>k"_cc
inoremap [<leader> [

inoremap "" ""
inoremap '' ''
inoremap () ()
inoremap {} {}
inoremap [] []
]]

-- Generated Tue Apr 23 08:52:50 AM CST 2024
