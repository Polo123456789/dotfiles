#!/bin/bash

alias kitten="kitty +kitten"
alias icat="kitty +kitten icat"
alias diff="kitty +kitten diff"
alias hg="kitty +kitten hyperlinked_grep"

# alias ssh="kitty +kitten ssh"
ssh() {
    if [ "$TERM" = "xterm-kitty" ] && [ -z "$ZELLIJ" ] ; then
        kitty +kitten ssh "$@"
    else
        /usr/bin/ssh "$@"
    fi
}
