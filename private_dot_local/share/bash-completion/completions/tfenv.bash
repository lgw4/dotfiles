# shellcheck shell=bash
# shellcheck disable=SC2207

_tfenv_completions() {
    COMPREPLY=($(compgen -W "install use uninstall list list-remote version-name init pin" "${COMP_WORDS[1]}"))
}

complete -F _tfenv_completions tfenv
