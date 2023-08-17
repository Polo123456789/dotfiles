#!/bin/bash

notes_dir="$HOME/docs/.notes"

n() {
    local note_path="$notes_dir/$1"
    local note_dir=$(dirname "$note_path")

    if [ ! -d "$note_dir" ]; then
        mkdir -p "$note_dir"
    fi

    nvim "$note_path"
}

_n() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    cd "$notes_dir"
    _filedir
    cd $OLDPWD
}

complete -o nospace -F _n n


