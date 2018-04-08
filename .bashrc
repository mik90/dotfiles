#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

PATH=/home/mike/.gem/ruby/2.5.0/bin:$PATH
export PATH

LS_COLORS=$LS_COLORS:'di=37:*.cpp=92:*.c=92:*.rb=92:*.java=92'
export LS_COLORS
