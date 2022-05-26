#!/usr/bin/env zsh
chezmoi-cd() {
    cd "$(chezmoi source-path)" || return 1
}
