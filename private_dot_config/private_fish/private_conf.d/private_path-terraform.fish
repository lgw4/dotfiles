if test -d "$HOME/.tfenv"
    set -x TFENV_ROOT $HOME/.tfenv
    path_prepend $TFENV_ROOT/bin
    if type -q tfenv
        and not contains $TFENV_ROOT/shims $PATH
        and status --is-interactive
        tfenv init - | source
    end
    function tfenv_update -d "Update tfenv installation"
        cd $TFENV_ROOT
        git fetch
        git pull origin master
        cd $HOME
    end
end
