setlocal textwidth=0
setlocal colorcolumn=120
setlocal noexpandtab

function FormatTempl()
    let cursor = getpos(".")
    :%!templ fmt
    call setpos(".", cursor)
endfunction

augroup templ
    autocmd!
    autocmd BufWritePre *.templ call FormatTempl()
augroup END
