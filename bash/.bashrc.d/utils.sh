back() {
    cd "$OLDPWD"
}

from_history() {
    local cmd="$(history | awk '{$1=""; print $0}' | sort | uniq |fzf)"
    echo $cmd
    history -s "$cmd"
    eval $cmd
}

fzff () {
    fzf -i < $1
}
