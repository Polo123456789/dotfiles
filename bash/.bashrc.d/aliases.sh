alias search-process="ps -ax | grep"
alias exi="exit"
alias fc="fc -e nvim"
alias vim="nvim"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias start="kitty"

alias ..="cd .."

alias today="date -Idate"
alias today-entry="nvim $(date -Idate).md"


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias persist-tmp="mv ~/tmp/* ~/.persist-tmp/"
alias restore-tmp="mv ~/.persist-tmp/* ~/tmp/"

alias rds="rclone-drive-sync"

alias select-date="zenity --calendar --date-format='%Y-%m-%d'"

# Last command first argument
alias lfa='history | tail -n 2 | head -n 1 | awk '\''{print $3}'\'''
