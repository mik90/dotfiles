#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1="\@ \[\e[96m\]\u\[\e[m\]\[\e[97m\]@\[\e[m\]\[\e[96m\]\h\[\e[m\]:\W \[\e[97m\]\\$\[\e[m\] "

PATH=/home/mike/.gem/ruby/2.5.0/bin:$PATH
export PATH

LS_COLORS=$LS_COLORS:'di=1;96:*.cpp=92:*.c=92:*.rb=92:*.java=92:ln=1;4;32'
export LS_COLORS

[ -e ~/.dircolors ] && eval $(dircolors -b ~/.dircolors) ||
	eval $(dircolors -b)

# fzf fuzzy completion
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
