# shellcheck shell=bash
# shellcheck disable=SC2207

_tgenv_completions() {
    COMPREPLY=($(compgen -W "install use uninstall list list-remote" "${COMP_WORDS[1]}"))
}

complete -F _tgenv_completions tgenv
