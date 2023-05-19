call plug#begin()

"Plug 'vim-scripts/taglist.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'mattn/emmet-vim'
if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
else
"   Plug 'lifepillar/vim-mucomplete'
endif

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'junegunn/goyo.vim'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax' 
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'Polo123456789/vim-wombat-scheme'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'Jorengarenar/miniSnip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'prisma/vim-prisma'
Plug 'github/copilot.vim'

call plug#end()
