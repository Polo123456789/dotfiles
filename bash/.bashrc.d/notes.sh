#!/bin/bash

notes_dir="$HOME/docs/.notes/"

n() {
    local current_dir=$(pwd)
    local note_path=""
    local note_dir=""
    if [ -z "$1" ]; then
        # Use fzf to open the notes
        cd "$notes_dir"
        note_path=$(fzf --reverse)
        note_dir=$(dirname "$note_path")
        note_path=$(basename "$note_path")
    else
        note_path="$notes_dir/$1"
        note_dir=$(dirname "$note_path")

        if [ ! -d "$note_dir" ]; then
            mkdir -p "$note_dir"
        fi
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


