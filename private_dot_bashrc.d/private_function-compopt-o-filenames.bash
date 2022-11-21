# shellcheck shell=bash
# shellcheck disable=SC2015
# From https://github.com/sharfah/dotfiles/blob/master/.bash/.bash_dyncompletion.d/_compopt_o_filenames
# Fixes error from Homebrew's rustc-completion formula, which is from
# https://github.com/roshan/rust-bash-completion
_compopt_o_filenames() {
    type compopt &>/dev/null && compopt -o filenames 2>/dev/null || compgen -f /non-existing-dir/ >/dev/null
}
