_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"

    local cur prev opts dir base_opts stow_opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    base_opts="stow unstow add commit push pull status log diff"
    stow_opts=$(ls -d ${dotfiles_dir}/*/ | xargs -n1 basename)


    if [[ ${prev} == "dotfiles" ]] ; then
        COMPREPLY=( $(compgen -W "${base_opts}" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "stow" ]] || [[ ${prev} == "unstow" ]] ; then
        COMPREPLY=( $(compgen -W "$stow_opts" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "add" ]] ; then
        cd ${dotfiles_dir}
        _filedir
        return 0
    fi
}

complete -o nospace -F _dotfiles dotfiles
