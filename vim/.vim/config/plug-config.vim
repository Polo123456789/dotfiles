" mucomplete
if !has('nvim')
    " Config del mucomplete por si no tengo coc
    set completeopt+=menuone
    set completeopt+=noselect
    set completeopt+=noinsert
    set shortmess+=c   " Shut off completion messages
    set belloff+=ctrlg " If Vim beeps during completion
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#completion_delay = 1
    inoremap <C-Space> <Esc>:redraw!<CR>a
    
    " Omni Complete
    set omnifunc=syntaxcomplete#Complete
endif

" Airline
"let g:airline_theme='wombat'

" Startify
let g:startify_custom_header = [
    \  " .------..------..------..------..------.",
    \  " |P.--. ||A.--. ||B.--. ||L.--. ||O.--. |",
    \  " | :/\\: || (\\/) || :(): || :/\\: || :/\\: |",
    \  " | (__) || :\\/: || ()() || (__) || :\\/: |",
    \  " | '--'P|| '--'A|| '--'B|| '--'L|| '--'O|",
    \  " '------''------''------''------''------'",
    \  " .------..------..------..------..------..------..------.",
    \  " |S.--. ||A.--. ||N.--. ||C.--. ||H.--. ||E.--. ||Z.--. |",
    \  " | :/\\: || (\\/) || :(): || :/\\: || :/\\: || (\\/) || :(): |",
    \  " | :\\/: || :\\/: || ()() || :\\/: || (__) || :\\/: || ()() |",
    \  " | '--'S|| '--'A|| '--'N|| '--'C|| '--'H|| '--'E|| '--'Z|",
    \  " '------''------''------''------''------''------''------'",
             \]

" Indent line
let g:indentLine_char = '|'

" NERDTree
let g:NERDTreeWinPos = "left"
"au VimEnter *  NERDTree
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Por si no tengo nerdTree a la mano
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Vimwiki
let g:vimwiki_global_ext = 0

" Mini Snip
let g:miniSnip_trigger = "<A-m>"
let g:miniSnip_extends = {
            \ "cpp" : [ "objc", "c" ],
            \ "javascript" : [ "typescript" ],
            \ }

let g:pandoc#spell#enabled = 0
