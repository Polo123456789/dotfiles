from-history() {
    local cmd="$(history | awk '{$1=""; print $0}' | sort | uniq |fzf)"
    echo "$cmd"
	echo "$cmd" >> ~/.bash_history
    eval "$cmd"
}

fzff () {
	local file=$1
	shift
	fzf -i $@ < $file
}
