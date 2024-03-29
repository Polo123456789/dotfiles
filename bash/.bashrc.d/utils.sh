back() {
    cd "$OLDPWD"
}

from-history() {
    local cmd="$(history | awk '{$1=""; print $0}' | sort | uniq |fzf)"
    echo $cmd
    history -s "$cmd"
    eval $cmd
}

fzff () {
    fzf -i < $1
}

notify-at() {
    echo notify-send -u critical "$2" | at "$1"
}
