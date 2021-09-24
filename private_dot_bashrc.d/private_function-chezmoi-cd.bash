# shellcheck shell=bash
chezmoi_cd() {
    cd "$(chezmoi source-path)" || return 1
}
