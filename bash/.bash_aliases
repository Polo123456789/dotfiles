alias apt="nala"
alias search-process="ps -ax | grep"
alias exi="exit"
alias ps-server="ssh benisa-personal"
alias ps-server-remoto="ssh benisa-personal-remoto"
alias fc="fc -e nvim"
alias vim="nvim"
alias ..="cd .."
alias today="date -Idate"
alias today-entry="nvim $(date -Idate).md"

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

git_home() {
    cd $(git rev-parse --show-toplevel)
}
