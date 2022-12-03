fish_add_path -mpP /usr/local/sbin
fish_add_path -mpP /usr/local/bin

if test (uname) = Darwin
    if test (/usr/bin/arch) = arm64
        and not test -f /usr/local/bin/brew
        set -x HOMEBREW_ROOT /opt/homebrew
    else
        set -x HOMEBREW_ROOT /usr/local
    end

    if test "$HOMEBREW_ROOT" = /opt/homebrew
        fish_add_path -mpP /opt/homebrew/sbin
        fish_add_path -mpP /opt/homebrew/bin
    end

    if test -n "$HOMEBREW_ROOT"
        set -x HOMEBREW_CASK_OPTS --appdir=~/Applications
    end
end

if test (uname) = Linux
    if test -e /etc/debian_version
        fish_add_path -mpP /sbin
        fish_add_path -mpP /usr/sbin
    end
end
