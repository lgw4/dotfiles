#!/usr/bin/env zsh
if [[ -v TFENV_ROOT ]] &&(( $+commands[terraform] )); then
    complete -o nospace -C "$TFENV_ROOT"/bin/terraform terraform
fi
