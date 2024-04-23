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
