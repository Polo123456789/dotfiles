if [ -d .git ]; then
    $HOME/scripts/resumen_git
else
    /home/pablo/.local/bin/cowsay-random
    echo
    /home/pablo/scripts/check-repos
fi


