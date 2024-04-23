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
