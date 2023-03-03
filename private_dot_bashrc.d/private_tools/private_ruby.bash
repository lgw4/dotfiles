# shellcheck shell=bash
# shellcheck disable=SC2103,SC2155,SC2164
if [[ -d "$HOME/.rbenv" ]]; then
    export RBENV_ROOT="$HOME/.rbenv"
fi

if [[ -v RBENV_ROOT ]] && [[ -d "$RBENV_ROOT/bin" ]]; then
    path_prepend "$RBENV_ROOT/bin"
    rbenv-update () {
        local current_directory=$(pwd)
        cd "$RBENV_ROOT"
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

if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi
