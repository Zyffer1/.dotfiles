#!/bin/bash

git add .
git commit -m "hello"
git push -u origin main

mkdir -p "$HOME/bk"
cp -r "$PWD" "$HOME/bk"

sudo cp -rf /home/idk/.dotfiles /root/
