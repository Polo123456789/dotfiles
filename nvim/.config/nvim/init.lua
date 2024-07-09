-- File generated automatically, pending manual migration
-- Sourced from ./vimrc

vim.cmd([[
call plug#begin()

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'dhruvasagar/vim-table-mode'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'Jorengarenar/miniSnip'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'prisma/vim-prisma'
Plug 'wellle/context.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()
]])

-- Generated Tue Apr 23 08:52:50 AM CST 2024
