#!/usr/bin/env zsh
export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
export HISTSIZE=20000
export SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt INC_APPEND_HISTORY
