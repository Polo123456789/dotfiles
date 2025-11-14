if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    $HOME/scripts/resumen_git
else
    /home/pablo/.local/bin/cowsay-random
    echo
    /home/pablo/scripts/check-repos
fi


