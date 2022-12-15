if not type -q psql
    and test -d "$HOMEBREW_PREFIX/opt/libpq/bin"
    fish_add_path -amP $HOMEBREW_PREFIX/opt/libpq/bin
end
