#!/usr/bin/env zsh
set_window_title () {
     echo -ne "\033]0; ${USER}@${HOST}: $(dirs) \007"
}
