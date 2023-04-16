autocmd FileType html,tsx,jsx,vue,php setlocal colorcolumn=120 textwidth=0

" UTF para .org
function s:setEncodingUTF()
    set fileencoding=utf8
    set encoding=utf-8
endfunction
autocmd BufRead,BufNewFile *.org call s:setEncodingUTF()

" De header a cpp
"function s:implToH()
"    nnoremap <leader>ti :e<Space>%<.cpp<CR>
"    nnoremap <leader>td :e<Space>%<.hpp<CR>
"endfunction
"autocmd BufRead,BufNewFile *.cpp,*.hpp call s:implToH()

function! UseSystemClipboard()
    setlocal clipboard+=unnamed
endfunction
call UseSystemClipboard()
command SystemClip call UseSystemClipboard()

" Porque los tsx no los toma correctamente
function s:UseTypescript()
    set syntax=typescript
    set colorcolumn=120
    set textwidth=0
endfunction
autocmd BufRead,BufNewFile *.tsx call s:UseTypescript()

function! RstMaps()
    "Creacion de Headers
    inoremap <localleader>3 <Esc>"zY"zpVr~o<C-j>
    inoremap <localleader>4 <Esc>"zY"zpVr^o<C-j>
    inoremap <localleader>5 <Esc>"zY"zpVr'o<C-j>
endfunction
autocmd BufRead,BufNewFile *.rst call RstMaps()

" Autocompletar tags en html
" function s:CompleteTags()
"   inoremap <buffer> > ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR>
"   inoremap <buffer> ><Leader> >
"   inoremap <buffer> ><CR> ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><CR><Tab><CR><Up><C-O>$
"   inoremap {% {%%}<Esc>hi
" endfunction
" autocmd BufRead,BufNewFile *.html,*.js,*.xml call s:CompleteTags()
