#!/usr/bin/env zsh
# PATH management functions
path_remove () {
    path=("${(@)path:#$1}")
    typeset -U PATH path
    export PATH
}

path_append () {
    path_remove "$1"
    path+=("$1")
    typeset -U PATH path
    export PATH
}

path_prepend () {
    path_remove "$1"
    path=("$1" "$path[@]")
    typeset -U PATH path
    export PATH
}
