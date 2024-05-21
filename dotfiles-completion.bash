
_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles/"

    local cur prev opts dir base_opts stow_opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    base_opts="stow unstow adopt restow branch-out pull-master git"
    stow_opts=$(ls -d ${dotfiles_dir}/*/ | xargs -n1 basename)
	# Not really recomended to do much more, anything more complex should be
	# done directly
	git_opts="status"


    if [[ ${prev} == "dotfiles" ]] ; then
        COMPREPLY=( $(compgen -W "${base_opts}" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "stow" ]] || [[ ${prev} == "unstow" ]] || [[ ${prev} == "adopt" ]] || [[ ${prev} == "restow" ]]; then
        COMPREPLY=( $(compgen -W "$stow_opts" -- ${cur}) )
        return 0
    fi

	if [[ ${prev} == "git" ]]; then
		COMPREPLY=( $(compgen -W "$git_opts" -- ${cur}) )
		return 0
	fi
}

complete -o nospace -F _dotfiles dotfiles
