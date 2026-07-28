#!/bin/bash

cd "$HOME/me/personal/.dotfiles" || exit 1

stow --adopt -t ~ i3 zsh nvim tmux wezterm bat bash picom vim portage

target="/etc/keyd/default.conf"
source="$HOME/me/personal/.dotfiles/default.conf"

if [ ! -L "$target" ]; then
    if [ -e "$target" ]; then
        echo "$target exists and is not a symlink, skipping"
    else
        sudo ln -s "$source" "$target"
    fi
fi
