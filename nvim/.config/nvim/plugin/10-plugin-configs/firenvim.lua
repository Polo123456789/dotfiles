-- File generated automatically, pending manual migration
-- Sourced from ./plugin/10-plugin-configs/firenvim.vim

vim.cmd [[ 
if exists('g:started_by_firenvim')
    set guifont=monospace:h10

    function! FirenvimIframeCliSize()
        set guifont=monospace:h12
        set columns=80
        set lines=24
    endfunction
    command! FirenvimIframeCliSize call FirenvimIframeCliSize()

    let g:firenvim_config = { 
        \ 'globalSettings': {
            \ 'alt': 'all',
        \  },
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'neovim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea',
                \ 'takeover': 'once',
            \ },
        \ }
    \ }


endif
]]

-- Generated Tue Apr 23 08:52:50 AM CST 2024
