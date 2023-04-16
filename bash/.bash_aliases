alias apt="nala"
alias search-process="ps -ax | grep"
alias exi="exit"
alias ps-server="ssh benisa-personal"
alias ps-server-remoto="ssh benisa-personal-remoto"
alias fc="fc -e nvim"
alias vim="nvim"

save_current_dir() {
    ps_old_dir=$(pwd)
}

back() {
    cd "$ps_old_dir"
}
