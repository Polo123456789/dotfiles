-- File generated automatically, pending manual migration
-- Sourced from ./compiler/pandoc.vim

vim.cmd [[ 
if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'pandoc'

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

if filereadable('makefile')
    echom "Makefile found, not touching makeprg"
else
    if filereadable('metadata.json')
        echom "Found metadata.json, including it in makeprg"
        CompilerSet makeprg=pandoc\ %\ -o\ %<.pdf\ --metadata-file\ metadata.json
    else
        echom "No metadata.json file found, using only pandoc in makeprg"
        CompilerSet makeprg=pandoc\ %\ -o\ %<.pdf
    endif
endif
]]

-- Generated Tue Apr 23 08:52:50 AM CST 2024
