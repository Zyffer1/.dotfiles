#!/bin/bash

git add .
git commit -m "hello"
git push -u origin main

mkdir -p "$HOME/bk"
cp -r "$PWD" "$HOME/bk"

cd "$HOME/.dotfiles" || exit 1

stow i3 zsh nvim tmux scripts alacritty

target="/etc/keyd/default.conf"
source="$HOME/.dotfiles/default.conf"

if [ ! -L "$target" ]; then
    if [ -e "$target" ]; then
        echo "$target exists and is not a symlink, skipping"
    else
        sudo ln -s "$source" "$target"
    fi
fi
