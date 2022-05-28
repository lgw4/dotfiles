#!/usr/bin/env zsh

# Configuration variables
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Configuration options
setopt APPEND_HISTORY
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt NO_CASE_GLOB
setopt SHARE_HISTORY
