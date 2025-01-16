set textwidth=0
set colorcolumn=120
set noexpandtab

function FormatTempl()
    let cursor = getpos(".")
    :%!templ fmt
    call setpos(".", cursor)
endfunction

augroup templ
    autocmd!
    autocmd BufWritePre *.templ call FormatTempl()
augroup END
