#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/me/personal/.dotfiles" || exit 1

packages=(
    i3
    zsh
    nvim
    tmux
    wezterm
    bat
    opencode
    bash
    picom
    vim
)

stow --restow -t ~ "${packages[@]}"

if . /etc/os-release && [[ "$NAME" == "Gentoo" ]]; then
  sudo stow --restow -v -t / portage
fi

target="/etc/keyd/default.conf"
source="$HOME/me/personal/.dotfiles/default.conf"

if [ -L "$target" ]; then
    current_source="$(readlink "$target")"
    if [ "$current_source" != "$source" ]; then
        echo "$target points to $current_source, expected $source"
    fi
elif [ -e "$target" ]; then
    echo "$target exists and is not a symlink, skipping"
else
    sudo ln -s "$source" "$target"
fi
