set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if filereadable('~/.vimrc')
	source ~/.vimrc
else
	source ~/.vim/vimrc
endif
