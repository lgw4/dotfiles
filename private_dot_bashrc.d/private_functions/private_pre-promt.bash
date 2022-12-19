# shellcheck shell=bash
_pre_prompt () {
    _bash_history_sync
    echo -ne "\033]0; ${USER}@${HOSTNAME}: $(dirs +0) \007"
}
