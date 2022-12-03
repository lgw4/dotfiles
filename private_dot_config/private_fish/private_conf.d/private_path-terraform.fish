if test -d "$HOME/.tfenv"
    set -x TFENV_ROOT $HOME/.tfenv
end

if test -n "$TFENV_ROOT" && test -d "$TFENV_ROOT/bin"
    fish_add_path -mpP $TFENV_ROOT/bin
    function tfenv-update -d "Update tfenv installation"
        cd $TFENV_ROOT
        git fetch
        git pull origin master
        cd $HOME
    end
end

if type -q tfenv
    and not contains $TFENV_ROOT/shims $PATH
    and status --is-interactive
    tfenv init - | source
end
