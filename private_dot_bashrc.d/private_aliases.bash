# shellcheck shell=bash
alias refresh='source ~/.bashrc'
alias ls='ls -FG'
alias finder='open -a Finder ./'
if [[ -d "/Applications/Yoink.app" ]]; then
    alias yoink='open -a Yoink'
fi
