#!/usr/bin/env zsh
path_append () {
    path+=("$1")
    typeset -U PATH path
    export PATH
}

path_prepend () {
    path=("$1" "$path[@]")
    typeset -U PATH path
    export PATH
}
