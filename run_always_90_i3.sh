#!/usr/bin/env sh

# Install xbar
cd "$(chezmoi source-path)/scripts/xbar" || exit 1
go install

# Install xpower
cd "$(chezmoi source-path)/scripts/xpower" || exit 1
go install

i3-msg restart
