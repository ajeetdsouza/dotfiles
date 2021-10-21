#!/usr/bin/env sh

# Setup for zoxide development.

mkdir -p "$HOME/.local/bin/"
mkdir -p "$HOME/.local/share/man/man1/"

ln -fs "$HOME/ws/zoxide/contrib/completions/zoxide.elv" "$HOME/.local/share/elvish/lib/zoxide.elv"
ln -fs "$HOME/ws/zoxide/target/debug/zoxide" "$HOME/.local/bin/zoxide"
for file in "$HOME"/ws/zoxide/man/*.1; do
    ln -fs "$file" "$HOME/.local/share/man/man1/"
done
