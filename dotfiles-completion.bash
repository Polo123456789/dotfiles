_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles/"

    local cur prev opts dir base_opts stow_opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    base_opts="stow unstow adopt restow add commit push pull status log diff branch-out pull-master"
    stow_opts=$(ls -d ${dotfiles_dir}/*/ | xargs -n1 basename)


    if [[ ${prev} == "dotfiles" ]] ; then
        COMPREPLY=( $(compgen -W "${base_opts}" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "stow" ]] || [[ ${prev} == "unstow" ]] || [[ ${prev} == "adopt" ]] || [[ ${prev} == "restow" ]]; then
        COMPREPLY=( $(compgen -W "$stow_opts" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "add" ]] ; then
        # https://gist.github.com/Polo123456789/b4e08f5467f37fc75ce072db5f228fc9
        COMPREPLY=( $(_compgen_files_relative_to $dotfiles_dir $cur) )
        return 0
    fi
}

complete -o nospace -F _dotfiles dotfiles
