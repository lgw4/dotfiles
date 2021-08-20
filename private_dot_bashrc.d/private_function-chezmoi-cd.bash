# shellcheck shell=bash
chezmoi-cd() {
    cd "$(chezmoi source-path)" || return 1
}
