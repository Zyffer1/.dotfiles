#!/bin/bash

pkgs=(
  yazi
  wezterm
  fd
  ripgrep
  fzf
  bat
  zoxide
  i3-wm
  i3lock
  base-devel
  flatpak
  keyd
  tmux
  zsh
  neovim
  neofetch
  git
  rust
  man
)

missing=()

for pkg in "${pkgs[@]}"; do
  if ! pacman -Q "$pkg" &>/dev/null; then
    missing+=("$pkg")
  fi
done

if ((${#missing[@]} > 0)); then
  sudo pacman -Syu --noconfirm "${missing[@]}"
else
  echo "All packages are already installed."
fi

echo '/usr/bin/zsh' | chsh $USER
