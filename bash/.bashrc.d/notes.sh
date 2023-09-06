#!/bin/bash

notes_dir="$HOME/docs/.notes/"

n() {
    local note_path="$notes_dir/$1"
    local note_dir=$(dirname "$note_path")
    local current_dir=$(pwd)

    if [ ! -d "$note_dir" ]; then
        mkdir -p "$note_dir"
    fi

    cd "$note_dir"
    nvim "$note_path"
    cd "$current_dir"
}

_n() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    # https://gist.github.com/Polo123456789/b4e08f5467f37fc75ce072db5f228fc9
    COMPREPLY=( $(_compgen_files_relative_to "$notes_dir" "$cur") )
}

complete -o nospace -F _n n


