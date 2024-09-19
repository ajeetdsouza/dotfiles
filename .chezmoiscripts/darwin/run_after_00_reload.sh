#!/usr/bin/env bash

set -euxo pipefail

# Restart services
aerospace reload-config
brew services restart borders

# Reset zsh
zsh -c '. "${HOME}/.zgenom/zgenom.zsh" && zgenom reset'

# Install Neovim packages
nvim -es -u "${HOME}/.config/nvim/init.vim" -i NONE +PlugInstall +qa

# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
defaults write com.apple.dock expose-group-apps -bool true && killall Dock

# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# https://nikitabobko.github.io/AeroSpace/goodness#disable-open-animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
