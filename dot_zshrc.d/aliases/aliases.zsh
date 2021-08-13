#!/usr/bin/env zsh
if [[ "$OSTYPE" == darwin* ]]; then
    alias ls='ls -FG'
    alias finder='open -a Finder ./'
    if [[ -d /Applications/Yoink.app ]]; then
        alias yoink='open -a Yoink'
    fi
else
    alias ls='ls -F --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias gvim='gvim -f'
fi
