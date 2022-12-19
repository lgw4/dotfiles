# shellcheck shell=bash
# Configure Bash history
shopt -s histappend  # Append to the history file, don't overwrite it
shopt -s cmdhist     # Save multi-line commands as one command
HISTSIZE=8192
HISTFILESIZE=8192
HISTCONTROL=erasedups:ignoreboth
HISTIGNORE="bg:clear:env:exit:fg:history:ls:pwd"
HISTTIMEFORMAT='%F %T '

# Taken from https://unix.stackexchange.com/a/48116
_bash_history_sync () {
    builtin history -a
    HISTFILESIZE=$HISTSIZE
    builtin history -c
    builtin history -r
}

history() {
    _bash_history_sync
    builtin history "$@"
}
