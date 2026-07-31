if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    $HOME/scripts/resumen_git
elif tasks is-project; then
    tasks summary
else
    cowsay_out=$(/home/pablo/.local/bin/cowsay-random &)
    tasks_out=$(tasks summary --color=true &)
    wait

    echo -e "$cowsay_out"
    echo
    /home/pablo/scripts/check-repos
    echo
    echo -e "$tasks_out"
fi

