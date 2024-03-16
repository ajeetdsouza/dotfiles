#!/usr/bin/env bash

# Install RPMFusion repositories
(rpm -qa | grep rpmfusion-free-release &>/dev/null && rpm -qa | grep rpmfusion-nonfree-release) &>/dev/null || {
  sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf config-manager --enable fedora-cisco-openh264
}

# Install packages
sudo dnf groupinstall -y "Development Tools"
sudo dnf group upgrade -y --with-optional Multimedia --allowerasing
sudo dnf install -y \
  arandr \
  arc-theme \
  atool \
  bat \
  blueman \
  dash \
  eza \
  fd-find \
  ffmpeg-free \
  fish \
  flatpak \
  fzf \
  git-delta \
  go \
  libavcodec-freeworld \
  lxappearance \
  mate-polkit \
  neovim \
  nitrogen \
  papirus-icon-theme \
  protobuf-compiler \
  python3 \
  python3-pip \
  qbittorrent \
  ripgrep \
  rofi \
  shellcheck \
  tokei \
  vlc \
  xonsh \
  xsecurelock \
  xz-static \
  zsh

# Install Brave Browser
which brave-browser &>/dev/null || {
  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo dnf install -y brave-browser
}

# Install Docker
which docker &>/dev/null || {
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable --now docker
  sudo groupadd docker
  sudo usermod -aG docker "${USER}"
  newgrp docker
}

# Install GitHub CLI
which gh &>/dev/null || {
  sudo dnf install 'dnf-command(config-manager)'
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install -y gh
}

# Install Rust
which cargo &>/dev/null || {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# Install safeeyes
sudo dnf install -y libappindicator-gtk3 python3-psutil
pip3 install safeeyes --user
sudo gtk-update-icon-cache /usr/share/icons/hicolor

# Install VS Code
which code &>/dev/null || {
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf -y install code
}

# Cargo
cargo install --locked \
  atuin \
  cargo-msrv \
  cargo-outdated \
  nu \
  vivid
cargo install --locked --git 'https://github.com/roosta/i3wsr' --tag 'v3.0.0'

# Go
go install -v src.elv.sh/cmd/elvish@latest

# Flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y com.spotify.Client md.obsidian.Obsidian

# Manually install
# - MEGAsync (Flatpak keeps crashing)
# - PowerShell
