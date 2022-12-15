if not type -q psql
    and test -d "$HOMEBREW_BASE/opt/libpq/bin"
    fish_add_path -amP $HOMEBREW_BASE/opt/libpq/bin
end
