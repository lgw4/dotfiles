if test -d "$HOME/.tfenv"
    set -x TFENV_ROOT $HOME/.tfenv
end

if test -n "$TFENV_ROOT" && test -d "$TFENV_ROOT/bin"
    fish_add_path -mpP $TFENV_ROOT/bin
    function tfenv-update -d "Update tfenv installation"
        set current_directory (pwd)
        printf "Updating tfenv…\n"
        cd $TFENV_ROOT
        git fetch
        git pull
        cd $current_directory
        set -u current_directory
    end
end

if type -q tfenv && status --is-interactive
    tfenv init - | source
end
