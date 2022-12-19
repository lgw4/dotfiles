# shellcheck shell=bash
# Configure Bash history
shopt -s histappend  # Append to the history file, don't overwrite it
shopt -s cmdhist  # Save multi-line commands as one command
export HISTSIZE=8192
export HISTFILESIZE=8192
export HISTCONTROL=erasedups:ignoreboth
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
export HISTTIMEFORMAT='%F %T '

# Taken from https://unix.stackexchange.com/a/48116
_bash_history_sync () {
    builtin history -a         #1
    HISTFILESIZE=$HISTSIZE     #2
    builtin history -c         #3
    builtin history -r         #4
}

history() {                  #5
    _bash_history_sync
    builtin history "$@"
}
