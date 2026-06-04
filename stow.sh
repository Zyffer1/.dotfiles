#!/bin/bash

cd "$HOME/.dotfiles" || exit 1

stow -t ~ i3 zsh nvim tmux wezterm bat
sudo stow -t /root/ zsh nvim

target="/etc/keyd/default.conf"
source="$HOME/.dotfiles/default.conf"

if [ ! -L "$target" ]; then
    if [ -e "$target" ]; then
        echo "$target exists and is not a symlink, skipping"
    else
        sudo ln -s "$source" "$target"
    fi
fi
