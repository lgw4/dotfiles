# shellcheck shell=bash
set_win_title () {
    echo -ne "\033]0; ${USER}@${HOSTNAME}: $(dirs +0) \007"
}
