# shellcheck shell=bash
# shellcheck disable=SC2103,SC2155,SC2164
if [[ -d "$HOMEBREW_PREFIX/share/npm/bin" ]]; then
    path_append "$HOMEBREW_PREFIX/share/npm/bin"
fi

if [[ -d "$HOME/.nodenv" ]]; then
    export NODENV_ROOT="$HOME/.nodenv"
fi

if [[ -v NODENV_ROOT ]] && [[ -d "$NODENV_ROOT/bin" ]]; then
    path_prepend "$NODENV_ROOT/bin"
    nodenv-update () {
        local current_directory=$(pwd)
        cd "$NODENV_ROOT"
        git fetch
        git pull
        cd plugins
        for directory in $(command ls); do
            printf "Updating %s…\n" "$directory"
            cd "$directory"
            git fetch
            git pull
            cd ..
        done
        cd "$current_directory"
        unset current_directory
    }
fi

if command -v nodenv >/dev/null 2>&1; then
    eval "$(nodenv init -)"
fi
