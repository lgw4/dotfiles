# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091,SC2155
if ((BASH_VERSINFO[0] > 3)); then
    shopt -s autocd
    shopt -s cdspell
    shopt -s dirspell
    shopt -s globstar
fi

# Set macOS Homebrew installation root
if [[ "$OSTYPE" == darwin* ]]; then
    if [[ $(arch) == "arm64" ]]; then
        export HOMEBREW_ROOT="/opt/homebrew"
    else
        export HOMEBREW_ROOT="/usr/local"
    fi
fi

# Import files from ${HOME}/.bashrc.d
if [[ -d "$HOME"/.bashrc.d ]]; then
    for config in "$HOME"/.bashrc.d/*.bash; do
        [[ -r "$config" ]] || continue
        source "$config"
    done
    unset -v config
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=50000

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=erasedups:ignoreboth

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# macOS settings
if [[ "$OSTYPE" == darwin* ]]; then
    if [[ -d "$HOMEBREW_ROOT" ]] && command -v brew >/dev/null 2>&1; then
        # Set Homebrew Cask default Applications directory
        export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
        # Enable bash-completion with Homebrew
        export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_ROOT/etc/bash_completion.d"
        if [[ -f "$HOMEBREW_ROOT/etc/profile.d/bash_completion.sh" ]]; then
            source "$HOMEBREW_ROOT/etc/profile.d/bash_completion.sh"
        fi
    fi
# GNU/Linux settings
elif [[ -f /etc/profile.d/bash_completion.sh ]] && ! shopt -oq posix; then
    source /etc/profile.d/bash_completion.sh
elif [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Enable pipx
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# Enable Starship
# shellcheck disable=SC2034
if command -v starship >/dev/null 2>&1; then
    starship_precmd_user_func="set_win_title"
    eval "$(starship init bash)"
else
    export PROMPT_COMMAND=set_win_title
    export PROMPT_DIRTRIM=1
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

# iTerm2 shell integration
if [[ -e "$HOME/.iterm2_shell_integration.bash" ]]; then
    source "$HOME/.iterm2_shell_integration.bash"
fi
