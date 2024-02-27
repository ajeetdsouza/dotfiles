if status is-interactive
    zoxide init fish | source

    # Setup for zoxide development.
    source "$HOME/ws/zoxide/contrib/completions/zoxide.fish"
end
