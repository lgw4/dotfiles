if not type -q psql
    and test -d "$HOMEBREW_ROOT/opt/libpq/bin"
    fish_add_path -amP $HOMEBREW_ROOT/opt/libpq/bin
end
