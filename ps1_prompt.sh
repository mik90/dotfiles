#!/bin/sh

if [ "$UID" == "0" ]; then
    # root
    export PS1="\[\033[38;5;1m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;14m\]\h\[$(tput sgr0)\]:\W \\$ \[$(tput sgr0)\]"
else
    # normal users
    export PS1="\[\033[38;5;14m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;14m\]\h\[$(tput sgr0)\]:\W \\$ \[$(tput sgr0)\]"
fi

