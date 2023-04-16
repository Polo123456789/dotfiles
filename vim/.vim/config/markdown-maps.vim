function! MarkdownMaps()
    "Creacion de Headers
    nnoremap <localleader>nc :set conceallevel=0<CR>
    nnoremap <leader>mh0 "zY"zpVr="zyyk"zP
    nnoremap <leader>mh1 "zY"zpVr=
    nnoremap <leader>mh2 "zY"zpVr-
    inoremap <localleader>1 <Esc>"zY"zpVr=o<C-j>
    inoremap <localleader>2 <Esc>"zY"zpVr-o<C-j>
    inoremap <localleader><leader> <localleader>

    " Para crear una archivo de un link
    nnoremap <localleader>cf "zyi(:e %:h/<c-r>z<cr>
    " Para ir al archivo que esta debajo del cursor usa gF

    " Items de listas
    inoremap <localleader>li <Esc>"zyy"zp<c-a>f.ll"_C
    nnoremap <localleader>li "zyy"zp<c-a>f.ll"_C
    inoremap <localleader>ui <c-j>*<Space>
    nnoremap <localleader>ui o*<Space>
    inoremap <localleader>cs <Esc>gqgqI> <Esc>A

    if filereadable('makefile')
        echom "Makefile found, not touching makeprg"
    else
        if filereadable('metadata.json')
            echom "Found metadata.json, including it in makeprg"
            setlocal makeprg=pandoc\ %\ -o\ %<.pdf\ --metadata-file\ metadata.json
        else
            echom "No metadata.json file found, using only pandoc in makeprg"
            setlocal makeprg=pandoc\ %\ -o\ %<.pdf
        endif
    endif
endfunction
command MarkMode call MarkdownMaps()

augroup filetypeMarkdown
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.rst call MarkdownMaps()
augroup END
