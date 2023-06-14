# These two are here only because of muscle memory, pushd and popd are better
save_current_dir() {
    ps_old_dir=$(pwd)
}

back() {
    cd "$ps_old_dir"
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
